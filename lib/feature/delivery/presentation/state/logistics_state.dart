import '../../domain/entities/logistics_delivery_entity.dart';

class LogisticsState {
  final bool isFetchingLogistics;
  final List<LogisticsDeliveryEntity> deliveries;
  final String? errorMessage;
  final int total;
  final bool isFetchingDetails;
  final LogisticsDeliveryDetailsEntity? currentDetails;
  final bool isClaimingDelivery;
  final bool isConfirmingDelivery;
  final bool isOpeningDispute;
  final bool isMarkingReturnShipped;
  final bool isConfirmingReturn;

  const LogisticsState({
    this.isFetchingLogistics = false,
    this.deliveries = const [],
    this.errorMessage,
    this.total = 0,
    this.isFetchingDetails = false,
    this.currentDetails,
    this.isClaimingDelivery = false,
    this.isConfirmingDelivery = false,
    this.isOpeningDispute = false,
    this.isMarkingReturnShipped = false,
    this.isConfirmingReturn = false,
  });

  LogisticsState copyWith({
    bool? isFetchingLogistics,
    List<LogisticsDeliveryEntity>? deliveries,
    String? errorMessage,
    int? total,
    bool? isFetchingDetails,
    LogisticsDeliveryDetailsEntity? currentDetails,
    bool clearDetails = false,
    bool? isClaimingDelivery,
    bool? isConfirmingDelivery,
    bool? isOpeningDispute,
    bool? isMarkingReturnShipped,
    bool? isConfirmingReturn,
  }) {
    return LogisticsState(
      isFetchingLogistics: isFetchingLogistics ?? this.isFetchingLogistics,
      deliveries: deliveries ?? this.deliveries,
      errorMessage: errorMessage,
      total: total ?? this.total,
      isFetchingDetails: isFetchingDetails ?? this.isFetchingDetails,
      currentDetails: clearDetails ? null : (currentDetails ?? this.currentDetails),
      isClaimingDelivery: isClaimingDelivery ?? this.isClaimingDelivery,
      isConfirmingDelivery: isConfirmingDelivery ?? this.isConfirmingDelivery,
      isOpeningDispute: isOpeningDispute ?? this.isOpeningDispute,
      isMarkingReturnShipped: isMarkingReturnShipped ?? this.isMarkingReturnShipped,
      isConfirmingReturn: isConfirmingReturn ?? this.isConfirmingReturn,
    );
  }

  // Status counts for filters
  int get awaitingShipmentCount =>
      deliveries.where((d) => d.status == 'awaiting_shipment').length;
  int get shippedCount =>
      deliveries.where((d) => d.status == 'shipped').length;
  int get deliveredCount =>
      deliveries.where((d) => d.status == 'delivered').length;
  int get allCount => deliveries.length;
}
