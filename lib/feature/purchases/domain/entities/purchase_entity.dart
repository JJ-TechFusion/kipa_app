class PurchaseDeliveryEntity {
  final String jobId;
  final String status;
  final String? dropoffCode;
  final bool riderAssigned;
  final String? pickupAddress;
  final String? dropoffAddress;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;

  const PurchaseDeliveryEntity({
    required this.jobId,
    required this.status,
    this.dropoffCode,
    required this.riderAssigned,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickedUpAt,
    this.deliveredAt,
  });
}

class PurchaseEntity {
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
  final PurchaseDeliveryEntity? delivery;
  final String? pickupAddress;
  final String? dropoffAddress;

  const PurchaseEntity({
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

class PurchaseListEntity {
  final int count;
  final List<PurchaseEntity> purchases;
  final StatusCountsEntity? statusCounts;

  const PurchaseListEntity({
    required this.count,
    required this.purchases,
    this.statusCounts,
  });
}

class PurchaseTimelineStepEntity {
  final String step;
  final String title;
  final String description;
  final String status;
  final DateTime? timestamp;

  const PurchaseTimelineStepEntity({
    required this.step,
    required this.title,
    required this.description,
    required this.status,
    this.timestamp,
  });
}

class PurchaseTimelineEntity {
  final List<PurchaseTimelineStepEntity> steps;
  final String currentStep;
  final String itemName;
  final double totalAmount;
  final String deliveryType;
  final String? dropoffCode;

  const PurchaseTimelineEntity({
    required this.steps,
    required this.currentStep,
    required this.itemName,
    required this.totalAmount,
    required this.deliveryType,
    this.dropoffCode,
  });
}

class PurchaseDetailEntity {
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
  final PurchaseDeliveryEntity? delivery;
  final PurchaseTimelineEntity? timeline;

  const PurchaseDetailEntity({
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
  });
}
