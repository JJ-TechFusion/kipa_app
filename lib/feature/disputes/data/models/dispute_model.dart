import '../../domain/entities/dispute_entity.dart';

class DisputePaymentRequestModel {
  final String id;
  final String sellerId;
  final String itemName;
  final String? itemDescription;
  final double itemPrice;
  final int processingTimeHours;
  final String deliveryType;
  final String? vehicleType;
  final String? pickupAddress;
  final String? pickupState;
  final String? dropoffAddress;
  final String? dropoffState;
  final double estimatedDeliveryFee;
  final double buyerServiceFee;
  final double sellerPlatformFee;
  final double estimatedTotal;
  final String paymentCode;
  final String status;
  final String escrowId;
  final String? deliveryJobId;
  final String buyerId;
  final DateTime createdAt;

  const DisputePaymentRequestModel({
    required this.id,
    required this.sellerId,
    required this.itemName,
    this.itemDescription,
    required this.itemPrice,
    required this.processingTimeHours,
    required this.deliveryType,
    this.vehicleType,
    this.pickupAddress,
    this.pickupState,
    this.dropoffAddress,
    this.dropoffState,
    required this.estimatedDeliveryFee,
    required this.buyerServiceFee,
    required this.sellerPlatformFee,
    required this.estimatedTotal,
    required this.paymentCode,
    required this.status,
    required this.escrowId,
    this.deliveryJobId,
    required this.buyerId,
    required this.createdAt,
  });

  factory DisputePaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return DisputePaymentRequestModel(
      id: json['id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemDescription: json['item_description']?.toString(),
      itemPrice: (json['item_price'] as num?)?.toDouble() ?? 0.0,
      processingTimeHours: (json['processing_time_hours'] as num?)?.toInt() ?? 0,
      deliveryType: json['delivery_type']?.toString() ?? '',
      vehicleType: json['vehicle_type']?.toString(),
      pickupAddress: json['pickup_address']?.toString(),
      pickupState: json['pickup_state']?.toString(),
      dropoffAddress: json['dropoff_address']?.toString(),
      dropoffState: json['dropoff_state']?.toString(),
      estimatedDeliveryFee:
          (json['estimated_delivery_fee'] as num?)?.toDouble() ?? 0.0,
      buyerServiceFee: (json['buyer_service_fee'] as num?)?.toDouble() ?? 0.0,
      sellerPlatformFee:
          (json['seller_platform_fee'] as num?)?.toDouble() ?? 0.0,
      estimatedTotal: (json['estimated_total'] as num?)?.toDouble() ?? 0.0,
      paymentCode: json['payment_code']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      escrowId: json['escrow_id']?.toString() ?? '',
      deliveryJobId: json['delivery_job_id']?.toString(),
      buyerId: json['buyer_id']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  DisputePaymentRequestEntity toEntity() {
    return DisputePaymentRequestEntity(
      id: id,
      sellerId: sellerId,
      itemName: itemName,
      itemDescription: itemDescription,
      itemPrice: itemPrice,
      processingTimeHours: processingTimeHours,
      deliveryType: deliveryType,
      vehicleType: vehicleType,
      pickupAddress: pickupAddress,
      pickupState: pickupState,
      dropoffAddress: dropoffAddress,
      dropoffState: dropoffState,
      estimatedDeliveryFee: estimatedDeliveryFee,
      buyerServiceFee: buyerServiceFee,
      sellerPlatformFee: sellerPlatformFee,
      estimatedTotal: estimatedTotal,
      paymentCode: paymentCode,
      status: status,
      escrowId: escrowId,
      deliveryJobId: deliveryJobId,
      buyerId: buyerId,
      createdAt: createdAt,
    );
  }
}

class DisputeEscrowModel {
  final String id;
  final String paymentRequestId;
  final String? orderId;
  final String buyerId;
  final String sellerId;
  final double itemAmount;
  final double deliveryFeeEstimate;
  final double buyerFee;
  final double totalLocked;
  final double actualDeliveryFee;
  final double sellerPayout;
  final String status;
  final DateTime? fundedAt;
  final DateTime createdAt;

  const DisputeEscrowModel({
    required this.id,
    required this.paymentRequestId,
    this.orderId,
    required this.buyerId,
    required this.sellerId,
    required this.itemAmount,
    required this.deliveryFeeEstimate,
    required this.buyerFee,
    required this.totalLocked,
    required this.actualDeliveryFee,
    required this.sellerPayout,
    required this.status,
    this.fundedAt,
    required this.createdAt,
  });

  factory DisputeEscrowModel.fromJson(Map<String, dynamic> json) {
    return DisputeEscrowModel(
      id: json['id']?.toString() ?? '',
      paymentRequestId: json['payment_request_id']?.toString() ?? '',
      orderId: json['order_id']?.toString(),
      buyerId: json['buyer_id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      itemAmount: (json['item_amount'] as num?)?.toDouble() ?? 0.0,
      deliveryFeeEstimate:
          (json['delivery_fee_estimate'] as num?)?.toDouble() ?? 0.0,
      buyerFee: (json['buyer_fee'] as num?)?.toDouble() ?? 0.0,
      totalLocked: (json['total_locked'] as num?)?.toDouble() ?? 0.0,
      actualDeliveryFee:
          (json['actual_delivery_fee'] as num?)?.toDouble() ?? 0.0,
      sellerPayout: (json['seller_payout'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? '',
      fundedAt: json['funded_at'] != null
          ? DateTime.tryParse(json['funded_at'].toString())
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  DisputeEscrowEntity toEntity() {
    return DisputeEscrowEntity(
      id: id,
      paymentRequestId: paymentRequestId,
      orderId: orderId,
      buyerId: buyerId,
      sellerId: sellerId,
      itemAmount: itemAmount,
      deliveryFeeEstimate: deliveryFeeEstimate,
      buyerFee: buyerFee,
      totalLocked: totalLocked,
      actualDeliveryFee: actualDeliveryFee,
      sellerPayout: sellerPayout,
      status: status,
      fundedAt: fundedAt,
      createdAt: createdAt,
    );
  }
}

class DisputeModel {
  final String id;
  final String escrowId;
  final String openedBy;
  final String reason;
  final List<String> evidence;
  final String status;
  final String outcome;
  final String? resolutionNotes;
  final String? resolvedBy;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final String role;
  final String counterPartyName;
  final DisputePaymentRequestModel paymentRequest;
  final DisputeEscrowModel escrow;

  const DisputeModel({
    required this.id,
    required this.escrowId,
    required this.openedBy,
    required this.reason,
    required this.evidence,
    required this.status,
    required this.outcome,
    this.resolutionNotes,
    this.resolvedBy,
    this.resolvedAt,
    required this.createdAt,
    required this.role,
    required this.counterPartyName,
    required this.paymentRequest,
    required this.escrow,
  });

  factory DisputeModel.fromJson(Map<String, dynamic> json) {
    return DisputeModel(
      id: json['id']?.toString() ?? '',
      escrowId: json['escrow_id']?.toString() ?? '',
      openedBy: json['opened_by']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      evidence: (json['evidence'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: json['status']?.toString() ?? '',
      outcome: json['outcome']?.toString() ?? '',
      resolutionNotes: json['resolution_notes']?.toString(),
      resolvedBy: json['resolved_by']?.toString(),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.tryParse(json['resolved_at'].toString())
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      role: json['role']?.toString() ?? '',
      counterPartyName: json['counter_party_name']?.toString() ?? '',
      paymentRequest: DisputePaymentRequestModel.fromJson(
        json['payment_request'] as Map<String, dynamic>? ?? {},
      ),
      escrow: DisputeEscrowModel.fromJson(
        json['escrow'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  DisputeEntity toEntity() {
    return DisputeEntity(
      id: id,
      escrowId: escrowId,
      openedBy: openedBy,
      reason: reason,
      evidence: evidence,
      status: status,
      outcome: outcome,
      resolutionNotes: resolutionNotes,
      resolvedBy: resolvedBy,
      resolvedAt: resolvedAt,
      createdAt: createdAt,
      role: role,
      counterPartyName: counterPartyName,
      paymentRequest: paymentRequest.toEntity(),
      escrow: escrow.toEntity(),
    );
  }
}

class DisputeListModel {
  final List<DisputeModel> disputes;
  final int count;

  const DisputeListModel({required this.disputes, required this.count});

  factory DisputeListModel.fromJson(Map<String, dynamic> json) {
    return DisputeListModel(
      disputes: (json['disputes'] as List<dynamic>?)
              ?.map((e) => DisputeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  DisputeListEntity toEntity() {
    return DisputeListEntity(
      disputes: disputes.map((d) => d.toEntity()).toList(),
      count: count,
    );
  }
}
