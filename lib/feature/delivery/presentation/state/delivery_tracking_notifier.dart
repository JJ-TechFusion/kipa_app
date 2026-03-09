import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/constants/api_constants.dart';
import 'package:kipa/core/services/network/api_services.dart';
import 'package:kipa/core/services/network/auth_token_service.dart';
import 'package:kipa/core/services/websocket/websocket_service.dart';
import 'package:kipa/utils/constant.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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
    if (state.job != null) {
      final status = DeliveryStatus.fromString(newStatus);
      if (status == DeliveryStatus.accepted && state.job!.rider == null) {
        fetchRiderInfo(state.job!.id);
      }
    }
  }

  String? get _currentUserId {
    return ref.read(authNotifierProvider).currentUser?.id;
  }

  void _handleChatMessage(Map<String, dynamic> data) {
    logMessage('DeliveryTracking', 'Received chat message data: $data');

    final message = ChatMessageModel.fromJson(data);
    final myId = _currentUserId;

    logMessage(
      'DeliveryTracking',
      'Chat: myId=$myId, senderId=${message.senderId}, receiverId=${message.receiverId}',
    );
    if (myId != null && message.senderId == myId) {
      logMessage('DeliveryTracking', 'Skipping own message');
      return;
    }

    final updatedMessages = [...state.messages, message];
    state = state.copyWith(messages: updatedMessages);
    logMessage(
      'DeliveryTracking',
      'Added message, total: ${updatedMessages.length}',
    );
  }

  void _handleNearbyRiders(Map<String, dynamic> data) {
    final ridersList = data['riders'] as List<dynamic>? ?? [];
    final nearbyRiders = NearbyRiderModel.fromJsonList(ridersList);
    state = state.copyWith(nearbyRiders: nearbyRiders);
  }

  void sendChatMessage(String content) {
    _webSocketService.sendChatMessage(content);

    final myId = _currentUserId ?? 'me';
    final localMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: myId,
      receiverId: state.job?.rider?.id ?? '',
      message: content,
      isFromRider: false,
      isMe: true,
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
        final updatedJob = DeliveryJobModel.fromJson(jobData);
        state = state.copyWith(job: updatedJob);
      } else {}
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
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
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> stopTracking() async {
    await _webSocketService.disconnect();
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
  }

  Future<void> fetchRiderLocation(String deliveryJobId) async {
    state = state.copyWith(isFetchingLocation: true);

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getRequest(
        endpoint: ApiEndpoints.getRiderLocationUrl(deliveryJobId),
      );

      if (response.success && response.data != null) {
        final locationData = response.data as Map<String, dynamic>;
        final location = RiderLocationModel.fromJson(locationData);
        state = state.copyWith(
          isFetchingLocation: false,
          riderLocation: location,
        );
      } else {
        state = state.copyWith(
          isFetchingLocation: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingLocation: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchLocationHistory(String deliveryJobId) async {
    state = state.copyWith(isFetchingLocationHistory: true);

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getRequest(
        endpoint: ApiEndpoints.getLocationHistoryUrl(deliveryJobId),
      );

      if (response.success && response.data != null) {
        final historyData = response.data as Map<String, dynamic>;
        final history = LocationHistoryModel.fromJson(historyData);
        state = state.copyWith(
          isFetchingLocationHistory: false,
          locationHistory: history,
        );
      } else {
        state = state.copyWith(
          isFetchingLocationHistory: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingLocationHistory: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearLocationHistory() {
    state = state.copyWith(locationHistory: null);
  }
}
