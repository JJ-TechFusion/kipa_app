class TransactionStatusEntity {
  final String id;
  final String status;
  final String viewerRole;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String deliveryType;
  final int processingTimeHours;
  final DateTime createdAt;
  final FeeInfoEntity feeInfo;
  final PaymentInfoEntity payment;
  final UserInfoEntity seller;
  final UserInfoEntity buyer;
  final TransactionTimelineEntity timeline;

  const TransactionStatusEntity({
    required this.id,
    required this.status,
    required this.viewerRole,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.deliveryType,
    required this.processingTimeHours,
    required this.createdAt,
    required this.feeInfo,
    required this.payment,
    required this.seller,
    required this.buyer,
    required this.timeline,
  });

  bool get isBuyer => viewerRole == 'buyer';
  bool get isSeller => viewerRole == 'seller';
}

class FeeInfoEntity {
  final double estimatedDeliveryFee;
  final double? serviceFee; // For buyers
  final double? platformFee; // For sellers
  final double buyerPaysTotal;
  final double? youReceive; // For sellers

  const FeeInfoEntity({
    required this.estimatedDeliveryFee,
    this.serviceFee,
    this.platformFee,
    required this.buyerPaysTotal,
    this.youReceive,
  });
}

class PaymentInfoEntity {
  final bool isPaid;
  final double amount;
  final String paymentMethod;
  final DateTime? paidAt;

  const PaymentInfoEntity({
    required this.isPaid,
    required this.amount,
    required this.paymentMethod,
    this.paidAt,
  });
}

class UserInfoEntity {
  final String id;
  final String name;
  final String phoneNumber;

  const UserInfoEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });
}

class TransactionTimelineEntity {
  final List<TransactionTimelineStepEntity> steps;
  final String currentStep;
  final String itemName;
  final double totalAmount;
  final String deliveryType;

  const TransactionTimelineEntity({
    required this.steps,
    required this.currentStep,
    required this.itemName,
    required this.totalAmount,
    required this.deliveryType,
  });
}

class TransactionTimelineStepEntity {
  final String step;
  final String title;
  final String description;
  final String status;
  final DateTime? timestamp;

  const TransactionTimelineStepEntity({
    required this.step,
    required this.title,
    required this.description,
    required this.status,
    this.timestamp,
  });

  bool get isCompleted => status == 'completed';
  bool get isCurrent => status == 'current';
  bool get isPending => status == 'pending';
}
