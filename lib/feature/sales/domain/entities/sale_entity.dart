class SaleEntity {
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

  const SaleEntity({
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
}

class StatusCountsEntity {
  final int all;
  final int completed;
  final int disputed;
  final int inDelivery;
  final int processing;

  const StatusCountsEntity({
    required this.all,
    required this.completed,
    required this.disputed,
    required this.inDelivery,
    required this.processing,
  });
}

class SaleListEntity {
  final int count;
  final List<SaleEntity> sales;
  final StatusCountsEntity? statusCounts;

  const SaleListEntity({
    required this.count,
    required this.sales,
    this.statusCounts,
  });
}

class EscrowEntity {
  final String id;
  final String status;
  final double itemAmount;
  final double totalLocked;
  final DateTime? fundedAt;

  const EscrowEntity({
    required this.id,
    required this.status,
    required this.itemAmount,
    required this.totalLocked,
    this.fundedAt,
  });
}

class SaleDeliveryEntity {
  final String jobId;
  final String status;
  final String? pickupCode;
  final bool riderAssigned;

  const SaleDeliveryEntity({
    required this.jobId,
    required this.status,
    this.pickupCode,
    required this.riderAssigned,
  });
}

class TimelineStepEntity {
  final String step;
  final String title;
  final String description;
  final String status;
  final DateTime? timestamp;

  const TimelineStepEntity({
    required this.step,
    required this.title,
    required this.description,
    required this.status,
    this.timestamp,
  });
}

class TimelineEntity {
  final List<TimelineStepEntity> steps;
  final String currentStep;
  final String itemName;
  final double totalAmount;
  final String deliveryType;
  final String? pickupCode;

  const TimelineEntity({
    required this.steps,
    required this.currentStep,
    required this.itemName,
    required this.totalAmount,
    required this.deliveryType,
    this.pickupCode,
  });
}

class SaleDetailEntity {
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
  final EscrowEntity? escrow;
  final SaleDeliveryEntity? delivery;
  final TimelineEntity? timeline;

  const SaleDetailEntity({
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
}
