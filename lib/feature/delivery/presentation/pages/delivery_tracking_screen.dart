import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kipa/core/services/location/google_places_service.dart';
import 'package:kipa/core/services/location/directions_service.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/utils/map_marker_generator.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/delivery_entities.dart';
import '../../domain/enums/delivery_status.dart';
import '../providers/delivery_provider.dart';
import '../../../../core/routes/route_names.dart';

const String _googleMapsApiKey = 'AIzaSyDGctg74O3Vwa0IP_o2Eh2xwKe5CSuz-k0';

class DeliveryTrackingScreen extends ConsumerStatefulWidget {
  final String deliveryJobId;
  final DeliveryJobEntity? initialJob;

  const DeliveryTrackingScreen({
    super.key,
    required this.deliveryJobId,
    this.initialJob,
  });

  @override
  ConsumerState<DeliveryTrackingScreen> createState() =>
      _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends ConsumerState<DeliveryTrackingScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  late GooglePlacesService _placesService;
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

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _placesService = GooglePlacesService(apiKey: _googleMapsApiKey);
    _directionsService = DirectionsService(apiKey: _googleMapsApiKey);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(deliveryTrackingProvider.notifier)
          .startTracking(
            jobId: widget.deliveryJobId,
            initialJob: widget.initialJob,
          );

      _geocodeAddresses();
      _loadRiderIcon();
      ref.listenManual(deliveryTrackingProvider.select((state) => state.job), (
        previous,
        next,
      ) {
        if (next != null && mounted) {
          _updateCoordinatesFromJob(next);
        }
      });
    });
  }

  Future<void> _updateCoordinatesFromJob(DeliveryJobEntity job) async {
    bool needsUpdate = false;
    if (job.pickupLat != null && job.pickupLng != null) {
      final newPickup = LatLng(job.pickupLat!, job.pickupLng!);
      if (_pickupLocation != newPickup) {
        _pickupLocation = newPickup;
        needsUpdate = true;
      }
    }
    if (job.dropoffLat != null && job.dropoffLng != null) {
      final newDropoff = LatLng(job.dropoffLat!, job.dropoffLng!);
      if (_dropoffLocation != newDropoff) {
        _dropoffLocation = newDropoff;
        needsUpdate = true;
      }
    }

    if (needsUpdate && mounted) {
      if (_pickupLocation != null &&
          _dropoffLocation != null &&
          _routePoints.isEmpty) {
        await _fetchRoute();
      }

      setState(() {
        _updateMapElements();
      });
      if (_pickupLocation != null && _dropoffLocation != null) {
        _fitMapToBounds();
      }
    }
  }

  Future<void> _loadRiderIcon() async {
    _pickupIcon = await MapMarkerGenerator.createCircleMarker(
      fillColor: MapMarkerGenerator.pickupColor,
    );
    _dropoffIcon = await MapMarkerGenerator.createCircleMarker(
      fillColor: MapMarkerGenerator.dropoffColor,
    );
    if (mounted) setState(() {});
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

  String _calculateETA() {
    final trackingState = ref.read(deliveryTrackingProvider);
    final riderLocation = trackingState.riderLocation;
    final job = trackingState.job;

    if (riderLocation == null) return 'Calculating...';
    if (riderLocation.etaMinutes != null) {
      final etaMinutes = riderLocation.etaMinutes!;
      if (etaMinutes < 1) return 'Arriving now';
      if (etaMinutes == 1) return '1 min';
      return '$etaMinutes mins';
    }
    LatLng? destination;
    if (job?.status != null) {
      final deliveryStatus = DeliveryStatus.fromString(job!.status);
      if (deliveryStatus.isHeadingToPickup) {
        destination = _pickupLocation;
      } else if (deliveryStatus.isHeadingToDropoff) {
        destination = _dropoffLocation;
      }
    }

    if (destination == null) return 'Calculating...';
    final distance = _calculateDistance(
      riderLocation.latitude,
      riderLocation.longitude,
      destination.latitude,
      destination.longitude,
    );
    final averageSpeedKmh = 30.0;
    final etaMinutes = (distance / averageSpeedKmh * 60).round();

    if (etaMinutes < 1) return 'Arriving now';
    if (etaMinutes == 1) return '1 min';
    return '$etaMinutes mins';
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371; // Earth's radius in km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  Future<void> _geocodeAddresses() async {
    final job = widget.initialJob;
    if (job == null) return;

    if (job.pickupLat != null && job.pickupLng != null) {
      _pickupLocation = LatLng(job.pickupLat!, job.pickupLng!);
    } else if (job.pickupAddress.isNotEmpty) {
      final result = await _placesService.geocodeAddress(job.pickupAddress);
      if (result != null) {
        _pickupLocation = LatLng(result.latitude, result.longitude);
      }
    }

    if (job.dropoffLat != null && job.dropoffLng != null) {
      _dropoffLocation = LatLng(job.dropoffLat!, job.dropoffLng!);
    } else if (job.dropoffAddress.isNotEmpty) {
      final result = await _placesService.geocodeAddress(job.dropoffAddress);
      if (result != null) {
        _dropoffLocation = LatLng(result.latitude, result.longitude);
      }
    }

    if (mounted) {
      if (_pickupLocation != null && _dropoffLocation != null) {
        _fetchRoute();
      }

      setState(() {
        _updateMapElements();
      });
    }
  }

  void _updateMapElements() {
    final trackingState = ref.read(deliveryTrackingProvider);
    final riderLocation = trackingState.riderLocation;
    final nearbyRiders = trackingState.nearbyRiders;
    final job = trackingState.job;

    _markers = {};
    if (_pickupLocation != null && _pickupIcon != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLocation!,
          icon: _pickupIcon!,
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(title: 'Pickup'),
        ),
      );
    }
    if (_dropoffLocation != null && _dropoffIcon != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: _dropoffLocation!,
          icon: _dropoffIcon!,
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(title: 'Dropoff'),
        ),
      );
    }
    if (job?.status == 'searching' && nearbyRiders.isNotEmpty) {
      for (final nearbyRider in nearbyRiders) {
        _generateNearbyRiderMarker(nearbyRider);
      }
    }
    if (riderLocation != null) {
      _generateAssignedRiderMarker(riderLocation);
      if (_pickupLocation == null &&
          _dropoffLocation == null &&
          _mapController != null) {
        final riderPos = LatLng(
          riderLocation.latitude,
          riderLocation.longitude,
        );
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(riderPos, 15));
      }
    }
    _polylines = {};
    if (_routePoints.isNotEmpty) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: _routePoints,
          color: AppColor.primary,
          width: 5,
          geodesic: true, // Follow earth's curvature
        ),
      );
    } else {
      final points = <LatLng>[];
      if (_pickupLocation != null) points.add(_pickupLocation!);
      if (riderLocation != null) {
        points.add(LatLng(riderLocation.latitude, riderLocation.longitude));
      }
      if (_dropoffLocation != null) points.add(_dropoffLocation!);

      if (points.length >= 2) {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: AppColor.primary,
            width: 4,
            patterns: [PatternItem.dash(20), PatternItem.gap(10)],
          ),
        );
      }
    }
  }

  Future<void> _generateAssignedRiderMarker(
    RiderLocationEntity riderLocation,
  ) async {
    final heading = riderLocation.heading ?? 0;
    final riderPos = LatLng(riderLocation.latitude, riderLocation.longitude);

    final shouldRegenerate =
        _lastRiderHeading == null || (heading - _lastRiderHeading!).abs() > 10;

    BitmapDescriptor icon;
    if (shouldRegenerate) {
      icon = await MapMarkerGenerator.createRiderMarker(
        fillColor: MapMarkerGenerator.riderColor,
        heading: heading,
        isNearby: false,
      );
      _riderMarkerCache['assigned'] = icon;
      _lastRiderHeading = heading;
    } else {
      icon =
          _riderMarkerCache['assigned'] ??
          await MapMarkerGenerator.createRiderMarker(
            fillColor: MapMarkerGenerator.riderColor,
            heading: heading,
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

  Future<void> _generateNearbyRiderMarker(NearbyRiderEntity nearbyRider) async {
    final icon = await MapMarkerGenerator.createRiderMarker(
      fillColor: MapMarkerGenerator.nearbyRiderColor,
      heading: nearbyRider.heading ?? 0,
      isNearby: true,
    );

    if (mounted) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('nearby_${nearbyRider.riderId}'),
            position: LatLng(nearbyRider.latitude, nearbyRider.longitude),
            icon: icon,
            anchor: const Offset(0.5, 0.5),
            infoWindow: InfoWindow(
              title: 'Available Rider',
              snippet: '${nearbyRider.distanceKm.toStringAsFixed(1)} km away',
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(deliveryTrackingProvider);
    final job = trackingState.job;
    final riderLocation = trackingState.riderLocation;

    if (job != null) {
      if (job.pickupLat != null && job.pickupLng != null) {
        final newPickup = LatLng(job.pickupLat!, job.pickupLng!);
        if (_pickupLocation == null ||
            _pickupLocation!.latitude != newPickup.latitude ||
            _pickupLocation!.longitude != newPickup.longitude) {
          _pickupLocation = newPickup;

          if (_dropoffLocation != null && _routePoints.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _fetchRoute();
            });
          }
        }
      }

      if (job.dropoffLat != null && job.dropoffLng != null) {
        final newDropoff = LatLng(job.dropoffLat!, job.dropoffLng!);
        if (_dropoffLocation == null ||
            _dropoffLocation!.latitude != newDropoff.latitude ||
            _dropoffLocation!.longitude != newDropoff.longitude) {
          _dropoffLocation = newDropoff;

          if (_pickupLocation != null && _routePoints.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _fetchRoute();
            });
          }
        }
      }
    }

    _updateMapElements();

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target:
                  _pickupLocation ??
                  (riderLocation != null
                      ? LatLng(riderLocation.latitude, riderLocation.longitude)
                      : const LatLng(6.5244, 3.3792)),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _fitMapToBounds();
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          if (!trackingState.isConnected && !trackingState.isLoading)
            Positioned(
              top: MediaQuery.of(context).padding.top + 60,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Reconnecting...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
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
                    _buildStatusBadge(job?.status ?? 'Loading'),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSheet(job, riderLocation),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
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

  Widget _buildStatusBadge(String status) {
    final deliveryStatus = DeliveryStatus.fromString(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: deliveryStatus.color.withAlpha(200),
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
            deliveryStatus.label,
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
    DeliveryJobEntity? job,
    RiderLocationEntity? riderLocation,
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
                if (job?.rider != null) _buildETADisplay(),

                verticalSpace(16),

                if (job?.rider != null)
                  _buildRiderCard(job!.rider!)
                else
                  _buildLoadingRiderCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderCard(RiderEntity rider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColor.primary.withAlpha(30),
          child: rider.photoUrl != null
              ? ClipOval(
                  child: Image.network(
                    rider.photoUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, stackTrace) =>
                        Icon(Icons.person, color: AppColor.primary, size: 30),
                  ),
                )
              : Icon(Icons.person, color: AppColor.primary, size: 30),
        ),

        horizontalSpace(16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyText(rider.name, fontWeight: FontWeight.w600),

                      if (rider.vehiclePlate != null) ...[
                        verticalSpace(4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Caption(
                            rider.vehiclePlate!,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.two_wheeler,
                            color: AppColor.lightText,
                            size: 16,
                          ),
                          horizontalSpace(4),
                          Caption(rider.vehicleType),
                        ],
                      ),
                    ],
                  ),
                  _buildActionButtons(rider),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingRiderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardBackground2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColor.primary.withAlpha(30),
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          horizontalSpace(16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText('Loading rider info...', fontWeight: FontWeight.w600),
              Caption('Please wait'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildETADisplay() {
    final trackingState = ref.read(deliveryTrackingProvider);
    final riderLocation = trackingState.riderLocation;
    final job = trackingState.job;

    if (job?.status == null) return const SizedBox.shrink();

    final deliveryStatus = DeliveryStatus.fromString(job!.status);
    if (!deliveryStatus.shouldShowEta) {
      return const SizedBox.shrink();
    }

    final eta = _calculateETA();
    if (eta == 'Calculating...') return const SizedBox.shrink();
    String destinationText = 'arrives';
    if (deliveryStatus.isHeadingToPickup) {
      destinationText = 'arrives at pickup';
    } else if (deliveryStatus.isHeadingToDropoff) {
      destinationText = 'arrives at dropoff';
    }

    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: AppColor.primaryText, fontSize: 14),
              children: [
                const TextSpan(text: 'Rider '),
                TextSpan(
                  text: destinationText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: ' in '),
                TextSpan(
                  text: eta,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (riderLocation?.distanceRemainingKm != null) ...[
          horizontalSpace(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Caption(
              '${riderLocation!.distanceRemainingKm!.toStringAsFixed(1)} km',
              color: AppColor.subtitle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(RiderEntity rider) {
    return Row(
      spacing: 7,
      children: [
        GestureDetector(
          onTap: () => _openChat(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary.withAlpha(20),
            ),
            child: const Icon(
              Icons.chat_bubble_rounded,
              color: AppColor.primaryText,
              size: 12,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _callRider(rider.phone),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary.withAlpha(20),
            ),
            child: const Icon(
              Icons.call,
              color: AppColor.primaryText,
              size: 12,
            ),
          ),
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

  void _openChat() {
    final trackingState = ref.read(deliveryTrackingProvider);
    final rider = trackingState.job?.rider;
    Navigator.of(context).pushNamed(
      RouteNames.chatRoute,
      arguments: {
        'jobId': widget.deliveryJobId,
        'participantName': rider?.name ?? 'Rider',
        'participantPhotoUrl': rider?.photoUrl,
      },
    );
  }

  void _fitMapToBounds() {
    if (_mapController == null) return;

    final points = <LatLng>[];
    if (_pickupLocation != null) points.add(_pickupLocation!);
    if (_dropoffLocation != null) points.add(_dropoffLocation!);

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
}
