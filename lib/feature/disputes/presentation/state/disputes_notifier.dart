import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dispute_entity.dart';
import '../../domain/usecases/get_disputes_usecase.dart';
import '../../domain/usecases/get_dispute_by_id_usecase.dart';
import '../providers/disputes_provider.dart';
import 'disputes_state.dart';

class DisputesNotifier extends Notifier<DisputesState> {
  late final GetDisputesUseCase _getDisputesUseCase;
  late final GetDisputeByIdUseCase _getDisputeByIdUseCase;

  @override
  DisputesState build() {
    _getDisputesUseCase = ref.read(getDisputesUseCaseProvider);
    _getDisputeByIdUseCase = ref.read(getDisputeByIdUseCaseProvider);
    return const DisputesState();
  }

  Future<void> fetchDisputes() async {
    state = state.copyWith(isFetchingDisputes: true, errorMessage: null);

    try {
      final response = await _getDisputesUseCase();

      if (response.success && response.data != null) {
        final listEntity = response.data as DisputeListEntity;
        state = state.copyWith(
          isFetchingDisputes: false,
          disputes: listEntity.disputes,
          count: listEntity.count,
        );
      } else {
        state = state.copyWith(
          isFetchingDisputes: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingDisputes: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchDisputeById(String id) async {
    state = state.copyWith(isFetchingDisputeDetail: true, errorMessage: null);

    try {
      final response = await _getDisputeByIdUseCase(id);

      if (response.success && response.data != null) {
        final disputeEntity = response.data as DisputeEntity;
        state = state.copyWith(
          isFetchingDisputeDetail: false,
          disputeDetail: disputeEntity,
        );
      } else {
        state = state.copyWith(
          isFetchingDisputeDetail: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingDisputeDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearDisputeDetail() {
    state = state.copyWith(disputeDetail: null);
  }
}
