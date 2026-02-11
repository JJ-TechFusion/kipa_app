import '../../domain/entities/purchase_entity.dart';

class PurchasesState {
  final bool isFetchingPurchases;
  final bool isFetchingPurchaseDetail;
  final bool isInitiatingReturn;
  final bool isUploadingEvidence;
  final bool isOpeningDispute;
  final bool isRebooking;
  final String? errorMessage;
  final List<PurchaseEntity>? purchases;
  final PurchaseDetailEntity? purchaseDetail;
  final StatusCountsEntity? statusCounts;
  final List<String> uploadedEvidenceUrls;

  const PurchasesState({
    this.isFetchingPurchases = false,
    this.isFetchingPurchaseDetail = false,
    this.isInitiatingReturn = false,
    this.isUploadingEvidence = false,
    this.isOpeningDispute = false,
    this.isRebooking = false,
    this.errorMessage,
    this.purchases,
    this.purchaseDetail,
    this.statusCounts,
    this.uploadedEvidenceUrls = const [],
  });

  PurchasesState copyWith({
    bool? isFetchingPurchases,
    bool? isFetchingPurchaseDetail,
    bool? isInitiatingReturn,
    bool? isUploadingEvidence,
    bool? isOpeningDispute,
    bool? isRebooking,
    String? errorMessage,
    List<PurchaseEntity>? purchases,
    PurchaseDetailEntity? purchaseDetail,
    StatusCountsEntity? statusCounts,
    List<String>? uploadedEvidenceUrls,
  }) {
    return PurchasesState(
      isFetchingPurchases: isFetchingPurchases ?? this.isFetchingPurchases,
      isFetchingPurchaseDetail:
          isFetchingPurchaseDetail ?? this.isFetchingPurchaseDetail,
      isInitiatingReturn: isInitiatingReturn ?? this.isInitiatingReturn,
      isUploadingEvidence: isUploadingEvidence ?? this.isUploadingEvidence,
      isOpeningDispute: isOpeningDispute ?? this.isOpeningDispute,
      isRebooking: isRebooking ?? this.isRebooking,
      errorMessage: errorMessage,
      purchases: purchases ?? this.purchases,
      purchaseDetail: purchaseDetail ?? this.purchaseDetail,
      statusCounts: statusCounts ?? this.statusCounts,
      uploadedEvidenceUrls: uploadedEvidenceUrls ?? this.uploadedEvidenceUrls,
    );
  }
}
