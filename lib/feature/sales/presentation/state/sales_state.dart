import '../../domain/entities/sale_entity.dart';

class SalesState {
  final bool isFetchingSales;
  final bool isFetchingSaleDetail;
  final String? errorMessage;
  final List<SaleEntity>? sales;
  final SaleDetailEntity? saleDetail;
  final StatusCountsEntity? statusCounts;

  const SalesState({
    this.isFetchingSales = false,
    this.isFetchingSaleDetail = false,
    this.errorMessage,
    this.sales,
    this.saleDetail,
    this.statusCounts,
  });

  SalesState copyWith({
    bool? isFetchingSales,
    bool? isFetchingSaleDetail,
    String? errorMessage,
    List<SaleEntity>? sales,
    SaleDetailEntity? saleDetail,
    StatusCountsEntity? statusCounts,
  }) {
    return SalesState(
      isFetchingSales: isFetchingSales ?? this.isFetchingSales,
      isFetchingSaleDetail: isFetchingSaleDetail ?? this.isFetchingSaleDetail,
      errorMessage: errorMessage,
      sales: sales ?? this.sales,
      saleDetail: saleDetail ?? this.saleDetail,
      statusCounts: statusCounts ?? this.statusCounts,
    );
  }
}
