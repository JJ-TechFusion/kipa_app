import '../../domain/entities/logistics_delivery_entity.dart';

class LogisticsUserModel {
  final String id;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  const LogisticsUserModel({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  factory LogisticsUserModel.fromJson(Map<String, dynamic> json) {
    return LogisticsUserModel(
      id: json['id']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
    );
  }

  LogisticsUserEntity toEntity() {
    return LogisticsUserEntity(
      id: id,
      phoneNumber: phoneNumber,
      firstName: firstName,
      lastName: lastName,
    );
  }
}

class LogisticsDeliveryModel {
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
  final LogisticsUserModel seller;
  final LogisticsUserModel buyer;
  final List<String> availableActions;
  final DateTime? shippedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LogisticsDeliveryModel({
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

  factory LogisticsDeliveryModel.fromJson(Map<String, dynamic> json) {
    return LogisticsDeliveryModel(
      id: json['id']?.toString() ?? '',
      paymentRequestId: json['payment_request_id']?.toString() ?? '',
      escrowId: json['escrow_id']?.toString() ?? '',
      carrier: json['carrier']?.toString() ?? '',
      carrierDisplayName: json['carrier_display_name']?.toString() ?? '',
      trackingNumber: json['tracking_number']?.toString(),
      trackingUrl: json['tracking_url']?.toString(),
      shipmentReceiptUrl: json['shipment_receipt_url']?.toString(),
      estimatedDeliveryAt: json['estimated_delivery_at'] != null
          ? DateTime.tryParse(json['estimated_delivery_at'].toString())
          : null,
      pickupAddress: json['pickup_address']?.toString() ?? '',
      pickupState: json['pickup_state']?.toString() ?? '',
      dropoffAddress: json['dropoff_address']?.toString() ?? '',
      dropoffState: json['dropoff_state']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusDisplay: json['status_display']?.toString() ?? '',
      shipDeadline:
          DateTime.tryParse(json['ship_deadline']?.toString() ?? '') ??
          DateTime.now(),
      isShipDeadlineExceeded:
          json['is_ship_deadline_exceeded'] as bool? ?? false,
      requiresAdminApproval: json['requires_admin_approval'] as bool? ?? false,
      itemName: json['item_name']?.toString() ?? '',
      itemPrice: (json['item_price'] ?? 0).toDouble(),
      escrowAmount: (json['escrow_amount'] ?? 0).toDouble(),
      escrowStatus: json['escrow_status']?.toString() ?? '',
      seller: LogisticsUserModel.fromJson(
        json['seller'] as Map<String, dynamic>? ?? {},
      ),
      buyer: LogisticsUserModel.fromJson(
        json['buyer'] as Map<String, dynamic>? ?? {},
      ),
      availableActions:
          (json['available_actions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      shippedAt: json['shipped_at'] != null
          ? DateTime.tryParse(json['shipped_at'].toString())
          : null,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  LogisticsDeliveryEntity toEntity() {
    return LogisticsDeliveryEntity(
      id: id,
      paymentRequestId: paymentRequestId,
      escrowId: escrowId,
      carrier: carrier,
      carrierDisplayName: carrierDisplayName,
      trackingNumber: trackingNumber,
      trackingUrl: trackingUrl,
      shipmentReceiptUrl: shipmentReceiptUrl,
      estimatedDeliveryAt: estimatedDeliveryAt,
      pickupAddress: pickupAddress,
      pickupState: pickupState,
      dropoffAddress: dropoffAddress,
      dropoffState: dropoffState,
      status: status,
      statusDisplay: statusDisplay,
      shipDeadline: shipDeadline,
      isShipDeadlineExceeded: isShipDeadlineExceeded,
      requiresAdminApproval: requiresAdminApproval,
      itemName: itemName,
      itemPrice: itemPrice,
      escrowAmount: escrowAmount,
      escrowStatus: escrowStatus,
      seller: seller.toEntity(),
      buyer: buyer.toEntity(),
      availableActions: availableActions,
      shippedAt: shippedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class LogisticsTimelineStepModel {
  final String status;
  final String title;
  final String description;
  final DateTime? timestamp;
  final String? actorType;
  final bool isCompleted;
  final bool isCurrent;
  final bool isDispute;

  const LogisticsTimelineStepModel({
    required this.status,
    required this.title,
    required this.description,
    this.timestamp,
    this.actorType,
    required this.isCompleted,
    required this.isCurrent,
    required this.isDispute,
  });

  factory LogisticsTimelineStepModel.fromJson(Map<String, dynamic> json) {
    return LogisticsTimelineStepModel(
      status: json['status']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
      actorType: json['actor_type']?.toString(),
      isCompleted: json['is_completed'] as bool? ?? false,
      isCurrent: json['is_current'] as bool? ?? false,
      isDispute: json['is_dispute'] as bool? ?? false,
    );
  }

  LogisticsTimelineStep toEntity() {
    return LogisticsTimelineStep(
      status: status,
      title: title,
      description: description,
      timestamp: timestamp,
      actorType: actorType,
      isCompleted: isCompleted,
      isCurrent: isCurrent,
      isDispute: isDispute,
    );
  }
}

class LogisticsTimelineModel {
  final String deliveryId;
  final String currentStatus;
  final List<LogisticsTimelineStepModel> steps;
  final bool hasDispute;
  final List<LogisticsTimelineStepModel> disputeSteps;

  const LogisticsTimelineModel({
    required this.deliveryId,
    required this.currentStatus,
    required this.steps,
    required this.hasDispute,
    required this.disputeSteps,
  });

  factory LogisticsTimelineModel.fromJson(Map<String, dynamic> json) {
    return LogisticsTimelineModel(
      deliveryId: json['delivery_id']?.toString() ?? '',
      currentStatus: json['current_status']?.toString() ?? '',
      hasDispute: json['has_dispute'] as bool? ?? false,
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map(
                (e) => LogisticsTimelineStepModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      disputeSteps:
          (json['dispute_steps'] as List<dynamic>?)
              ?.map(
                (e) => LogisticsTimelineStepModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  LogisticsTimeline toEntity() {
    return LogisticsTimeline(
      deliveryId: deliveryId,
      currentStatus: currentStatus,
      hasDispute: hasDispute,
      steps: steps.map((e) => e.toEntity()).toList(),
      disputeSteps: disputeSteps.map((e) => e.toEntity()).toList(),
    );
  }
}

class LogisticsDisputeModel {
  final String id;
  final String reason;
  final String status;
  final String? outcome;
  final String? resolutionNotes;
  final List<String> evidence;

  const LogisticsDisputeModel({
    required this.id,
    required this.reason,
    required this.status,
    this.outcome,
    this.resolutionNotes,
    required this.evidence,
  });

  factory LogisticsDisputeModel.fromJson(Map<String, dynamic> json) {
    return LogisticsDisputeModel(
      id: json['id']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      outcome: json['outcome']?.toString(),
      resolutionNotes: json['resolution_notes']?.toString(),
      evidence:
          (json['evidence'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  LogisticsDisputeEntity toEntity() {
    return LogisticsDisputeEntity(
      id: id,
      reason: reason,
      status: status,
      outcome: outcome,
      resolutionNotes: resolutionNotes,
      evidence: evidence,
    );
  }
}

class LogisticsEscrowModel {
  final String id;
  final double itemAmount;
  final double buyerFee;
  final double totalLocked;
  final String status;

  const LogisticsEscrowModel({
    required this.id,
    required this.itemAmount,
    required this.buyerFee,
    required this.totalLocked,
    required this.status,
  });

  factory LogisticsEscrowModel.fromJson(Map<String, dynamic> json) {
    return LogisticsEscrowModel(
      id: json['id']?.toString() ?? '',
      itemAmount: (json['item_amount'] ?? 0).toDouble(),
      buyerFee: (json['buyer_fee'] ?? 0).toDouble(),
      totalLocked: (json['total_locked'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? '',
    );
  }

  LogisticsEscrowEntity toEntity() {
    return LogisticsEscrowEntity(
      id: id,
      itemAmount: itemAmount,
      buyerFee: buyerFee,
      totalLocked: totalLocked,
      status: status,
    );
  }
}

class LogisticsEventModel {
  final String id;
  final String? fromStatus;
  final String toStatus;
  final String actorType;
  final String? reason;
  final DateTime createdAt;

  const LogisticsEventModel({
    required this.id,
    this.fromStatus,
    required this.toStatus,
    required this.actorType,
    this.reason,
    required this.createdAt,
  });

  factory LogisticsEventModel.fromJson(Map<String, dynamic> json) {
    return LogisticsEventModel(
      id: json['id']?.toString() ?? '',
      fromStatus: json['from_status']?.toString(),
      toStatus: json['to_status']?.toString() ?? '',
      actorType: json['actor_type']?.toString() ?? '',
      reason: json['reason']?.toString(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  LogisticsEventEntity toEntity() {
    return LogisticsEventEntity(
      id: id,
      fromStatus: fromStatus,
      toStatus: toStatus,
      actorType: actorType,
      reason: reason,
      createdAt: createdAt,
    );
  }
}

class LogisticsPaymentRequestSummaryModel {
  final String id;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final double buyerServiceFee;
  final double estimatedTotal;

  const LogisticsPaymentRequestSummaryModel({
    required this.id,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.buyerServiceFee,
    required this.estimatedTotal,
  });

  factory LogisticsPaymentRequestSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LogisticsPaymentRequestSummaryModel(
      id: json['id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemDescription: json['item_description']?.toString() ?? '',
      itemPrice: (json['item_price'] ?? 0).toDouble(),
      buyerServiceFee: (json['buyer_service_fee'] ?? 0).toDouble(),
      estimatedTotal: (json['estimated_total'] ?? 0).toDouble(),
    );
  }

  LogisticsPaymentRequestSummary toEntity() {
    return LogisticsPaymentRequestSummary(
      id: id,
      itemName: itemName,
      itemDescription: itemDescription,
      itemPrice: itemPrice,
      buyerServiceFee: buyerServiceFee,
      estimatedTotal: estimatedTotal,
    );
  }
}

class LogisticsDeliveryDetailsModel {
  final LogisticsUserModel buyer;
  final LogisticsUserModel seller;
  final LogisticsDeliveryModel delivery;
  final LogisticsPaymentRequestSummaryModel paymentRequest;
  final LogisticsDisputeModel? dispute;
  final LogisticsEscrowModel? escrow;
  final LogisticsTimelineModel? timeline;
  final List<LogisticsEventModel> events;

  const LogisticsDeliveryDetailsModel({
    required this.buyer,
    required this.seller,
    required this.delivery,
    required this.paymentRequest,
    this.dispute,
    this.escrow,
    this.timeline,
    required this.events,
  });

  factory LogisticsDeliveryDetailsModel.fromJson(Map<String, dynamic> json) {
    return LogisticsDeliveryDetailsModel(
      buyer: LogisticsUserModel.fromJson(
        json['buyer'] as Map<String, dynamic>? ?? {},
      ),
      seller: LogisticsUserModel.fromJson(
        json['seller'] as Map<String, dynamic>? ?? {},
      ),
      delivery: LogisticsDeliveryModel.fromJson(
        json['delivery'] as Map<String, dynamic>? ?? {},
      ),
      paymentRequest: LogisticsPaymentRequestSummaryModel.fromJson(
        json['payment_request'] as Map<String, dynamic>? ?? {},
      ),
      dispute: json['dispute'] != null
          ? LogisticsDisputeModel.fromJson(
              json['dispute'] as Map<String, dynamic>,
            )
          : null,
      escrow: json['escrow'] != null
          ? LogisticsEscrowModel.fromJson(
              json['escrow'] as Map<String, dynamic>,
            )
          : null,
      timeline: json['timeline'] != null
          ? LogisticsTimelineModel.fromJson(
              json['timeline'] as Map<String, dynamic>,
            )
          : null,
      events:
          (json['events'] as List<dynamic>?)
              ?.map(
                (e) => LogisticsEventModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  LogisticsDeliveryDetailsEntity toEntity() {
    return LogisticsDeliveryDetailsEntity(
      buyer: buyer.toEntity(),
      seller: seller.toEntity(),
      delivery: delivery.toEntity(),
      paymentRequest: paymentRequest.toEntity(),
      dispute: dispute?.toEntity(),
      escrow: escrow?.toEntity(),
      timeline: timeline?.toEntity(),
      events: events.map((e) => e.toEntity()).toList(),
    );
  }
}

class LogisticsDeliveryListModel {
  final List<LogisticsDeliveryModel> deliveries;
  final int total;
  final int limit;
  final int offset;

  const LogisticsDeliveryListModel({
    required this.deliveries,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory LogisticsDeliveryListModel.fromJson(Map<String, dynamic> json) {
    return LogisticsDeliveryListModel(
      deliveries:
          (json['deliveries'] as List<dynamic>?)
              ?.map(
                (e) =>
                    LogisticsDeliveryModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      limit: json['limit'] as int? ?? 20,
      offset: json['offset'] as int? ?? 0,
    );
  }

  LogisticsDeliveryListEntity toEntity() {
    return LogisticsDeliveryListEntity(
      deliveries: deliveries.map((e) => e.toEntity()).toList(),
      total: total,
      limit: limit,
      offset: offset,
    );
  }
}
