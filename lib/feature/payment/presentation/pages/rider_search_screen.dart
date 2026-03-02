import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kipa/core/services/location/google_places_service.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/utils/map_marker_generator.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/feature/delivery/domain/entities/delivery_entities.dart';
import '../providers/payment_provider.dart';

const String _googleMapsApiKey = 'AIzaSyDGctg74O3Vwa0IP_o2Eh2xwKe5CSuz-k0';

class RiderSearchScreen extends ConsumerStatefulWidget {
  final String paymentRequestId;
  // Optional initial data - if provided, skip fetching from state
  final String? pickupAddress;
  final String? dropoffAddress;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;

  const RiderSearchScreen({
    super.key,
    required this.paymentRequestId,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
  });

  @override
  ConsumerState<RiderSearchScreen> createState() => _RiderSearchScreenState();
}

class _RiderSearchScreenState extends ConsumerState<RiderSearchScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Timer? _pollingTimer;
  late GooglePlacesService _placesService;

  // Animation controllers
  late AnimationController _pulseController;

  // Default to Lagos, Nigeria
  static const LatLng _defaultLocation = LatLng(6.5244, 3.3792);

  // Markers and map state
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  Set<Polyline> _polylines = {};

  // Payment request data
  String? _pickupAddress;
  String? _dropoffAddress;
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  bool _isLoadingLocations = true;

  // Custom marker icons
  BitmapDescriptor? _pickupMarkerIcon;
  BitmapDescriptor? _dropoffMarkerIcon;

  @override
  void initState() {
    super.initState();

    _placesService = GooglePlacesService(apiKey: _googleMapsApiKey);

    // Pulse animation for the search effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Create custom markers
    _createCustomMarkers();

    // Fetch payment request details and geocode addresses
    _fetchPaymentDetails();
    _startPolling();
  }

  Future<void> _createCustomMarkers() async {
    _pickupMarkerIcon = await MapMarkerGenerator.createPickupMarker();
    _dropoffMarkerIcon = await MapMarkerGenerator.createDropoffMarker();
    if (mounted) setState(() {});
  }

  Future<void> _fetchPaymentDetails() async {
    // First, check if data was passed directly via widget parameters
    if (widget.pickupAddress != null && widget.dropoffAddress != null) {
      _pickupAddress = widget.pickupAddress;
      _dropoffAddress = widget.dropoffAddress;

      if (widget.pickupLat != null && widget.pickupLng != null) {
        _pickupLocation = LatLng(widget.pickupLat!, widget.pickupLng!);
      }
      if (widget.dropoffLat != null && widget.dropoffLng != null) {
        _dropoffLocation = LatLng(widget.dropoffLat!, widget.dropoffLng!);
      }

      // If coordinates available, use them; otherwise geocode
      if (_pickupLocation != null && _dropoffLocation != null) {
        setState(() {
          _isLoadingLocations = false;
          _updateMarkers();
        });
        return;
      } else {
        await _geocodeAddresses();
        return;
      }
    }

    // Fallback: try to get data from paymentRequests state
    final state = ref.read(paymentNotifierProvider);
    final paymentRequests = state.paymentRequests ?? [];

    if (paymentRequests.isEmpty) {
      setState(() => _isLoadingLocations = false);
      return;
    }

    final request = paymentRequests.firstWhere(
      (req) => req.id == widget.paymentRequestId,
      orElse: () => paymentRequests.first,
    );

    _pickupAddress = request.pickupAddress;
    _dropoffAddress = request.dropoffAddress;

    // Use coordinates from backend if available, otherwise geocode
    if (request.pickupLat != null && request.pickupLng != null) {
      _pickupLocation = LatLng(request.pickupLat!, request.pickupLng!);
    }
    if (request.dropoffLat != null && request.dropoffLng != null) {
      _dropoffLocation = LatLng(request.dropoffLat!, request.dropoffLng!);
    }

    // If coordinates not available from backend, geocode the addresses
    if (_pickupLocation == null || _dropoffLocation == null) {
      await _geocodeAddresses();
    } else {
      setState(() {
        _isLoadingLocations = false;
        _updateMarkers();
      });
    }
  }

  Future<void> _geocodeAddresses() async {
    if (_pickupAddress == null || _dropoffAddress == null) {
      setState(() => _isLoadingLocations = false);
      return;
    }

    try {
      // Geocode pickup address
      final pickupResult = await _placesService.geocodeAddress(_pickupAddress!);
      if (pickupResult != null) {
        _pickupLocation = LatLng(pickupResult.latitude, pickupResult.longitude);
      }

      // Geocode dropoff address
      final dropoffResult = await _placesService.geocodeAddress(
        _dropoffAddress!,
      );
      if (dropoffResult != null) {
        _dropoffLocation = LatLng(
          dropoffResult.latitude,
          dropoffResult.longitude,
        );
      }

      if (mounted) {
        setState(() {
          _isLoadingLocations = false;
          _updateMarkers();
        });
      }
    } catch (e) {
      logMessage('RiderSearchScreen', 'Error geocoding addresses: $e');
      if (mounted) {
        setState(() => _isLoadingLocations = false);
      }
    }
  }

  void _updateMarkers() {
    if (_pickupLocation == null || _dropoffLocation == null) return;

    _markers = {
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLocation!,
        anchor: const Offset(0.5, 0.5),
        icon: _pickupMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Pickup',
          snippet: _pickupAddress ?? 'Pickup location',
        ),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoffLocation!,
        anchor: const Offset(0.5, 0.5),
        icon: _dropoffMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Dropoff',
          snippet: _dropoffAddress ?? 'Dropoff location',
        ),
      ),
    };

    // Add pulsing circles around pickup
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

    // Fit map to show both markers
    _fitMapToBounds();
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
      await _checkRiderStatus();
    });
  }

  Future<void> _cancelRiderSearch() async {
    final success = await ref
        .read(paymentNotifierProvider.notifier)
        .cancelRiderSearch(paymentRequestId: widget.paymentRequestId);

    if (success && mounted) {
      _pollingTimer?.cancel();
      Navigator.pop(context);
    }
  }

  Future<void> _checkRiderStatus() async {
    await ref.read(paymentNotifierProvider.notifier).fetchPaymentRequests();

    if (!mounted) return;

    final state = ref.read(paymentNotifierProvider);
    final paymentRequests = state.paymentRequests ?? [];

    if (paymentRequests.isEmpty) return;

    final currentRequest = paymentRequests.firstWhere(
      (req) => req.id == widget.paymentRequestId,
      orElse: () => paymentRequests.first,
    );

    if (currentRequest.status == 'rider_assigned' ||
        currentRequest.status == 'in_delivery' ||
        currentRequest.status == 'delivered') {
      _pollingTimer?.cancel();

      if (mounted) {
        final deliveryJobId =
            state.markReadyResponse?.deliveryJobId ?? currentRequest.id;

        // Use 'accepted' as initial status since we only navigate here when rider is assigned
        // fetchJobDetails will update with actual status after connecting
        final initialJob = DeliveryJobEntity(
          id: deliveryJobId,
          paymentRequestId: currentRequest.id,
          status: 'accepted', // Rider has accepted at this point
          rider: null,
          pickupAddress: currentRequest.pickupAddress ?? '',
          dropoffAddress: currentRequest.dropoffAddress ?? '',
          pickupLat: _pickupLocation?.latitude,
          pickupLng: _pickupLocation?.longitude,
          dropoffLat: _dropoffLocation?.latitude,
          dropoffLng: _dropoffLocation?.longitude,
          estimatedArrival: null,
          createdAt: currentRequest.createdAt,
        );

        Navigator.pushReplacementNamed(
          context,
          RouteNames.deliveryTrackingRoute,
          arguments: {'deliveryJobId': deliveryJobId, 'initialJob': initialJob},
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pollingTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLocation ?? _defaultLocation,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              if (!_isLoadingLocations) {
                _fitMapToBounds();
              }
            },
            markers: _markers,
            circles: _circles,
            polylines: _polylines,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
          ),

          if (_isLoadingLocations)
            Container(
              color: Colors.white.withAlpha(200),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColor.primary),
                    verticalSpace(16),
                    const BodyText('Loading locations...'),
                  ],
                ),
              ),
            ),

          if (_pickupLocation != null && !_isLoadingLocations)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: RadarPainter(
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

          // App bar overlay
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

          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomSheet()),
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

  Widget _buildBottomSheet() {
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
            'Searching for Riders',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),

          verticalSpace(8),

          const Caption(
            'We\'re finding the best rider for your delivery',
            color: AppColor.lightText,
            textAlign: TextAlign.center,
          ),

          verticalSpace(24),

          // Location info
          _buildLocationInfo(),

          verticalSpace(24),

          // Cancel button
          Consumer(
            builder: (context, ref, child) {
              final isCancelling = ref
                  .watch(paymentNotifierProvider)
                  .isCancellingRiderSearch;
              return AnimatedButton(
                onTap: isCancelling ? null : () => _cancelRiderSearch(),
                child: CustomButton(
                  title: isCancelling ? 'Cancelling...' : 'Cancel Search',
                  borderRadius: 30,
                  color: AppColor.kipaGrey.withAlpha(50),
                  textColor: AppColor.primaryText,
                  isLoading: isCancelling,
                ),
              );
            },
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
                        color: AppColor.primary.withAlpha(
                          (opacity * 150).toInt(),
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Center icon
          Container(
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
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardBackground2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildLocationRow(
            icon: Icons.gps_fixed,
            iconColor: AppColor.primary,
            label: 'Pickup',
            address: _pickupAddress ?? 'Loading...',
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
            iconColor: AppColor.kipaGrey2,
            label: 'Dropoff',
            address: _dropoffAddress ?? 'Loading...',
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
class RadarPainter extends CustomPainter {
  final double progress;
  final Offset center;
  final Color color;

  RadarPainter({
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
  bool shouldRepaint(RadarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
