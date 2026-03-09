import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/core/services/location/directions_service.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart'
    show CustomSnackBar, SnackBarType;
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/smart_image.dart';
import 'package:kipa/core/utils/map_marker_generator.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../delivery/domain/entities/delivery_entities.dart'
    show RiderEntity;
import '../../domain/entities/errand_entity.dart';
import '../../domain/enums/errand_status.dart';
import '../providers/errand_provider.dart';
import '../widgets/errand_code_display.dart';

const String _googleMapsApiKey = 'AIzaSyDGctg74O3Vwa0IP_o2Eh2xwKe5CSuz-k0';

class ErrandTrackingScreen extends ConsumerStatefulWidget {
  final ErrandEntity errand;

  const ErrandTrackingScreen({super.key, required this.errand});

  @override
  ConsumerState<ErrandTrackingScreen> createState() =>
      _ErrandTrackingScreenState();
}

class _ErrandTrackingScreenState extends ConsumerState<ErrandTrackingScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  late DirectionsService _directionsService;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropoffIcon;
  List<LatLng> _routePoints = [];

  final Map<String, BitmapDescriptor> _riderMarkerCache = {};
  double? _lastRiderHeading;

  @override
  void initState() {
    super.initState();
    _directionsService = DirectionsService(apiKey: _googleMapsApiKey);

    _setupLocations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notifier = ref.read(errandNotifierProvider.notifier);
      notifier.setCurrentErrand(widget.errand);

      _loadMarkerIcons();

      notifier.fetchErrand(widget.errand.id);

      if (widget.errand.deliveryJob != null) {
        notifier.startTracking(widget.errand.deliveryJob!.id);
      }
    });
  }

  Future<void> _loadMarkerIcons() async {
    _pickupIcon = await MapMarkerGenerator.createCircleMarker(
      fillColor: MapMarkerGenerator.pickupColor,
    );
    _dropoffIcon = await MapMarkerGenerator.createCircleMarker(
      fillColor: MapMarkerGenerator.dropoffColor,
    );
    if (mounted) setState(() {});
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

    if (_pickupLocation != null && _dropoffLocation != null) {
      _fetchRoute();
    }

    _updateMapElements();
  }

  Future<void> _fetchRoute() async {
    if (_pickupLocation == null || _dropoffLocation == null) return;

    final routeInfo = await _directionsService.getRouteInfo(
      origin: _pickupLocation!,
      destination: _dropoffLocation!,
    );

    if (routeInfo != null && mounted) {
      setState(() {
        _routePoints = routeInfo.points;
        _updateMapElements();
      });
    }
  }

  void _updateMapElements() {
    final state = ref.read(errandNotifierProvider);
    final errand = state.currentErrand ?? widget.errand;
    final riderLocation = state.riderLocation;

    _markers = {};

    if (_pickupLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLocation!,
          icon:
              _pickupIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          anchor: const Offset(0.5, 0.5),
          infoWindow: InfoWindow(
            title: 'Pickup',
            snippet: errand.pickupAddress,
          ),
        ),
      );
    }

    if (_dropoffLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: _dropoffLocation!,
          icon:
              _dropoffIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          anchor: const Offset(0.5, 0.5),
          infoWindow: InfoWindow(
            title: 'Dropoff',
            snippet: errand.dropoffAddress,
          ),
        ),
      );
    }

    if (riderLocation != null) {
      _generateRiderMarker(
        riderLocation.latitude,
        riderLocation.longitude,
        riderLocation.heading,
      );
    }

    _polylines = {};
    if (_routePoints.isNotEmpty) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: _routePoints,
          color: AppColor.primary,
          width: 5,
          geodesic: true,
        ),
      );
    } else if (_pickupLocation != null && _dropoffLocation != null) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [_pickupLocation!, _dropoffLocation!],
          color: AppColor.primary,
          width: 4,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    }
  }

  Future<void> _generateRiderMarker(
    double lat,
    double lng,
    double? heading,
  ) async {
    final riderHeading = heading ?? 0;
    final riderPos = LatLng(lat, lng);

    final shouldRegenerate =
        _lastRiderHeading == null ||
        (riderHeading - _lastRiderHeading!).abs() > 10;

    BitmapDescriptor icon;
    if (shouldRegenerate) {
      icon = await MapMarkerGenerator.createRiderMarker(
        fillColor: MapMarkerGenerator.riderColor,
        heading: riderHeading,
        isNearby: false,
      );
      _riderMarkerCache['rider'] = icon;
      _lastRiderHeading = riderHeading;
    } else {
      icon =
          _riderMarkerCache['rider'] ??
          await MapMarkerGenerator.createRiderMarker(
            fillColor: MapMarkerGenerator.riderColor,
            heading: riderHeading,
            isNearby: false,
          );
    }

    if (mounted) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('rider'),
            position: riderPos,
            icon: icon,
            anchor: const Offset(0.5, 0.5),
            infoWindow: const InfoWindow(title: 'Your Rider'),
          ),
        );
      });
    }
  }

  void _fitMapToBounds() {
    if (_mapController == null) return;

    final state = ref.read(errandNotifierProvider);
    final riderLocation = state.riderLocation;

    final points = <LatLng>[];

    if (_pickupLocation != null) {
      points.add(_pickupLocation!);
    }
    if (_dropoffLocation != null) {
      points.add(_dropoffLocation!);
    }
    if (riderLocation != null) {
      points.add(LatLng(riderLocation.latitude, riderLocation.longitude));
    }

    if (points.length < 2) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        points.map((p) => p.latitude).reduce(min),
        points.map((p) => p.longitude).reduce(min),
      ),
      northeast: LatLng(
        points.map((p) => p.latitude).reduce(max),
        points.map((p) => p.longitude).reduce(max),
      ),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(errandNotifierProvider);
    final errand = state.currentErrand ?? widget.errand;
    final rider = errand.deliveryJob?.rider;
    final status = errand.status;

    ref.listen(errandNotifierProvider, (prev, next) {
      if (!mounted) return;

      if (next.riderLocation != prev?.riderLocation) {
        logMessage(
          'ErrandTrackingScreen',
          'Rider location updated: ${next.riderLocation?.latitude}, ${next.riderLocation?.longitude}',
        );
        setState(() {
          _updateMapElements();
        });
        _fitMapToBounds();
      }

      if (next.currentErrand != prev?.currentErrand) {
        setState(() {
          _updateMapElements();
        });
        if (next.currentErrand?.deliveryJob != null &&
            prev?.currentErrand?.deliveryJob == null) {
          logMessage(
            'ErrandTrackingScreen',
            'Delivery job assigned, starting tracking',
          );
          ref
              .read(errandNotifierProvider.notifier)
              .startTracking(next.currentErrand!.deliveryJob!.id);
        }
      }

      if (next.currentErrand?.status == ErrandStatus.delivered &&
          prev?.currentErrand?.status != ErrandStatus.delivered) {
        Navigator.pushNamed(
          context,
          RouteNames.errandCompleteRoute,
          arguments: {'errand': next.currentErrand},
        );
      }

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
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLocation ?? const LatLng(6.5244, 3.3792),
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              Future.delayed(
                const Duration(milliseconds: 500),
                _fitMapToBounds,
              );
            },
          ),

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
                    _buildStatusBadge(status),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSheet(errand, rider, status, state),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        ref.read(errandNotifierProvider.notifier).stopTracking();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 10),
          ],
        ),
        child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildStatusBadge(ErrandStatus status) {
    Color bgColor;
    switch (status) {
      case ErrandStatus.accepted:
        bgColor = Colors.blue;
        break;
      case ErrandStatus.pickedUp:
      case ErrandStatus.inTransit:
        bgColor = Colors.orange;
        break;
      case ErrandStatus.delivered:
        bgColor = Colors.green;
        break;
      default:
        bgColor = AppColor.kipaGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(150),
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Text(
            status.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(
    ErrandEntity errand,
    RiderEntity? rider,
    ErrandStatus status,
    dynamic state,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (rider != null) ...[
                  _buildRiderCard(rider, errand),
                  verticalSpace(16),
                ],
                if (errand.deliveryJob?.pickupCode != null &&
                    status == ErrandStatus.accepted) ...[
                  ErrandCodeDisplay(
                    title: 'Pickup Code',
                    code: errand.deliveryJob!.pickupCode!,
                    subtitle: 'Give this code to the rider at pickup',
                    backgroundColor: Colors.green.withAlpha(25),
                  ),
                  verticalSpace(12),
                ],
                if (errand.deliveryJob?.dropoffCode != null &&
                    (status == ErrandStatus.pickedUp ||
                        status == ErrandStatus.inTransit)) ...[
                  ErrandCodeDisplay(
                    title: 'Dropoff Code',
                    code: errand.deliveryJob!.dropoffCode!,
                    subtitle:
                        'Share this code with the rider to confirm delivery',
                    backgroundColor: Colors.blue.withAlpha(25),
                  ),
                  verticalSpace(12),
                ],

                _buildRouteInfo(errand),
                verticalSpace(16),

                if (status.canCancel) ...[
                  OutlinedButton(
                    onPressed: state.isCancelling
                        ? null
                        : () => _showCancelDialog(errand, status),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 10,
                      ),
                      side: const BorderSide(color: AppColor.errorColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.isCancelling
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColor.errorColor,
                            ),
                          )
                        : const BodySmall(
                            'Cancel Errand',
                            color: AppColor.errorColor,
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                ],
                if (status == ErrandStatus.delivered) ...[
                  CustomButton(
                    title: 'Confirm Delivery',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.errandCompleteRoute,
                        arguments: {'errand': errand},
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCancelDialog(
    ErrandEntity errand,
    ErrandStatus status,
  ) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Errand?'),
        content: status == ErrandStatus.accepted
            ? const Text(
                'Cancelling after a rider has been assigned may incur a fee.',
              )
            : const Text('Are you sure you want to cancel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
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
          .cancelErrand(errand.id);

      if (result != null && mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  Widget _buildRiderCard(RiderEntity rider, ErrandEntity errand) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: SmartImage(
            imageUrl: rider.photoUrl ?? '',
            name: rider.name,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        horizontalSpace(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(rider.name, fontWeight: FontWeight.w600),
              verticalSpace(4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  horizontalSpace(4),
                  BodySmall('${rider.rating}', color: AppColor.lightText),
                  horizontalSpace(12),
                  Icon(Icons.motorcycle, size: 16, color: AppColor.lightText),
                  horizontalSpace(4),
                  BodySmall(rider.vehicleType, color: AppColor.lightText),
                ],
              ),
              if (rider.vehiclePlate != null) ...[
                verticalSpace(4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E7FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Caption(
                    rider.vehiclePlate!,
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => _openChat(rider),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_rounded,
                  color: AppColor.primaryText,
                  size: 16,
                ),
              ),
            ),
            horizontalSpace(8),
            GestureDetector(
              onTap: () => _callRider(rider.phone),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone, color: Colors.green, size: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _callRider(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openChat(RiderEntity rider) {
    final errand =
        ref.read(errandNotifierProvider).currentErrand ?? widget.errand;
    if (errand.deliveryJob != null) {
      Navigator.of(context).pushNamed(
        RouteNames.chatRoute,
        arguments: {
          'jobId': errand.deliveryJob!.id,
          'participantName': rider.name,
          'participantPhotoUrl': rider.photoUrl,
          'showSenderNames': false,
        },
      );
    }
  }

  Widget _buildRouteInfo(ErrandEntity errand) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: MapMarkerGenerator.pickupColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: AppColor.kipaGrey.withAlpha(50),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: MapMarkerGenerator.dropoffColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodySmall(
                      errand.pickupAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.darkPrimary,
                    ),
                    verticalSpace(20),
                    BodySmall(
                      errand.dropoffAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.darkPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
