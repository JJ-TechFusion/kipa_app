class DisputePaymentRequestEntity {
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

  const DisputePaymentRequestEntity({
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
}

class DisputeEscrowEntity {
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

  const DisputeEscrowEntity({
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
}

class DisputeEntity {
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
  final DisputePaymentRequestEntity paymentRequest;
  final DisputeEscrowEntity escrow;

  const DisputeEntity({
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
}

class DisputeListEntity {
  final List<DisputeEntity> disputes;
  final int count;

  const DisputeListEntity({required this.disputes, required this.count});
}
