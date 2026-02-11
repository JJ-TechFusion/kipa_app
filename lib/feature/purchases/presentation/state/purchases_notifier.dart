import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/purchase_entity.dart';
import '../../domain/entities/ready_for_return_response_entity.dart';
import '../../domain/entities/dispute_response_entity.dart';
import '../../domain/usecases/rebook_delivery_usecase.dart';
import '../../domain/usecases/get_purchases_usecase.dart';
import '../../domain/usecases/get_purchase_by_id_usecase.dart';
import '../../domain/usecases/confirm_delivery_usecase.dart';
import '../../domain/usecases/ready_for_return_usecase.dart';
import '../../domain/usecases/upload_dispute_evidence_usecase.dart';
import '../../domain/usecases/open_dispute_usecase.dart';
import '../providers/purchases_provider.dart';
import 'purchases_state.dart';

class PurchasesNotifier extends Notifier<PurchasesState> {
  late final GetPurchasesUseCase _getPurchasesUseCase;
  late final GetPurchaseByIdUseCase _getPurchaseByIdUseCase;
  late final ConfirmDeliveryUseCase _confirmDeliveryUseCase;
  late final ReadyForReturnUseCase _readyForReturnUseCase;
  late final UploadDisputeEvidenceUseCase _uploadDisputeEvidenceUseCase;
  late final OpenDisputeUseCase _openDisputeUseCase;
  late final RebookDeliveryUseCase _rebookDeliveryUseCase;

  @override
  PurchasesState build() {
    _getPurchasesUseCase = ref.read(getPurchasesUseCaseProvider);
    _getPurchaseByIdUseCase = ref.read(getPurchaseByIdUseCaseProvider);
    _confirmDeliveryUseCase = ref.read(confirmDeliveryUseCaseProvider);
    _readyForReturnUseCase = ref.read(readyForReturnUseCaseProvider);
    _uploadDisputeEvidenceUseCase = ref.read(
      uploadDisputeEvidenceUseCaseProvider,
    );
    _openDisputeUseCase = ref.read(openDisputeUseCaseProvider);
    _rebookDeliveryUseCase = ref.read(rebookDeliveryUseCaseProvider);
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

  Future<ReadyForReturnResponseEntity?> readyForReturn(
    String purchaseId,
  ) async {
    state = state.copyWith(isInitiatingReturn: true, errorMessage: null);

    try {
      final response = await _readyForReturnUseCase(purchaseId);

      if (response.success && response.data != null) {
        final responseEntity = response.data as ReadyForReturnResponseEntity;
        state = state.copyWith(isInitiatingReturn: false, errorMessage: null);
        return responseEntity;
      } else {
        state = state.copyWith(
          isInitiatingReturn: false,
          errorMessage: response.message,
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isInitiatingReturn: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<String?> uploadDisputeEvidence({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    state = state.copyWith(isUploadingEvidence: true, errorMessage: null);

    try {
      final response = await _uploadDisputeEvidenceUseCase(
        fileName: fileName,
        fileBytes: fileBytes,
      );

      if (response.success && response.data != null) {
        final evidenceResponse = response.data as EvidenceUploadResponseEntity;
        final updatedUrls = [
          ...state.uploadedEvidenceUrls,
          evidenceResponse.url,
        ];
        state = state.copyWith(
          isUploadingEvidence: false,
          uploadedEvidenceUrls: updatedUrls,
        );
        return evidenceResponse.url;
      } else {
        state = state.copyWith(
          isUploadingEvidence: false,
          errorMessage: response.message,
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isUploadingEvidence: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<DisputeResponseEntity?> openDispute({
    required String purchaseId,
    required String reason,
    required List<String> evidence,
  }) async {
    state = state.copyWith(isOpeningDispute: true, errorMessage: null);

    try {
      final response = await _openDisputeUseCase(
        purchaseId: purchaseId,
        reason: reason,
        evidence: evidence,
      );

      if (response.success && response.data != null) {
        final disputeResponse = response.data as DisputeResponseEntity;
        state = state.copyWith(
          isOpeningDispute: false,
          uploadedEvidenceUrls: [], // Clear after successful dispute
        );
        return disputeResponse;
      } else {
        state = state.copyWith(
          isOpeningDispute: false,
          errorMessage: response.message,
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isOpeningDispute: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<bool> rebookDelivery(String purchaseId) async {
    state = state.copyWith(isRebooking: true, errorMessage: null);

    try {
      final response = await _rebookDeliveryUseCase(purchaseId);

      if (response.success) {
        state = state.copyWith(isRebooking: false, errorMessage: null);
        return true;
      } else {
        state = state.copyWith(
          isRebooking: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isRebooking: false, errorMessage: e.toString());
      return false;
    }
  }

  void removeEvidenceUrl(String url) {
    final updatedUrls = state.uploadedEvidenceUrls
        .where((u) => u != url)
        .toList();
    state = state.copyWith(uploadedEvidenceUrls: updatedUrls);
  }

  void clearUploadedEvidence() {
    state = state.copyWith(uploadedEvidenceUrls: []);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearPurchaseDetail() {
    state = state.copyWith(purchaseDetail: null);
  }
}
