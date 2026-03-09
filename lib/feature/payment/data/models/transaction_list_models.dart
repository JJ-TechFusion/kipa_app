import '../../domain/entities/transaction_list_entity.dart';

class TransactionListItemModel {
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

  TransactionListItemModel({
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

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  factory TransactionListItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionListItemModel(
      paymentRequestId: json['payment_request_id'] ?? '',
      role: json['role'] ?? '',
      itemName: json['item_name'] ?? '',
      itemPrice: _parseDouble(json['item_price']),
      totalAmount: _parseDouble(json['total_amount']),
      status: json['status'] ?? '',
      statusText: json['status_text'] ?? '',
      deliveryType: json['delivery_type'] ?? '',
      counterpartyName: json['counterparty_name'] ?? '',
      counterpartyRole: json['counterparty_role'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'])
          : null,
      deliveryJobId: json['delivery_job_id']?.toString(),
      logisticsDeliveryId: json['logistics_delivery_id']?.toString(),
      pickupAddress: json['pickup_address']?.toString(),
      dropoffAddress: json['dropoff_address']?.toString(),
      pickupLat: _parseNullableDouble(json['pickup_lat']),
      pickupLng: _parseNullableDouble(json['pickup_lng']),
      dropoffLat: _parseNullableDouble(json['dropoff_lat']),
      dropoffLng: _parseNullableDouble(json['dropoff_lng']),
    );
  }

  TransactionListItemEntity toEntity() {
    return TransactionListItemEntity(
      paymentRequestId: paymentRequestId,
      role: role,
      itemName: itemName,
      itemPrice: itemPrice,
      totalAmount: totalAmount,
      status: status,
      statusText: statusText,
      deliveryType: deliveryType,
      counterpartyName: counterpartyName,
      counterpartyRole: counterpartyRole,
      createdAt: createdAt,
      paidAt: paidAt,
      deliveryJobId: deliveryJobId,
      logisticsDeliveryId: logisticsDeliveryId,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
    );
  }
}

class TransactionListModel {
  final List<TransactionListItemModel> transactions;
  final int count;

  TransactionListModel({required this.transactions, required this.count});

  factory TransactionListModel.fromJson(Map<String, dynamic> json) {
    final list = (json['transactions'] as List<dynamic>? ?? [])
        .map(
          (e) => TransactionListItemModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    return TransactionListModel(
      transactions: list,
      count: json['count'] ?? list.length,
    );
  }

  List<TransactionListItemEntity> toEntityList() {
    return transactions.map((t) => t.toEntity()).toList();
  }
}
