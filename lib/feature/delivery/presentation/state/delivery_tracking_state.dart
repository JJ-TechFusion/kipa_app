import '../../domain/entities/delivery_entities.dart';

/// State for delivery tracking
class DeliveryTrackingState {
  final DeliveryJobEntity? job;
  final RiderLocationEntity? riderLocation;
  final LocationHistoryEntity? locationHistory;
  final List<ChatMessageEntity> messages;
  final List<NearbyRiderEntity> nearbyRiders;
  final bool isConnected;
  final bool isLoading;
  final bool isFetchingLocation;
  final bool isFetchingLocationHistory;
  final String? errorMessage;

  const DeliveryTrackingState({
    this.job,
    this.riderLocation,
    this.locationHistory,
    this.messages = const [],
    this.nearbyRiders = const [],
    this.isConnected = false,
    this.isLoading = false,
    this.isFetchingLocation = false,
    this.isFetchingLocationHistory = false,
    this.errorMessage,
  });

  DeliveryTrackingState copyWith({
    DeliveryJobEntity? job,
    RiderLocationEntity? riderLocation,
    LocationHistoryEntity? locationHistory,
    List<ChatMessageEntity>? messages,
    List<NearbyRiderEntity>? nearbyRiders,
    bool? isConnected,
    bool? isLoading,
    bool? isFetchingLocation,
    bool? isFetchingLocationHistory,
    String? errorMessage,
  }) {
    return DeliveryTrackingState(
      job: job ?? this.job,
      riderLocation: riderLocation ?? this.riderLocation,
      locationHistory: locationHistory ?? this.locationHistory,
      messages: messages ?? this.messages,
      nearbyRiders: nearbyRiders ?? this.nearbyRiders,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      isFetchingLocationHistory:
          isFetchingLocationHistory ?? this.isFetchingLocationHistory,
      errorMessage: errorMessage,
    );
  }
}
