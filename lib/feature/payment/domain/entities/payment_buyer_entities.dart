class InitializePaymentEntity {
  final String paymentMethod;

  InitializePaymentEntity({required this.paymentMethod});
}

class InitializePaymentResponseEntity {
  final String accessCode;
  final String authorizationUrl;
  final String orderId;
  final String paymentRequestId;
  final String paymentMethod;
  final String reference;
  // For wallet payment
  final String? escrowId;
  final String? message;
  final String? status;
  // Delivery info
  final String? deliveryType;
  final String? pickupAddress;
  final String? dropoffAddress;
  final String? logisticsDeliveryId;
  final String? deliveryJobId;

  InitializePaymentResponseEntity({
    this.accessCode = '',
    this.authorizationUrl = '',
    required this.orderId,
    required this.paymentRequestId,
    required this.paymentMethod,
    this.reference = '',
    this.escrowId,
    this.message,
    this.status,
    this.deliveryType,
    this.pickupAddress,
    this.dropoffAddress,
    this.logisticsDeliveryId,
    this.deliveryJobId,
  });

  bool get isWalletPayment => paymentMethod == 'wallet';
  bool get isInterState => deliveryType == 'inter_state';
  bool get isIntraState => deliveryType == 'intra_state';
}

class VerifyPaymentResponseEntity {
  final String escrowId;
  final String message;
  final String orderId;
  final String paymentRequestId;
  final String paymentStatus;
  final String status;
  // Delivery info
  final String? deliveryType;
  final String? pickupAddress;
  final String? dropoffAddress;
  final String? logisticsDeliveryId;
  final String? deliveryJobId;

  VerifyPaymentResponseEntity({
    required this.escrowId,
    required this.message,
    required this.orderId,
    required this.paymentRequestId,
    required this.paymentStatus,
    required this.status,
    this.deliveryType,
    this.pickupAddress,
    this.dropoffAddress,
    this.logisticsDeliveryId,
    this.deliveryJobId,
  });

  bool get isInterState => deliveryType == 'inter_state';
  bool get isIntraState => deliveryType == 'intra_state';
}

class PaymentDetailsEntity {
  final String id;
  final String paymentCode;
  final String status;
  final double totalAmount;
  final String currency;
  final String? description;
  final DateTime createdAt;
  final SellerInfoEntity? seller;
  final List<PaymentItemEntity> items;
  final FulfillmentInfoEntity? fulfillment;
  final int? processingTimeHours;

  PaymentDetailsEntity({
    required this.id,
    required this.paymentCode,
    required this.status,
    required this.totalAmount,
    this.currency = 'NGN',
    this.description,
    required this.createdAt,
    this.seller,
    this.items = const [],
    this.fulfillment,
    this.processingTimeHours,
  });
}

class SellerInfoEntity {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? profilePicture;

  SellerInfoEntity({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.profilePicture,
  });
}

class PaymentItemEntity {
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  PaymentItemEntity({
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
  });
}

class FulfillmentInfoEntity {
  final String type;
  final String? pickupAddress;
  final String? deliveryAddress;
  final DateTime? estimatedDelivery;
  final double? estimatedDeliveryFee;

  FulfillmentInfoEntity({
    required this.type,
    this.pickupAddress,
    this.deliveryAddress,
    this.estimatedDelivery,
    this.estimatedDeliveryFee,
  });
}
