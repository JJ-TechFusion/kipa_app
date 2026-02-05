import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/constants/api_constants.dart';
import 'package:kipa/core/services/network/api_services.dart';
import 'package:kipa/core/services/network/auth_token_service.dart';
import 'package:kipa/core/services/websocket/websocket_service.dart';
import 'package:kipa/utils/constant.dart';
import '../../data/models/delivery_models.dart';
import '../../domain/entities/delivery_entities.dart';
import '../../domain/enums/delivery_status.dart';
import 'delivery_tracking_state.dart';

class DeliveryTrackingNotifier extends Notifier<DeliveryTrackingState> {
  late WebSocketService _webSocketService;
  late AuthTokenService _authTokenService;
  StreamSubscription<WebSocketMessage>? _messageSubscription;
  StreamSubscription<bool>? _connectionSubscription;

  @override
  DeliveryTrackingState build() {
    _webSocketService = WebSocketService();
    _authTokenService = AuthTokenService();

    ref.onDispose(() {
      _messageSubscription?.cancel();
      _connectionSubscription?.cancel();
      _webSocketService.dispose();
    });

    return const DeliveryTrackingState();
  }

  Future<void> startTracking({
    required String jobId,
    DeliveryJobEntity? initialJob,
  }) async {
    if (state.job?.id == jobId && state.isConnected) {
      await fetchJobDetails(jobId);
      return;
    }

    if (state.job?.id != null && state.job!.id != jobId) {
      await stopTracking();
    }

    state = state.copyWith(isLoading: true, job: initialJob);

    try {
      final token = await _authTokenService.getToken();
      if (token == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Not authenticated',
        );
        return;
      }

      _connectionSubscription = _webSocketService.connectionStream.listen((
        connected,
      ) {
        state = state.copyWith(isConnected: connected);
      });

      _messageSubscription = _webSocketService.messageStream.listen(
        _handleMessage,
      );

      await _webSocketService.connect(token: token, jobId: jobId, role: 'user');

      state = state.copyWith(isLoading: false);
      await fetchJobDetails(jobId);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void _handleMessage(WebSocketMessage message) {
    switch (message.type) {
      case WebSocketMessageType.pong:
        break;
      case WebSocketMessageType.locationUpdate:
        _handleLocationUpdate(message.data);
        break;
      case WebSocketMessageType.jobStatus:
        _handleStatusUpdate(message.data);
        break;
      case WebSocketMessageType.chatMessage:
        _handleChatMessage(message.data);
        break;
      case WebSocketMessageType.nearbyRiders:
        _handleNearbyRiders(message.data);
        break;
      case WebSocketMessageType.error:
        state = state.copyWith(errorMessage: message.data['error']?.toString());
        break;
      default:
        break;
    }
  }

  void _handleLocationUpdate(Map<String, dynamic> data) {
    final location = RiderLocationModel.fromJson(data);
    state = state.copyWith(riderLocation: location);
  }

  void _handleStatusUpdate(Map<String, dynamic> data) {
    final newStatus = data['status'] as String?;
    if (newStatus == null || newStatus.isEmpty) return;

    if (state.job != null) {
      final updatedJob = state.job!.copyWith(status: newStatus);
      state = state.copyWith(job: updatedJob);
    } else {
      final jobId = data['job_id'] as String?;
      if (jobId != null) {
        final minimalJob = DeliveryJobEntity(
          id: jobId,
          paymentRequestId: '',
          status: newStatus,
          rider: null,
          pickupAddress: '',
          dropoffAddress: '',
          createdAt: DateTime.now(),
        );
        state = state.copyWith(job: minimalJob);
      }
    }

    // Check if we should fetch rider info (works for both cases)
    if (state.job != null) {
      final status = DeliveryStatus.fromString(newStatus);
      if (status == DeliveryStatus.accepted && state.job!.rider == null) {
        fetchRiderInfo(state.job!.id);
      }
    }
  }

  void _handleChatMessage(Map<String, dynamic> data) {
    final message = ChatMessageModel.fromJson(data);
    final updatedMessages = [...state.messages, message];
    state = state.copyWith(messages: updatedMessages);
  }

  void _handleNearbyRiders(Map<String, dynamic> data) {
    final ridersList = data['riders'] as List<dynamic>? ?? [];
    final nearbyRiders = NearbyRiderModel.fromJsonList(ridersList);
    state = state.copyWith(nearbyRiders: nearbyRiders);
  }

  void sendChatMessage(String message) {
    _webSocketService.sendChatMessage(message);

    final localMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      receiverId: state.job?.rider?.id ?? '',
      message: message,
      isFromRider: false,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, localMessage];
    state = state.copyWith(messages: updatedMessages);
  }

  void updateJob(DeliveryJobEntity job) {
    state = state.copyWith(job: job);
  }

  Future<void> fetchJobDetails(String deliveryJobId) async {
    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getRequest(
        endpoint: ApiEndpoints.getJobDetailsUrl(deliveryJobId),
      );

      if (response.success && response.data != null) {
        final jobData = response.data as Map<String, dynamic>;

        RiderEntity? rider;
        if (jobData['rider'] != null) {
          rider = RiderModel.fromJson(jobData['rider']);
        }

        if (state.job != null) {
          final updatedJob = DeliveryJobEntity(
            id: state.job!.id,
            paymentRequestId: state.job!.paymentRequestId,
            status: jobData['status'] as String? ?? state.job!.status,
            rider: rider,
            pickupAddress:
                jobData['pickup_address'] as String? ??
                state.job!.pickupAddress,
            dropoffAddress:
                jobData['dropoff_address'] as String? ??
                state.job!.dropoffAddress,
            pickupLat: jobData['pickup_lat'] as double? ?? state.job!.pickupLat,
            pickupLng: jobData['pickup_lng'] as double? ?? state.job!.pickupLng,
            dropoffLat:
                jobData['dropoff_lat'] as double? ?? state.job!.dropoffLat,
            dropoffLng:
                jobData['dropoff_lng'] as double? ?? state.job!.dropoffLng,
            estimatedArrival: state.job!.estimatedArrival,
            createdAt: state.job!.createdAt,
          );
          state = state.copyWith(job: updatedJob);
        }
      } else {
        // Job not found - this might be normal if job hasn't been created yet
      }
    } catch (e) {
      // Silently handle error - WebSocket will provide updates anyway
    }
  }

  Future<void> fetchRiderInfo(String deliveryJobId) async {
    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getRequest(
        endpoint: ApiEndpoints.getRiderInfoUrl(deliveryJobId),
      );

      if (response.success && response.data != null) {
        final riderData = response.data as Map<String, dynamic>;
        final rider = RiderModel.fromJson(riderData);

        if (state.job != null) {
          final updatedJob = state.job!.copyWith(rider: rider);
          state = state.copyWith(job: updatedJob);
        }
      }
    } catch (e) {
      // Handle error silently or log it
    }
  }

  Future<void> stopTracking() async {
    await _webSocketService.disconnect();
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
  }
}
