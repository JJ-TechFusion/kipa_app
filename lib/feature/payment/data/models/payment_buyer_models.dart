import '../../domain/entities/payment_buyer_entities.dart';

class InitializePaymentModel extends InitializePaymentEntity {
  InitializePaymentModel({required super.paymentMethod});

  Map<String, dynamic> toJson() {
    return {'payment_method': paymentMethod};
  }
}

class InitializePaymentResponseModel extends InitializePaymentResponseEntity {
  InitializePaymentResponseModel({
    super.accessCode,
    super.authorizationUrl,
    required super.orderId,
    required super.paymentRequestId,
    required super.paymentMethod,
    super.reference,
    super.escrowId,
    super.message,
    super.status,
    super.deliveryType,
    super.pickupAddress,
    super.dropoffAddress,
    super.logisticsDeliveryId,
    super.deliveryJobId,
  });

  factory InitializePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return InitializePaymentResponseModel(
      accessCode: json['access_code'] ?? '',
      authorizationUrl: json['authorization_url'] ?? '',
      orderId: json['order_id'] ?? '',
      paymentRequestId: json['payment_request_id'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      reference: json['reference'] ?? '',
      escrowId: json['escrow_id'],
      message: json['message'],
      status: json['status'],
      deliveryType: json['delivery_type'],
      pickupAddress: json['pickup_address'],
      dropoffAddress: json['dropoff_address'],
      logisticsDeliveryId: json['logistics_delivery_id'],
      deliveryJobId: json['delivery_job_id'],
    );
  }
}

class VerifyPaymentResponseModel extends VerifyPaymentResponseEntity {
  VerifyPaymentResponseModel({
    required super.escrowId,
    required super.message,
    required super.orderId,
    required super.paymentRequestId,
    required super.paymentStatus,
    required super.status,
    super.deliveryType,
    super.pickupAddress,
    super.dropoffAddress,
    super.logisticsDeliveryId,
    super.deliveryJobId,
  });

  factory VerifyPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponseModel(
      escrowId: json['escrow_id'] ?? '',
      message: json['message'] ?? '',
      orderId: json['order_id'] ?? '',
      paymentRequestId: json['payment_request_id'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      status: json['status'] ?? '',
      deliveryType: json['delivery_type'],
      pickupAddress: json['pickup_address'],
      dropoffAddress: json['dropoff_address'],
      logisticsDeliveryId: json['logistics_delivery_id'],
      deliveryJobId: json['delivery_job_id'],
    );
  }
}

class PaymentDetailsModel extends PaymentDetailsEntity {
  PaymentDetailsModel({
    required super.id,
    required super.paymentCode,
    required super.status,
    required super.totalAmount,
    super.currency,
    super.description,
    required super.createdAt,
    super.seller,
    super.items,
    super.fulfillment,
    super.processingTimeHours,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    // Extract seller info from flat response
    final seller = SellerInfoModel(
      id: json['seller_id'] ?? '',
      name: json['seller_name'] ?? '',
      email: json['seller_email'],
      phone: json['seller_phone'],
    );

    // Build item from flat response
    final items = <PaymentItemModel>[];
    if (json['item_name'] != null) {
      items.add(
        PaymentItemModel(
          name: json['item_name'] ?? '',
          price: (json['item_price'] ?? 0).toDouble(),
        ),
      );
    }

    // Build fulfillment info from flat response
    FulfillmentInfoModel? fulfillment;
    if (json['delivery_type'] != null) {
      fulfillment = FulfillmentInfoModel(
        type: json['delivery_type'] ?? '',
        estimatedDeliveryFee: (json['estimated_delivery_fee'] ?? 0).toDouble(),
      );
    }

    // Calculate actual total buyer pays in app (item price + service fee, NO delivery fee)
    final itemPrice = (json['item_price'] ?? 0).toDouble();
    final serviceFee = (json['buyer_service_fee'] ?? 0).toDouble();
    final totalToPay = itemPrice + serviceFee;

    return PaymentDetailsModel(
      id: json['id'] ?? '',
      paymentCode: json['payment_code'] ?? '',
      status: json['status'] ?? 'pending',
      totalAmount: totalToPay,
      currency: json['currency'] ?? 'NGN',
      description: json['item_description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      seller: seller,
      items: items,
      fulfillment: fulfillment,
      processingTimeHours: json['processing_time_hours'] as int?,
    );
  }
}

class SellerInfoModel extends SellerInfoEntity {
  SellerInfoModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    super.profilePicture,
  });

  factory SellerInfoModel.fromJson(Map<String, dynamic> json) {
    return SellerInfoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? json['full_name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? json['phone_number'],
      profilePicture: json['profile_picture'] ?? json['avatar'],
    );
  }
}

class PaymentItemModel extends PaymentItemEntity {
  PaymentItemModel({
    required super.name,
    required super.price,
    super.quantity,
    super.imageUrl,
  });

  factory PaymentItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentItemModel(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      imageUrl: json['image_url'] ?? json['image'],
    );
  }
}

class FulfillmentInfoModel extends FulfillmentInfoEntity {
  FulfillmentInfoModel({
    required super.type,
    super.pickupAddress,
    super.deliveryAddress,
    super.estimatedDelivery,
    super.estimatedDeliveryFee,
  });

  factory FulfillmentInfoModel.fromJson(Map<String, dynamic> json) {
    return FulfillmentInfoModel(
      type:
          json['type'] ??
          json['fulfillment_type'] ??
          json['delivery_type'] ??
          '',
      pickupAddress: json['pickup_address'],
      deliveryAddress: json['delivery_address'],
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'])
          : null,
      estimatedDeliveryFee: (json['estimated_delivery_fee'] ?? 0).toDouble(),
    );
  }
}
