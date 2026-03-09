class TransactionListItemEntity {
  final String paymentRequestId;
  final String role;
  final String itemName;
  final double itemPrice;
  final double totalAmount;
  final String status;
  final String statusText;
  final String deliveryType;
  final String counterpartyName;
  final String counterpartyRole;
  final DateTime createdAt;
  final DateTime? paidAt;
  final String? deliveryJobId;
  final String? logisticsDeliveryId;
  final String? pickupAddress;
  final String? dropoffAddress;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;

  const TransactionListItemEntity({
    required this.paymentRequestId,
    required this.role,
    required this.itemName,
    required this.itemPrice,
    required this.totalAmount,
    required this.status,
    required this.statusText,
    required this.deliveryType,
    required this.counterpartyName,
    required this.counterpartyRole,
    required this.createdAt,
    this.paidAt,
    this.deliveryJobId,
    this.logisticsDeliveryId,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
  });

  bool get isBuyer => role == 'buyer';
  bool get isSeller => role == 'seller';

  bool get isInterState => deliveryType == 'inter_state';
  bool get isIntraState => deliveryType == 'intra_state';
  bool get hasActiveDeliveryJob => deliveryJobId != null;
  bool get hasLogisticsDelivery => logisticsDeliveryId != null;

  bool get isActive => !['completed', 'refunded', 'cancelled'].contains(status);
}
