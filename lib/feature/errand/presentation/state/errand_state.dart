import '../../../delivery/domain/entities/delivery_entities.dart';
import '../../domain/entities/errand_entity.dart';

class ErrandState {
  final ErrandEntity? currentErrand;
  final ErrandEntity? activeErrand;
  final List<ErrandEntity> errands;
  final RiderLocationEntity? riderLocation;
  final bool isLoading;
  final bool isCreating;
  final bool isConfirming;
  final bool isCompleting;
  final bool isCancelling;
  final bool isCheckingActive;
  final bool isFetchingErrands;
  final bool isConnected;
  final String? errorMessage;
  final String? successMessage;

  const ErrandState({
    this.currentErrand,
    this.activeErrand,
    this.errands = const [],
    this.riderLocation,
    this.isLoading = false,
    this.isCreating = false,
    this.isConfirming = false,
    this.isCompleting = false,
    this.isCancelling = false,
    this.isCheckingActive = false,
    this.isFetchingErrands = false,
    this.isConnected = false,
    this.errorMessage,
    this.successMessage,
  });

  ErrandState copyWith({
    ErrandEntity? currentErrand,
    ErrandEntity? activeErrand,
    List<ErrandEntity>? errands,
    RiderLocationEntity? riderLocation,
    bool? isLoading,
    bool? isCreating,
    bool? isConfirming,
    bool? isCompleting,
    bool? isCancelling,
    bool? isCheckingActive,
    bool? isFetchingErrands,
    bool? isConnected,
    String? errorMessage,
    String? successMessage,
    bool clearCurrentErrand = false,
    bool clearActiveErrand = false,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ErrandState(
      currentErrand:
          clearCurrentErrand ? null : (currentErrand ?? this.currentErrand),
      activeErrand:
          clearActiveErrand ? null : (activeErrand ?? this.activeErrand),
      errands: errands ?? this.errands,
      riderLocation: riderLocation ?? this.riderLocation,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isConfirming: isConfirming ?? this.isConfirming,
      isCompleting: isCompleting ?? this.isCompleting,
      isCancelling: isCancelling ?? this.isCancelling,
      isCheckingActive: isCheckingActive ?? this.isCheckingActive,
      isFetchingErrands: isFetchingErrands ?? this.isFetchingErrands,
      isConnected: isConnected ?? this.isConnected,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}
