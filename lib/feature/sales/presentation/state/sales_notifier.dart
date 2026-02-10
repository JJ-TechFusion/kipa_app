import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sale_entity.dart';
import '../../domain/usecases/get_sales_usecase.dart';
import '../../domain/usecases/get_sale_by_id_usecase.dart';
import '../providers/sales_provider.dart';
import 'sales_state.dart';

class SalesNotifier extends Notifier<SalesState> {
  late final GetSalesUseCase _getSalesUseCase;
  late final GetSaleByIdUseCase _getSaleByIdUseCase;

  @override
  SalesState build() {
    _getSalesUseCase = ref.read(getSalesUseCaseProvider);
    _getSaleByIdUseCase = ref.read(getSaleByIdUseCaseProvider);
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

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSaleDetail() {
    state = state.copyWith(saleDetail: null);
  }
}
