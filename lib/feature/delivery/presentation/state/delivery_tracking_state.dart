import '../../domain/entities/delivery_entities.dart';

/// State for delivery tracking
class DeliveryTrackingState {
  final DeliveryJobEntity? job;
  final RiderLocationEntity? riderLocation;
  final List<ChatMessageEntity> messages;
  final List<NearbyRiderEntity> nearbyRiders;
  final bool isConnected;
  final bool isLoading;
  final String? errorMessage;

  const DeliveryTrackingState({
    this.job,
    this.riderLocation,
    this.messages = const [],
    this.nearbyRiders = const [],
    this.isConnected = false,
    this.isLoading = false,
    this.errorMessage,
  });

  DeliveryTrackingState copyWith({
    DeliveryJobEntity? job,
    RiderLocationEntity? riderLocation,
    List<ChatMessageEntity>? messages,
    List<NearbyRiderEntity>? nearbyRiders,
    bool? isConnected,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DeliveryTrackingState(
      job: job ?? this.job,
      riderLocation: riderLocation ?? this.riderLocation,
      messages: messages ?? this.messages,
      nearbyRiders: nearbyRiders ?? this.nearbyRiders,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
