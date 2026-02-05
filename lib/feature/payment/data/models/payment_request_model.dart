import '../../domain/entities/payment_request_entity.dart';

class CreatePaymentRequestModel {
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final List<String> itemImages;
  final int processingTimeHours;
  final bool isReusable;
  final int? maxUses;

  const CreatePaymentRequestModel({
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemImages,
    required this.processingTimeHours,
    required this.isReusable,
    this.maxUses,
  });

  factory CreatePaymentRequestModel.toEntity(
    CreatePaymentRequestEntity entity,
  ) {
    return CreatePaymentRequestModel(
      itemName: entity.itemName,
      itemDescription: entity.itemDescription,
      itemPrice: entity.itemPrice,
      itemImages: entity.itemImages,
      processingTimeHours: entity.processingTimeHours,
      isReusable: entity.isReusable,
      maxUses: entity.maxUses,
    );
  }

  Map<String, dynamic> toJson() => {
    'item_name': itemName,
    'item_description': itemDescription,
    'item_price': itemPrice,
    'item_images': itemImages,
    'processing_time_hours': processingTimeHours,
    'is_reusable': isReusable,
    if (maxUses != null) 'max_uses': maxUses,
  };
}

class PaymentRequestResponseModel {
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

  const PaymentRequestResponseModel({
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

  factory PaymentRequestResponseModel.fromJson(Map<String, dynamic> json) {
    double parsePrice(dynamic price) {
      if (price == null) return 0.0;
      if (price is int) return price.toDouble();
      if (price is double) return price;
      if (price is String) return double.tryParse(price) ?? 0.0;
      return 0.0;
    }

    return PaymentRequestResponseModel(
      id: json['id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemDescription: json['item_description']?.toString() ?? '',
      itemPrice: parsePrice(json['item_price']),
      deliveryType: json['delivery_type']?.toString() ?? '',
      pickupAddress: json['pickup_address']?.toString(),
      dropoffAddress: json['dropoff_address']?.toString(),
      pickupLat: json['pickup_lat'] != null ? parsePrice(json['pickup_lat']) : null,
      pickupLng: json['pickup_lng'] != null ? parsePrice(json['pickup_lng']) : null,
      dropoffLat: json['dropoff_lat'] != null ? parsePrice(json['dropoff_lat']) : null,
      dropoffLng: json['dropoff_lng'] != null ? parsePrice(json['dropoff_lng']) : null,
      estimatedDeliveryFee: parsePrice(json['estimated_delivery_fee']),
      buyerServiceFee: parsePrice(json['buyer_service_fee']),
      estimatedTotal: parsePrice(json['estimated_total']),
      paymentCode: json['payment_code']?.toString(),
      status: json['status']?.toString() ?? '',
      isReusable: json['is_reusable'] as bool? ?? false,
      currentUses: json['current_uses'] as int? ?? 0,
      deliveryJobId: json['delivery_job_id']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  PaymentRequestResponseEntity toEntity() {
    return PaymentRequestResponseEntity(
      id: id,
      sellerId: sellerId,
      itemName: itemName,
      itemDescription: itemDescription,
      itemPrice: itemPrice,
      deliveryType: deliveryType,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
      estimatedDeliveryFee: estimatedDeliveryFee,
      buyerServiceFee: buyerServiceFee,
      estimatedTotal: estimatedTotal,
      paymentCode: paymentCode,
      status: status,
      isReusable: isReusable,
      currentUses: currentUses,
      deliveryJobId: deliveryJobId,
      createdAt: createdAt,
    );
  }
}

class PaymentRequestListModel {
  final int count;
  final List<PaymentRequestResponseModel> paymentRequests;

  const PaymentRequestListModel({
    required this.count,
    required this.paymentRequests,
  });

  factory PaymentRequestListModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestListModel(
      count: json['count'] ?? 0,
      paymentRequests:
          (json['payment_requests'] as List<dynamic>?)
              ?.map(
                (e) => PaymentRequestResponseModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  PaymentRequestListEntity toEntity() {
    return PaymentRequestListEntity(
      count: count,
      paymentRequests: paymentRequests.map((e) => e.toEntity()).toList(),
    );
  }
}

class MarkReadyForPickupResponseModel {
  final String deliveryJobId;
  final PaymentRequestResponseModel paymentRequest;

  const MarkReadyForPickupResponseModel({
    required this.deliveryJobId,
    required this.paymentRequest,
  });

  factory MarkReadyForPickupResponseModel.fromJson(Map<String, dynamic> json) {
    final deliveryJobId =
        json['delivery_job_id']?.toString() ?? json['job_id']?.toString() ?? '';

    final paymentRequestData =
        json['payment_request'] as Map<String, dynamic>? ?? json;

    return MarkReadyForPickupResponseModel(
      deliveryJobId: deliveryJobId,
      paymentRequest: PaymentRequestResponseModel.fromJson(paymentRequestData),
    );
  }

  MarkReadyForPickupResponseEntity toEntity() {
    return MarkReadyForPickupResponseEntity(
      deliveryJobId: deliveryJobId,
      paymentRequest: paymentRequest.toEntity(),
    );
  }
}
