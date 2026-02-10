import '../../domain/entities/purchase_entity.dart';

class PurchasesState {
  final bool isFetchingPurchases;
  final bool isFetchingPurchaseDetail;
  final String? errorMessage;
  final List<PurchaseEntity>? purchases;
  final PurchaseDetailEntity? purchaseDetail;
  final StatusCountsEntity? statusCounts;

  const PurchasesState({
    this.isFetchingPurchases = false,
    this.isFetchingPurchaseDetail = false,
    this.errorMessage,
    this.purchases,
    this.purchaseDetail,
    this.statusCounts,
  });

  PurchasesState copyWith({
    bool? isFetchingPurchases,
    bool? isFetchingPurchaseDetail,
    String? errorMessage,
    List<PurchaseEntity>? purchases,
    PurchaseDetailEntity? purchaseDetail,
    StatusCountsEntity? statusCounts,
  }) {
    return PurchasesState(
      isFetchingPurchases: isFetchingPurchases ?? this.isFetchingPurchases,
      isFetchingPurchaseDetail:
          isFetchingPurchaseDetail ?? this.isFetchingPurchaseDetail,
      errorMessage: errorMessage,
      purchases: purchases ?? this.purchases,
      purchaseDetail: purchaseDetail ?? this.purchaseDetail,
      statusCounts: statusCounts ?? this.statusCounts,
    );
  }
}
