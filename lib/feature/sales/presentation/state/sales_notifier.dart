import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sale_entity.dart';
import '../../domain/usecases/get_sales_usecase.dart';
import '../../domain/usecases/get_sale_by_id_usecase.dart';
import '../../domain/usecases/confirm_return_usecase.dart';
import '../../domain/usecases/upload_damage_evidence_usecase.dart';
import '../providers/sales_provider.dart';
import 'sales_state.dart';

class SalesNotifier extends Notifier<SalesState> {
  late final GetSalesUseCase _getSalesUseCase;
  late final GetSaleByIdUseCase _getSaleByIdUseCase;
  late final ConfirmReturnUseCase _confirmReturnUseCase;
  late final UploadDamageEvidenceUseCase _uploadDamageEvidenceUseCase;

  @override
  SalesState build() {
    _getSalesUseCase = ref.read(getSalesUseCaseProvider);
    _getSaleByIdUseCase = ref.read(getSaleByIdUseCaseProvider);
    _confirmReturnUseCase = ref.read(confirmReturnUseCaseProvider);
    _uploadDamageEvidenceUseCase = ref.read(uploadDamageEvidenceUseCaseProvider);
    return const SalesState();
  }

  Future<void> fetchSales() async {
    state = state.copyWith(isFetchingSales: true, errorMessage: null);

    try {
      final response = await _getSalesUseCase();

      if (response.success && response.data != null) {
        final listEntity = response.data as SaleListEntity;
        state = state.copyWith(
          isFetchingSales: false,
          sales: listEntity.sales,
          statusCounts: listEntity.statusCounts,
        );
      } else {
        state = state.copyWith(
          isFetchingSales: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingSales: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchSaleById(String orderId) async {
    state = state.copyWith(isFetchingSaleDetail: true, errorMessage: null);

    try {
      final response = await _getSaleByIdUseCase(orderId);

      if (response.success && response.data != null) {
        final detailEntity = response.data as SaleDetailEntity;
        state = state.copyWith(
          isFetchingSaleDetail: false,
          saleDetail: detailEntity,
        );
      } else {
        state = state.copyWith(
          isFetchingSaleDetail: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingSaleDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> confirmReturn({
    required String orderId,
    required String condition,
    String? notes,
    String? damageReason,
    List<String> damageEvidenceUrls = const [],
  }) async {
    state = state.copyWith(isConfirmingReturn: true, errorMessage: null);

    try {
      final response = await _confirmReturnUseCase(
        orderId: orderId,
        condition: condition,
        notes: notes,
        damageReason: damageReason,
        damageEvidenceUrls: damageEvidenceUrls,
      );

      if (response.success) {
        state = state.copyWith(
          isConfirmingReturn: false,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isConfirmingReturn: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isConfirmingReturn: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<String?> uploadDamageEvidence({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    state = state.copyWith(isUploadingDamageEvidence: true, errorMessage: null);

    try {
      final response = await _uploadDamageEvidenceUseCase(
        fileName: fileName,
        fileBytes: fileBytes,
      );

      if (response.success && response.data != null) {
        final url = response.data as String;
        final updatedUrls = [...state.damageEvidenceUrls, url];
        state = state.copyWith(
          isUploadingDamageEvidence: false,
          damageEvidenceUrls: updatedUrls,
        );
        return url;
      } else {
        state = state.copyWith(
          isUploadingDamageEvidence: false,
          errorMessage: response.message,
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isUploadingDamageEvidence: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  void removeDamageEvidenceUrl(String url) {
    final updatedUrls = state.damageEvidenceUrls.where((u) => u != url).toList();
    state = state.copyWith(damageEvidenceUrls: updatedUrls);
  }

  void clearDamageEvidence() {
    state = state.copyWith(damageEvidenceUrls: []);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSaleDetail() {
    state = state.copyWith(saleDetail: null);
  }
}
