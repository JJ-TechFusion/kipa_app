import '../../domain/entities/sale_entity.dart';

class SalesState {
  final bool isFetchingSales;
  final bool isFetchingSaleDetail;
  final bool isConfirmingReturn;
  final bool isUploadingDamageEvidence;
  final String? errorMessage;
  final List<SaleEntity>? sales;
  final SaleDetailEntity? saleDetail;
  final StatusCountsEntity? statusCounts;
  final List<String> damageEvidenceUrls;

  const SalesState({
    this.isFetchingSales = false,
    this.isFetchingSaleDetail = false,
    this.isConfirmingReturn = false,
    this.isUploadingDamageEvidence = false,
    this.errorMessage,
    this.sales,
    this.saleDetail,
    this.statusCounts,
    this.damageEvidenceUrls = const [],
  });

  SalesState copyWith({
    bool? isFetchingSales,
    bool? isFetchingSaleDetail,
    bool? isConfirmingReturn,
    bool? isUploadingDamageEvidence,
    String? errorMessage,
    List<SaleEntity>? sales,
    SaleDetailEntity? saleDetail,
    StatusCountsEntity? statusCounts,
    List<String>? damageEvidenceUrls,
  }) {
    return SalesState(
      isFetchingSales: isFetchingSales ?? this.isFetchingSales,
      isFetchingSaleDetail: isFetchingSaleDetail ?? this.isFetchingSaleDetail,
      isConfirmingReturn: isConfirmingReturn ?? this.isConfirmingReturn,
      isUploadingDamageEvidence: isUploadingDamageEvidence ?? this.isUploadingDamageEvidence,
      errorMessage: errorMessage,
      sales: sales ?? this.sales,
      saleDetail: saleDetail ?? this.saleDetail,
      statusCounts: statusCounts ?? this.statusCounts,
      damageEvidenceUrls: damageEvidenceUrls ?? this.damageEvidenceUrls,
    );
  }
}
