import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart'
    show CustomSnackBar, SnackBarType;
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/errand_entity.dart';
import '../../domain/enums/errand_status.dart';
import '../providers/errand_provider.dart';

class ErrandSearchingScreen extends ConsumerStatefulWidget {
  final ErrandEntity errand;

  const ErrandSearchingScreen({super.key, required this.errand});

  @override
  ConsumerState<ErrandSearchingScreen> createState() =>
      _ErrandSearchingScreenState();
}

class _ErrandSearchingScreenState extends ConsumerState<ErrandSearchingScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Timer? _pollingTimer;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  // Default to Lagos, Nigeria
  static const LatLng _defaultLocation = LatLng(6.5244, 3.3792);

  // Map elements
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  Set<Polyline> _polylines = {};

  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the search effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Rotation for the center icon
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Set locations from errand
    _setupLocations();

    // Set the current errand in state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(errandNotifierProvider.notifier).setCurrentErrand(widget.errand);
    });

    // Start polling for rider assignment
    _startPolling();
  }

  void _setupLocations() {
    if (widget.errand.pickupLatitude != null &&
        widget.errand.pickupLongitude != null) {
      _pickupLocation = LatLng(
        widget.errand.pickupLatitude!,
        widget.errand.pickupLongitude!,
      );
    }
    if (widget.errand.dropoffLatitude != null &&
        widget.errand.dropoffLongitude != null) {
      _dropoffLocation = LatLng(
        widget.errand.dropoffLatitude!,
        widget.errand.dropoffLongitude!,
      );
    }

    _updateMapElements();
  }

  void _updateMapElements() {
    if (_pickupLocation == null || _dropoffLocation == null) return;

    _markers = {
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Pickup',
          snippet: widget.errand.pickupAddress,
        ),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoffLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Dropoff',
          snippet: widget.errand.dropoffAddress,
        ),
      ),
    };

    // Add pulsing circle around pickup
    _circles = {
      Circle(
        circleId: const CircleId('pickup_pulse'),
        center: _pickupLocation!,
        radius: 300,
        fillColor: AppColor.primary.withAlpha(30),
        strokeColor: AppColor.primary.withAlpha(80),
        strokeWidth: 2,
      ),
    };

    // Add polyline connecting pickup and dropoff
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_pickupLocation!, _dropoffLocation!],
        color: AppColor.primary,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };
  }

  void _fitMapToBounds() {
    if (_mapController == null ||
        _pickupLocation == null ||
        _dropoffLocation == null) {
      return;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(
        min(_pickupLocation!.latitude, _dropoffLocation!.latitude),
        min(_pickupLocation!.longitude, _dropoffLocation!.longitude),
      ),
      northeast: LatLng(
        max(_pickupLocation!.latitude, _dropoffLocation!.latitude),
        max(_pickupLocation!.longitude, _dropoffLocation!.longitude),
      ),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _checkErrandStatus();
    });
  }

  Future<void> _checkErrandStatus() async {
    try {
      await ref
          .read(errandNotifierProvider.notifier)
          .fetchErrand(widget.errand.id);

      if (!mounted) return;

      final state = ref.read(errandNotifierProvider);
      final currentErrand = state.currentErrand;

      if (currentErrand == null) return;

      // Check if rider has been assigned
      if (currentErrand.status == ErrandStatus.accepted ||
          currentErrand.status == ErrandStatus.pickedUp ||
          currentErrand.status == ErrandStatus.inTransit) {
        _pollingTimer?.cancel();

        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            RouteNames.errandTrackingRoute,
            arguments: {'errand': currentErrand},
          );
        }
      }
    } catch (e) {
      // Continue polling on error
      logMessage('ErrandSearchingScreen', 'Polling error: $e');
    }
  }

  Future<void> _cancelErrand() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Errand?'),
        content: const Text('Are you sure you want to cancel this errand?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      final result = await ref
          .read(errandNotifierProvider.notifier)
          .cancelErrand(widget.errand.id);

      if (result != null && mounted) {
        _pollingTimer?.cancel();
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _pollingTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(errandNotifierProvider);

    ref.listen(errandNotifierProvider, (prev, next) {
      if (!mounted) return;
      if (next.errorMessage != null &&
          prev?.errorMessage != next.errorMessage) {
        CustomSnackBar.show(
          context,
          message: next.errorMessage!,
          type: SnackBarType.error,
        );
        Future.microtask(() {
          if (mounted) {
            ref.read(errandNotifierProvider.notifier).clearMessages();
          }
        });
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLocation ?? _defaultLocation,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              Future.delayed(const Duration(milliseconds: 500), _fitMapToBounds);
            },
            markers: _markers,
            circles: _circles,
            polylines: _polylines,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
          ),

          // Radar animation overlay
          if (_pickupLocation != null)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _RadarPainter(
                        progress: _pulseController.value,
                        center: Offset(
                          MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height / 2 - 120,
                        ),
                        color: AppColor.primary,
                      ),
                    );
                  },
                ),
              ),
            ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildBackButton(),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColor.primary,
                              ),
                            ),
                          ),
                          horizontalSpace(8),
                          const BodySmall(
                            'Finding rider...',
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSheet(state),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        _pollingTimer?.cancel();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
      ),
    );
  }

  Widget _buildBottomSheet(dynamic state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          verticalSpace(20),

          // Animated search indicator
          _buildSearchIndicator(),

          verticalSpace(20),

          // Status text
          const BodyText(
            'Finding a Rider',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),

          verticalSpace(8),

          const Caption(
            'We\'re looking for nearby riders to pick up your package',
            color: AppColor.lightText,
            textAlign: TextAlign.center,
          ),

          verticalSpace(24),

          // Location info
          _buildLocationInfo(),

          verticalSpace(24),

          // Cancel button
          CustomButton(
            title: state.isCancelling ? 'Cancelling...' : 'Cancel Search',
            borderRadius: 30,
            color: AppColor.kipaGrey.withAlpha(50),
            textColor: AppColor.primaryText,
            isLoading: state.isCancelling,
            onTap: state.isCancelling ? null : _cancelErrand,
          ),

          verticalSpace(16),
        ],
      ),
    );
  }

  Widget _buildSearchIndicator() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing circles
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final delay = index * 0.33;
                final adjustedValue = (_pulseController.value + delay) % 1.0;
                final scale = 0.6 + (adjustedValue * 0.8);
                final opacity = 1.0 - adjustedValue;

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.primary.withAlpha((opacity * 150).toInt()),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Center icon
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * pi,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withAlpha(80),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.delivery_dining,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildLocationRow(
            icon: Icons.gps_fixed,
            iconColor: Colors.green,
            label: 'Pickup',
            address: widget.errand.pickupAddress,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 11),
            child: Column(
              children: List.generate(
                3,
                (index) => Container(
                  width: 2,
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  color: AppColor.lightText.withAlpha(100),
                ),
              ),
            ),
          ),

          _buildLocationRow(
            icon: Icons.location_on_rounded,
            iconColor: Colors.red,
            label: 'Dropoff',
            address: widget.errand.dropoffAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String address,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Caption(label, color: AppColor.lightText),
              BodySmall(
                address,
                fontWeight: FontWeight.w500,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom painter for radar effect on map
class _RadarPainter extends CustomPainter {
  final double progress;
  final Offset center;
  final Color color;

  _RadarPainter({
    required this.progress,
    required this.center,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw 3 expanding circles
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.33;
      final adjustedProgress = (progress + delay) % 1.0;
      final radius = 40 + (adjustedProgress * 120);
      final opacity = (1.0 - adjustedProgress) * 0.4;

      final paint = Paint()
        ..color = color.withAlpha((opacity * 255).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
