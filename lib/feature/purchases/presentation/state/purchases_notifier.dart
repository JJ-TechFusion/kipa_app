import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/purchase_entity.dart';
import '../../domain/usecases/get_purchases_usecase.dart';
import '../../domain/usecases/get_purchase_by_id_usecase.dart';
import '../../domain/usecases/confirm_delivery_usecase.dart';
import '../providers/purchases_provider.dart';
import 'purchases_state.dart';

class PurchasesNotifier extends Notifier<PurchasesState> {
  late final GetPurchasesUseCase _getPurchasesUseCase;
  late final GetPurchaseByIdUseCase _getPurchaseByIdUseCase;
  late final ConfirmDeliveryUseCase _confirmDeliveryUseCase;

  @override
  PurchasesState build() {
    _getPurchasesUseCase = ref.read(getPurchasesUseCaseProvider);
    _getPurchaseByIdUseCase = ref.read(getPurchaseByIdUseCaseProvider);
    _confirmDeliveryUseCase = ref.read(confirmDeliveryUseCaseProvider);
    return const PurchasesState();
  }

  Future<void> fetchPurchases() async {
    state = state.copyWith(isFetchingPurchases: true, errorMessage: null);

    try {
      final response = await _getPurchasesUseCase();

      if (response.success && response.data != null) {
        final listEntity = response.data as PurchaseListEntity;
        state = state.copyWith(
          isFetchingPurchases: false,
          purchases: listEntity.purchases,
          statusCounts: listEntity.statusCounts,
        );
      } else {
        state = state.copyWith(
          isFetchingPurchases: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingPurchases: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchPurchaseById(String purchaseId) async {
    state = state.copyWith(isFetchingPurchaseDetail: true, errorMessage: null);

    try {
      final response = await _getPurchaseByIdUseCase(purchaseId);

      if (response.success && response.data != null) {
        final detailEntity = response.data as PurchaseDetailEntity;
        state = state.copyWith(
          isFetchingPurchaseDetail: false,
          purchaseDetail: detailEntity,
        );
      } else {
        state = state.copyWith(
          isFetchingPurchaseDetail: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingPurchaseDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> confirmDelivery(String purchaseId) async {
    state = state.copyWith(isFetchingPurchaseDetail: true, errorMessage: null);

    try {
      final response = await _confirmDeliveryUseCase(purchaseId);

      if (response.success) {
        state = state.copyWith(
          isFetchingPurchaseDetail: false,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isFetchingPurchaseDetail: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingPurchaseDetail: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearPurchaseDetail() {
    state = state.copyWith(purchaseDetail: null);
  }
}
