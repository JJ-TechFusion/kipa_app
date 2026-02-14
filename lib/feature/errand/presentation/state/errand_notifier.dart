import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/services/network/auth_token_service.dart';
import 'package:kipa/core/services/websocket/websocket_service.dart';
import 'package:kipa/utils/constant.dart';
import '../../../delivery/data/models/delivery_models.dart';
import '../../data/datasources/errand_remote_datasource.dart';
import '../../data/repositories/errand_repository_impl.dart';
import '../../domain/entities/errand_entity.dart';
import '../../domain/enums/errand_status.dart';
import '../../domain/usecases/cancel_errand_usecase.dart';
import '../../domain/usecases/complete_errand_usecase.dart';
import '../../domain/usecases/confirm_errand_usecase.dart';
import '../../domain/usecases/create_errand_usecase.dart';
import '../../domain/usecases/get_active_errand_usecase.dart';
import '../../domain/usecases/get_errand_usecase.dart';
import 'errand_state.dart';

class ErrandNotifier extends Notifier<ErrandState> {
  late final CreateErrandUsecase _createErrandUsecase;
  late final ConfirmErrandUsecase _confirmErrandUsecase;
  late final GetErrandUsecase _getErrandUsecase;
  late final GetActiveErrandUsecase _getActiveErrandUsecase;
  late final CompleteErrandUsecase _completeErrandUsecase;
  late final CancelErrandUsecase _cancelErrandUsecase;
  late final ErrandRemoteDatasource _datasource;

  late WebSocketService _webSocketService;
  late AuthTokenService _authTokenService;
  StreamSubscription<WebSocketMessage>? _messageSubscription;
  StreamSubscription<bool>? _connectionSubscription;
  Timer? _pollTimer;

  @override
  ErrandState build() {
    _datasource = ErrandRemoteDatasource();
    final repository = ErrandRepositoryImpl(_datasource);

    _createErrandUsecase = CreateErrandUsecase(repository);
    _confirmErrandUsecase = ConfirmErrandUsecase(repository);
    _getErrandUsecase = GetErrandUsecase(repository);
    _getActiveErrandUsecase = GetActiveErrandUsecase(repository);
    _completeErrandUsecase = CompleteErrandUsecase(repository);
    _cancelErrandUsecase = CancelErrandUsecase(repository);

    _webSocketService = WebSocketService();
    _authTokenService = AuthTokenService();

    ref.onDispose(() {
      _messageSubscription?.cancel();
      _connectionSubscription?.cancel();
      _pollTimer?.cancel();
      _webSocketService.dispose();
    });

    return const ErrandState();
  }

  Future<ErrandEntity?> createErrand(CreateErrandParams params) async {
    state = state.copyWith(isCreating: true, clearError: true);

    try {
      final apiErrand = await _createErrandUsecase(params);
      final errand = apiErrand.copyWith(
        pickupAddress: apiErrand.pickupAddress.isNotEmpty
            ? apiErrand.pickupAddress
            : params.pickupAddress,
        pickupLatitude: apiErrand.pickupLatitude ?? params.pickupLatitude,
        pickupLongitude: apiErrand.pickupLongitude ?? params.pickupLongitude,
        pickupContactName: apiErrand.pickupContactName.isNotEmpty
            ? apiErrand.pickupContactName
            : params.pickupContactName,
        pickupContactPhone: apiErrand.pickupContactPhone.isNotEmpty
            ? apiErrand.pickupContactPhone
            : params.pickupContactPhone,
        dropoffAddress: apiErrand.dropoffAddress.isNotEmpty
            ? apiErrand.dropoffAddress
            : params.dropoffAddress,
        dropoffLatitude: apiErrand.dropoffLatitude ?? params.dropoffLatitude,
        dropoffLongitude: apiErrand.dropoffLongitude ?? params.dropoffLongitude,
        dropoffContactName: apiErrand.dropoffContactName.isNotEmpty
            ? apiErrand.dropoffContactName
            : params.dropoffContactName,
        dropoffContactPhone: apiErrand.dropoffContactPhone.isNotEmpty
            ? apiErrand.dropoffContactPhone
            : params.dropoffContactPhone,
        packageDescription: apiErrand.packageDescription.isNotEmpty
            ? apiErrand.packageDescription
            : params.packageDescription,
        packageSize: apiErrand.packageSize,
        notes: apiErrand.notes ?? params.notes,
      );
      state = state.copyWith(isCreating: false, currentErrand: errand);
      return errand;
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  Future<ErrandEntity?> confirmErrand(String errandId) async {
    state = state.copyWith(isConfirming: true, clearError: true);

    try {
      final errand = await _confirmErrandUsecase(errandId);
      state = state.copyWith(
        isConfirming: false,
        currentErrand: errand,
        activeErrand: errand,
      );

      // Start tracking after confirmation
      if (errand.deliveryJob != null) {
        await _startTracking(errand.deliveryJob!.id);
      } else {
        // Start polling for rider assignment
        _startPolling(errandId);
      }

      return errand;
    } catch (e) {
      state = state.copyWith(
        isConfirming: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  Future<void> fetchActiveErrand() async {
    state = state.copyWith(isCheckingActive: true);

    try {
      final errand = await _getActiveErrandUsecase();

      state = state.copyWith(
        isCheckingActive: false,
        activeErrand: errand,
        currentErrand: errand,
      );

      if (errand?.deliveryJob != null) {
        await _startTracking(errand!.deliveryJob!.id);
      } else if (errand != null) {
        _startPolling(errand.id);
      }
    } catch (e) {
      state = state.copyWith(isCheckingActive: false);
    }
  }

  Future<void> fetchErrand(String errandId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final errand = await _getErrandUsecase(errandId);
      state = state.copyWith(isLoading: false, currentErrand: errand);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> completeErrand(String errandId, String dropoffCode) async {
    state = state.copyWith(isCompleting: true, clearError: true);

    try {
      await _completeErrandUsecase(errandId, dropoffCode);
      state = state.copyWith(
        isCompleting: false,
        successMessage: 'Errand completed successfully!',
        clearCurrentErrand: true,
        clearActiveErrand: true,
      );
      _stopTracking();
      return true;
    } catch (e) {
      state = state.copyWith(
        isCompleting: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<CancellationResult?> cancelErrand(String errandId) async {
    state = state.copyWith(isCancelling: true, clearError: true);

    try {
      final result = await _cancelErrandUsecase(errandId);
      state = state.copyWith(
        isCancelling: false,
        successMessage: result.message,
        clearCurrentErrand: true,
        clearActiveErrand: true,
      );
      _stopTracking();
      return result;
    } catch (e) {
      state = state.copyWith(
        isCancelling: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  Future<void> fetchErrands() async {
    state = state.copyWith(isFetchingErrands: true, clearError: true);

    try {
      final errands = await _datasource.getErrands();
      state = state.copyWith(
        isFetchingErrands: false,
        errands: errands,
      );
    } catch (e) {
      state = state.copyWith(
        isFetchingErrands: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> _startTracking(String jobId) async {
    try {
      logMessage(
        'ErrandNotifier',
        'Starting WebSocket tracking for job: $jobId',
      );

      final token = await _authTokenService.getToken();
      if (token == null) {
        logMessage('ErrandNotifier', 'No auth token available for WebSocket');
        return;
      }

      _connectionSubscription = _webSocketService.connectionStream.listen((
        connected,
      ) {
        logMessage('ErrandNotifier', 'WebSocket connection status: $connected');
        state = state.copyWith(isConnected: connected);
      });

      _messageSubscription = _webSocketService.messageStream.listen(
        _handleMessage,
        onError: (error) {
          logMessage('ErrandNotifier', 'WebSocket error: $error');
        },
      );

      await _webSocketService.connect(token: token, jobId: jobId, role: 'user');
      logMessage('ErrandNotifier', 'WebSocket connect called');
    } catch (e) {
      logMessage('ErrandNotifier', 'Error starting tracking: $e');
    }
  }

  void _handleMessage(WebSocketMessage message) {
    logMessage(
      'ErrandNotifier',
      'Received WebSocket message: ${message.type}, data: ${message.data}',
    );

    switch (message.type) {
      case WebSocketMessageType.locationUpdate:
        _handleLocationUpdate(message.data);
        break;
      case WebSocketMessageType.jobStatus:
        _handleStatusUpdate(message.data);
        break;
      case WebSocketMessageType.connected:
        logMessage('ErrandNotifier', 'WebSocket connected successfully');
        break;
      default:
        logMessage('ErrandNotifier', 'Unhandled message type: ${message.type}');
        break;
    }
  }

  void _handleLocationUpdate(Map<String, dynamic> data) {
    logMessage('ErrandNotifier', 'Processing location update: $data');
    final location = RiderLocationModel.fromJson(data);
    logMessage(
      'ErrandNotifier',
      'Parsed location: lat=${location.latitude}, lng=${location.longitude}',
    );
    state = state.copyWith(riderLocation: location);
  }

  void _handleStatusUpdate(Map<String, dynamic> data) {
    logMessage('ErrandNotifier', 'Processing status update: $data');
    final newStatus = data['status'] as String?;
    if (newStatus == null) return;

    final status = ErrandStatus.fromString(newStatus);
    logMessage('ErrandNotifier', 'Parsed status: $status');

    if (state.currentErrand != null) {
      final updatedErrand = state.currentErrand!.copyWith(status: status);
      state = state.copyWith(
        currentErrand: updatedErrand,
        activeErrand: updatedErrand,
      );
    }
  }

  void _startPolling(String errandId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final errand = await _getErrandUsecase(errandId);
        state = state.copyWith(currentErrand: errand, activeErrand: errand);

        if (errand.deliveryJob != null) {
          _pollTimer?.cancel();
          await _startTracking(errand.deliveryJob!.id);
        }
      } catch (e) {
        // Continue polling on error
      }
    });
  }

  void _stopTracking() {
    _pollTimer?.cancel();
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    _webSocketService.disconnect();
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  void setCurrentErrand(ErrandEntity errand) {
    state = state.copyWith(currentErrand: errand);
  }

  Future<void> startTracking(String jobId) async {
    await _startTracking(jobId);
  }

  void stopTracking() {
    _stopTracking();
  }
}
