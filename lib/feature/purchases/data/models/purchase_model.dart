import '../../domain/entities/purchase_entity.dart';

class PurchaseDeliveryModel {
  final String jobId;
  final String status;
  final String? dropoffCode;
  final bool riderAssigned;
  final String? pickupAddress;
  final String? dropoffAddress;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final String? phase;
  final String? returnStatus;
  final String? returnJobId;

  const PurchaseDeliveryModel({
    required this.jobId,
    required this.status,
    this.dropoffCode,
    required this.riderAssigned,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickedUpAt,
    this.deliveredAt,
    this.phase,
    this.returnStatus,
    this.returnJobId,
  });

  factory PurchaseDeliveryModel.fromJson(Map<String, dynamic> json) {
    return PurchaseDeliveryModel(
      jobId: json['job_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      dropoffCode: json['dropoff_code']?.toString(),
      riderAssigned: json['rider_assigned'] as bool? ?? false,
      pickupAddress: json['pickup_address']?.toString(),
      dropoffAddress: json['dropoff_address']?.toString(),
      pickedUpAt: json['picked_up_at'] != null
          ? DateTime.tryParse(json['picked_up_at'].toString())
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.tryParse(json['delivered_at'].toString())
          : null,
      phase: json['phase']?.toString(),
      returnStatus: json['return_status']?.toString(),
      returnJobId: json['return_job_id']?.toString(),
    );
  }

  PurchaseDeliveryEntity toEntity() {
    return PurchaseDeliveryEntity(
      jobId: jobId,
      status: status,
      dropoffCode: dropoffCode,
      riderAssigned: riderAssigned,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickedUpAt: pickedUpAt,
      deliveredAt: deliveredAt,
      phase: phase,
      returnStatus: returnStatus,
      returnJobId: returnJobId,
    );
  }
}

class PurchaseModel {
  final String id;
  final String paymentRequestId;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String deliveryType;
  final double estimatedDeliveryFee;
  final double buyerServiceFee;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final String sellerId;
  final String escrowId;
  final int processingTimeHours;
  final DateTime? paidAt;
  final DateTime createdAt;
  final PurchaseDeliveryModel? delivery;
  final String? pickupAddress;
  final String? dropoffAddress;
  final String? prStatus;
  final String? returnJobId;

  const PurchaseModel({
    required this.id,
    required this.paymentRequestId,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.deliveryType,
    required this.estimatedDeliveryFee,
    required this.buyerServiceFee,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.sellerId,
    required this.escrowId,
    this.processingTimeHours = 0,
    this.paidAt,
    required this.createdAt,
    this.delivery,
    this.pickupAddress,
    this.dropoffAddress,
    this.prStatus,
    this.returnJobId,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return PurchaseModel(
      id: json['id']?.toString() ?? '',
      paymentRequestId: json['payment_request_id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemDescription: json['item_description']?.toString() ?? '',
      itemPrice: parseDouble(json['item_price']),
      deliveryType: json['delivery_type']?.toString() ?? '',
      estimatedDeliveryFee: parseDouble(json['estimated_delivery_fee']),
      buyerServiceFee: parseDouble(json['buyer_service_fee']),
      totalAmount: parseDouble(json['total_amount']),
      paymentMethod: json['payment_method']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      escrowId: json['escrow_id']?.toString() ?? '',
      processingTimeHours: json['processing_time_hours'] as int? ?? 0,
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      delivery: json['delivery'] != null
          ? PurchaseDeliveryModel.fromJson(
              json['delivery'] as Map<String, dynamic>,
            )
          : null,
      pickupAddress: json['pickup_address']?.toString(),
      dropoffAddress: json['dropoff_address']?.toString(),
      prStatus: json['pr_status']?.toString(),
      returnJobId: json['return_job_id']?.toString(),
    );
  }

  PurchaseEntity toEntity() {
    return PurchaseEntity(
      id: id,
      paymentRequestId: paymentRequestId,
      itemName: itemName,
      itemDescription: itemDescription,
      itemPrice: itemPrice,
      deliveryType: deliveryType,
      estimatedDeliveryFee: estimatedDeliveryFee,
      buyerServiceFee: buyerServiceFee,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      status: status,
      sellerId: sellerId,
      escrowId: escrowId,
      processingTimeHours: processingTimeHours,
      paidAt: paidAt,
      createdAt: createdAt,
      delivery: delivery?.toEntity(),
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      prStatus: prStatus,
      returnJobId: returnJobId,
    );
  }
}

class StatusCountsModel {
  final int all;
  final int completed;
  final int disputed;
  final int inDelivery;
  final int processing;

  const StatusCountsModel({
    required this.all,
    required this.completed,
    required this.disputed,
    required this.inDelivery,
    required this.processing,
  });

  factory StatusCountsModel.fromJson(Map<String, dynamic> json) {
    return StatusCountsModel(
      all: json['all'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      disputed: json['disputed'] as int? ?? 0,
      inDelivery: json['in_delivery'] as int? ?? 0,
      processing: json['processing'] as int? ?? 0,
    );
  }

  StatusCountsEntity toEntity() {
    return StatusCountsEntity(
      all: all,
      completed: completed,
      disputed: disputed,
      inDelivery: inDelivery,
      processing: processing,
    );
  }
}

class PurchaseListModel {
  final int count;
  final List<PurchaseModel> purchases;
  final StatusCountsModel? statusCounts;

  const PurchaseListModel({
    required this.count,
    required this.purchases,
    this.statusCounts,
  });

  factory PurchaseListModel.fromJson(Map<String, dynamic> json) {
    return PurchaseListModel(
      count: json['count'] as int? ?? 0,
      purchases:
          (json['purchases'] as List<dynamic>?)
              ?.map((e) => PurchaseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      statusCounts: json['status_counts'] != null
          ? StatusCountsModel.fromJson(
              json['status_counts'] as Map<String, dynamic>)
          : null,
    );
  }

  PurchaseListEntity toEntity() {
    return PurchaseListEntity(
      count: count,
      purchases: purchases.map((e) => e.toEntity()).toList(),
      statusCounts: statusCounts?.toEntity(),
    );
  }
}

class PurchaseTimelineStepModel {
  final String step;
  final String title;
  final String description;
  final String status;
  final DateTime? timestamp;

  const PurchaseTimelineStepModel({
    required this.step,
    required this.title,
    required this.description,
    required this.status,
    this.timestamp,
  });

  factory PurchaseTimelineStepModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTimelineStepModel(
      step: json['step']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
    );
  }

  PurchaseTimelineStepEntity toEntity() {
    return PurchaseTimelineStepEntity(
      step: step,
      title: title,
      description: description,
      status: status,
      timestamp: timestamp,
    );
  }
}

class PurchaseTimelineModel {
  final List<PurchaseTimelineStepModel> steps;
  final String currentStep;
  final String itemName;
  final double totalAmount;
  final String deliveryType;
  final String? dropoffCode;
  final String? pickupCode;
  final String? phase;

  const PurchaseTimelineModel({
    required this.steps,
    required this.currentStep,
    required this.itemName,
    required this.totalAmount,
    required this.deliveryType,
    this.dropoffCode,
    this.pickupCode,
    this.phase,
  });

  factory PurchaseTimelineModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return PurchaseTimelineModel(
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map(
                (e) => PurchaseTimelineStepModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      currentStep: json['current_step']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      totalAmount: parseDouble(json['total_amount']),
      deliveryType: json['delivery_type']?.toString() ?? '',
      dropoffCode: json['dropoff_code']?.toString(),
      pickupCode: json['pickup_code']?.toString(),
      phase: json['phase']?.toString(),
    );
  }

  PurchaseTimelineEntity toEntity() {
    return PurchaseTimelineEntity(
      steps: steps.map((e) => e.toEntity()).toList(),
      currentStep: currentStep,
      itemName: itemName,
      totalAmount: totalAmount,
      deliveryType: deliveryType,
      dropoffCode: dropoffCode,
      pickupCode: pickupCode,
      phase: phase,
    );
  }
}

class PurchaseDetailModel {
  final String id;
  final String paymentRequestId;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String deliveryType;
  final double estimatedDeliveryFee;
  final double buyerServiceFee;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final String sellerId;
  final String escrowId;
  final int processingTimeHours;
  final DateTime? paidAt;
  final DateTime createdAt;
  final PurchaseDeliveryModel? delivery;
  final PurchaseTimelineModel? timeline;
  final String? prStatus;

  const PurchaseDetailModel({
    required this.id,
    required this.paymentRequestId,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.deliveryType,
    required this.estimatedDeliveryFee,
    required this.buyerServiceFee,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.sellerId,
    required this.escrowId,
    this.processingTimeHours = 0,
    this.paidAt,
    required this.createdAt,
    this.delivery,
    this.timeline,
    this.prStatus,
  });

  factory PurchaseDetailModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return PurchaseDetailModel(
      id: json['id']?.toString() ?? '',
      paymentRequestId: json['payment_request_id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemDescription: json['item_description']?.toString() ?? '',
      itemPrice: parseDouble(json['item_price']),
      deliveryType: json['delivery_type']?.toString() ?? '',
      estimatedDeliveryFee: parseDouble(json['estimated_delivery_fee']),
      buyerServiceFee: parseDouble(json['buyer_service_fee']),
      totalAmount: parseDouble(json['total_amount']),
      paymentMethod: json['payment_method']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      escrowId: json['escrow_id']?.toString() ?? '',
      processingTimeHours: json['processing_time_hours'] as int? ?? 0,
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      delivery: json['delivery'] != null
          ? PurchaseDeliveryModel.fromJson(
              json['delivery'] as Map<String, dynamic>,
            )
          : null,
      timeline: json['timeline'] != null
          ? PurchaseTimelineModel.fromJson(
              json['timeline'] as Map<String, dynamic>,
            )
          : null,
      prStatus: json['pr_status']?.toString(),
    );
  }

  PurchaseDetailEntity toEntity() {
    return PurchaseDetailEntity(
      id: id,
      paymentRequestId: paymentRequestId,
      itemName: itemName,
      itemDescription: itemDescription,
      itemPrice: itemPrice,
      deliveryType: deliveryType,
      estimatedDeliveryFee: estimatedDeliveryFee,
      buyerServiceFee: buyerServiceFee,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      status: status,
      sellerId: sellerId,
      escrowId: escrowId,
      processingTimeHours: processingTimeHours,
      paidAt: paidAt,
      createdAt: createdAt,
      delivery: delivery?.toEntity(),
      timeline: timeline?.toEntity(),
      prStatus: prStatus,
    );
  }
}
