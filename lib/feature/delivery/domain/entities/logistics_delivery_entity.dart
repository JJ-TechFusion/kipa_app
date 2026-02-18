class LogisticsUserEntity {
  final String id;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  const LogisticsUserEntity({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';
}

class LogisticsDeliveryEntity {
  final String id;
  final String paymentRequestId;
  final String escrowId;
  final String carrier;
  final String carrierDisplayName;
  final String? trackingNumber;
  final String? trackingUrl;
  final String? shipmentReceiptUrl;
  final DateTime? estimatedDeliveryAt;
  final String pickupAddress;
  final String pickupState;
  final String dropoffAddress;
  final String dropoffState;
  final String status;
  final String statusDisplay;
  final DateTime shipDeadline;
  final bool isShipDeadlineExceeded;
  final bool requiresAdminApproval;
  final String itemName;
  final double itemPrice;
  final double escrowAmount;
  final String escrowStatus;
  final LogisticsUserEntity seller;
  final LogisticsUserEntity buyer;
  final List<String> availableActions;
  final DateTime? shippedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LogisticsDeliveryEntity({
    required this.id,
    required this.paymentRequestId,
    required this.escrowId,
    required this.carrier,
    required this.carrierDisplayName,
    this.trackingNumber,
    this.trackingUrl,
    this.shipmentReceiptUrl,
    this.estimatedDeliveryAt,
    required this.pickupAddress,
    required this.pickupState,
    required this.dropoffAddress,
    required this.dropoffState,
    required this.status,
    required this.statusDisplay,
    required this.shipDeadline,
    required this.isShipDeadlineExceeded,
    required this.requiresAdminApproval,
    required this.itemName,
    required this.itemPrice,
    required this.escrowAmount,
    required this.escrowStatus,
    required this.seller,
    required this.buyer,
    required this.availableActions,
    this.shippedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canMarkShipped => availableActions.contains('mark_shipped');
  bool get canClaimDelivery => availableActions.contains('claim_delivery');
  bool get canConfirmDelivery => availableActions.contains('confirm_delivery');
  bool get canOpenDispute => availableActions.contains('open_dispute');
  bool get isAwaitingShipment => status == 'awaiting_shipment';
  bool get isShipped => status == 'shipped';
}

class LogisticsDeliveryListEntity {
  final List<LogisticsDeliveryEntity> deliveries;
  final int total;
  final int limit;
  final int offset;

  const LogisticsDeliveryListEntity({
    required this.deliveries,
    required this.total,
    required this.limit,
    required this.offset,
  });
}

class LogisticsTimelineStep {
  final String status;
  final String title;
  final String description;
  final DateTime? timestamp;
  final String? actorType;
  final bool isCompleted;
  final bool isCurrent;
  final bool isDispute;

  const LogisticsTimelineStep({
    required this.status,
    required this.title,
    required this.description,
    this.timestamp,
    this.actorType,
    required this.isCompleted,
    required this.isCurrent,
    required this.isDispute,
  });
}

class LogisticsTimeline {
  final String deliveryId;
  final String currentStatus;
  final List<LogisticsTimelineStep> steps;
  final bool hasDispute;
  final List<LogisticsTimelineStep> disputeSteps;

  const LogisticsTimeline({
    required this.deliveryId,
    required this.currentStatus,
    required this.steps,
    required this.hasDispute,
    required this.disputeSteps,
  });
}

class LogisticsDisputeEntity {
  final String id;
  final String reason;
  final String status;
  final String? outcome;
  final String? resolutionNotes;
  final List<String> evidence;

  const LogisticsDisputeEntity({
    required this.id,
    required this.reason,
    required this.status,
    this.outcome,
    this.resolutionNotes,
    required this.evidence,
  });
}

class LogisticsEscrowEntity {
  final String id;
  final double itemAmount;
  final double buyerFee;
  final double totalLocked;
  final String status;

  const LogisticsEscrowEntity({
    required this.id,
    required this.itemAmount,
    required this.buyerFee,
    required this.totalLocked,
    required this.status,
  });
}

class LogisticsEventEntity {
  final String id;
  final String? fromStatus;
  final String toStatus;
  final String actorType;
  final String? reason;
  final DateTime createdAt;

  const LogisticsEventEntity({
    required this.id,
    this.fromStatus,
    required this.toStatus,
    required this.actorType,
    this.reason,
    required this.createdAt,
  });
}

class LogisticsPaymentRequestSummary {
  final String id;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final double buyerServiceFee;
  final double estimatedTotal;

  const LogisticsPaymentRequestSummary({
    required this.id,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.buyerServiceFee,
    required this.estimatedTotal,
  });
}

class LogisticsDeliveryDetailsEntity {
  final LogisticsUserEntity buyer;
  final LogisticsUserEntity seller;
  final LogisticsDeliveryEntity delivery;
  final LogisticsPaymentRequestSummary paymentRequest;
  final LogisticsDisputeEntity? dispute;
  final LogisticsEscrowEntity? escrow;
  final LogisticsTimeline? timeline;
  final List<LogisticsEventEntity> events;

  const LogisticsDeliveryDetailsEntity({
    required this.buyer,
    required this.seller,
    required this.delivery,
    required this.paymentRequest,
    this.dispute,
    this.escrow,
    this.timeline,
    required this.events,
  });
}
