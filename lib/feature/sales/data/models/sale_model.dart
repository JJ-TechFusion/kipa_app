import '../../domain/entities/sale_entity.dart';

class SaleModel {
  final String id;
  final String paymentRequestId;
  final String itemName;
  final double itemPrice;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String escrowStatus;
  final String buyerId;
  final String? deliveryJobId;
  final DateTime createdAt;
  final DateTime? paidAt;

  const SaleModel({
    required this.id,
    required this.paymentRequestId,
    required this.itemName,
    required this.itemPrice,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.escrowStatus,
    required this.buyerId,
    this.deliveryJobId,
    required this.createdAt,
    this.paidAt,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return SaleModel(
      id: json['id']?.toString() ?? '',
      paymentRequestId: json['payment_request_id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemPrice: parseDouble(json['item_price']),
      totalAmount: parseDouble(json['total_amount']),
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      orderStatus: json['order_status']?.toString() ?? '',
      escrowStatus: json['escrow_status']?.toString() ?? '',
      buyerId: json['buyer_id']?.toString() ?? '',
      deliveryJobId: json['delivery_job_id']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'].toString())
          : null,
    );
  }

  SaleEntity toEntity() {
    return SaleEntity(
      id: id,
      paymentRequestId: paymentRequestId,
      itemName: itemName,
      itemPrice: itemPrice,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      orderStatus: orderStatus,
      escrowStatus: escrowStatus,
      buyerId: buyerId,
      deliveryJobId: deliveryJobId,
      createdAt: createdAt,
      paidAt: paidAt,
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

class SaleListModel {
  final int count;
  final List<SaleModel> sales;
  final StatusCountsModel? statusCounts;

  const SaleListModel({
    required this.count,
    required this.sales,
    this.statusCounts,
  });

  factory SaleListModel.fromJson(Map<String, dynamic> json) {
    return SaleListModel(
      count: json['count'] as int? ?? 0,
      sales: (json['sales'] as List<dynamic>?)
              ?.map((e) => SaleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      statusCounts: json['status_counts'] != null
          ? StatusCountsModel.fromJson(
              json['status_counts'] as Map<String, dynamic>)
          : null,
    );
  }

  SaleListEntity toEntity() {
    return SaleListEntity(
      count: count,
      sales: sales.map((e) => e.toEntity()).toList(),
      statusCounts: statusCounts?.toEntity(),
    );
  }
}

class EscrowModel {
  final String id;
  final String status;
  final double itemAmount;
  final double totalLocked;
  final DateTime? fundedAt;

  const EscrowModel({
    required this.id,
    required this.status,
    required this.itemAmount,
    required this.totalLocked,
    this.fundedAt,
  });

  factory EscrowModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return EscrowModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      itemAmount: parseDouble(json['item_amount']),
      totalLocked: parseDouble(json['total_locked']),
      fundedAt: json['funded_at'] != null
          ? DateTime.tryParse(json['funded_at'].toString())
          : null,
    );
  }

  EscrowEntity toEntity() {
    return EscrowEntity(
      id: id,
      status: status,
      itemAmount: itemAmount,
      totalLocked: totalLocked,
      fundedAt: fundedAt,
    );
  }
}

class SaleDeliveryModel {
  final String jobId;
  final String status;
  final String? pickupCode;
  final bool riderAssigned;

  const SaleDeliveryModel({
    required this.jobId,
    required this.status,
    this.pickupCode,
    required this.riderAssigned,
  });

  factory SaleDeliveryModel.fromJson(Map<String, dynamic> json) {
    return SaleDeliveryModel(
      jobId: json['job_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      pickupCode: json['pickup_code']?.toString(),
      riderAssigned: json['rider_assigned'] as bool? ?? false,
    );
  }

  SaleDeliveryEntity toEntity() {
    return SaleDeliveryEntity(
      jobId: jobId,
      status: status,
      pickupCode: pickupCode,
      riderAssigned: riderAssigned,
    );
  }
}

class TimelineStepModel {
  final String step;
  final String title;
  final String description;
  final String status;
  final DateTime? timestamp;

  const TimelineStepModel({
    required this.step,
    required this.title,
    required this.description,
    required this.status,
    this.timestamp,
  });

  factory TimelineStepModel.fromJson(Map<String, dynamic> json) {
    return TimelineStepModel(
      step: json['step']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
    );
  }

  TimelineStepEntity toEntity() {
    return TimelineStepEntity(
      step: step,
      title: title,
      description: description,
      status: status,
      timestamp: timestamp,
    );
  }
}

class TimelineModel {
  final List<TimelineStepModel> steps;
  final String currentStep;
  final String itemName;
  final double totalAmount;
  final String deliveryType;
  final String? pickupCode;

  const TimelineModel({
    required this.steps,
    required this.currentStep,
    required this.itemName,
    required this.totalAmount,
    required this.deliveryType,
    this.pickupCode,
  });

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return TimelineModel(
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => TimelineStepModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentStep: json['current_step']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      totalAmount: parseDouble(json['total_amount']),
      deliveryType: json['delivery_type']?.toString() ?? '',
      pickupCode: json['pickup_code']?.toString(),
    );
  }

  TimelineEntity toEntity() {
    return TimelineEntity(
      steps: steps.map((e) => e.toEntity()).toList(),
      currentStep: currentStep,
      itemName: itemName,
      totalAmount: totalAmount,
      deliveryType: deliveryType,
      pickupCode: pickupCode,
    );
  }
}

class SaleDetailModel {
  final String id;
  final String paymentRequestId;
  final String itemName;
  final double itemPrice;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String escrowStatus;
  final String buyerId;
  final DateTime createdAt;
  final DateTime? paidAt;
  final EscrowModel? escrow;
  final SaleDeliveryModel? delivery;
  final TimelineModel? timeline;

  const SaleDetailModel({
    required this.id,
    required this.paymentRequestId,
    required this.itemName,
    required this.itemPrice,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.escrowStatus,
    required this.buyerId,
    required this.createdAt,
    this.paidAt,
    this.escrow,
    this.delivery,
    this.timeline,
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return SaleDetailModel(
      id: json['id']?.toString() ?? '',
      paymentRequestId: json['payment_request_id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemPrice: parseDouble(json['item_price']),
      totalAmount: parseDouble(json['total_amount']),
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      orderStatus: json['order_status']?.toString() ?? '',
      escrowStatus: json['escrow_status']?.toString() ?? '',
      buyerId: json['buyer_id']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'].toString())
          : null,
      escrow: json['escrow'] != null
          ? EscrowModel.fromJson(json['escrow'] as Map<String, dynamic>)
          : null,
      delivery: json['delivery'] != null
          ? SaleDeliveryModel.fromJson(json['delivery'] as Map<String, dynamic>)
          : null,
      timeline: json['timeline'] != null
          ? TimelineModel.fromJson(json['timeline'] as Map<String, dynamic>)
          : null,
    );
  }

  SaleDetailEntity toEntity() {
    return SaleDetailEntity(
      id: id,
      paymentRequestId: paymentRequestId,
      itemName: itemName,
      itemPrice: itemPrice,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      orderStatus: orderStatus,
      escrowStatus: escrowStatus,
      buyerId: buyerId,
      createdAt: createdAt,
      paidAt: paidAt,
      escrow: escrow?.toEntity(),
      delivery: delivery?.toEntity(),
      timeline: timeline?.toEntity(),
    );
  }
}
