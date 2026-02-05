class CreatePaymentRequestEntity {
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final List<String> itemImages;
  final int processingTimeHours;
  final bool isReusable;
  final int? maxUses;

  const CreatePaymentRequestEntity({
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemImages,
    required this.processingTimeHours,
    required this.isReusable,
    this.maxUses,
  });

  Map<String, dynamic> toJson() => {
    'item_name': itemName,
    'item_description': itemDescription,
    'item_price': itemPrice,
    'item_images': itemImages,
    'processing_time_hours': processingTimeHours,
    'is_reusable': isReusable,
    'max_uses': maxUses,
  };
}

class PaymentRequestResponseEntity {
  final String id;
  final String sellerId;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String deliveryType;
  final String? pickupAddress;
  final String? dropoffAddress;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final double? estimatedDeliveryFee;
  final double? buyerServiceFee;
  final double? estimatedTotal;
  final String? paymentCode;
  final String status;
  final bool isReusable;
  final int currentUses;
  final String? deliveryJobId;
  final DateTime createdAt;

  const PaymentRequestResponseEntity({
    required this.id,
    required this.sellerId,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.deliveryType,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.estimatedDeliveryFee,
    this.buyerServiceFee,
    this.estimatedTotal,
    this.paymentCode,
    required this.status,
    required this.isReusable,
    required this.currentUses,
    this.deliveryJobId,
    required this.createdAt,
  });
}

class PaymentRequestListEntity {
  final int count;
  final List<PaymentRequestResponseEntity> paymentRequests;

  const PaymentRequestListEntity({
    required this.count,
    required this.paymentRequests,
  });
}

class MarkReadyForPickupResponseEntity {
  final String deliveryJobId;
  final PaymentRequestResponseEntity paymentRequest;

  const MarkReadyForPickupResponseEntity({
    required this.deliveryJobId,
    required this.paymentRequest,
  });
}
