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
  });

  bool get isBuyer => role == 'buyer';
  bool get isSeller => role == 'seller';

  bool get isActive => !['completed', 'refunded', 'cancelled'].contains(status);
}
