import '../../../location/domain/entities/fulfillment_entity.dart';

class CreateFulfillmentModel {
  final String deliveryType;
  final String pickupAddress;
  final double pickupLat;
  final double pickupLng;
  final String dropoffAddress;
  final double dropoffLat;
  final double dropoffLng;
  final String vehicleType;

  const CreateFulfillmentModel({
    required this.deliveryType,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffAddress,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.vehicleType,
  });

  factory CreateFulfillmentModel.fromEntity(CreateFulfillmentEntity entity) {
    return CreateFulfillmentModel(
      deliveryType: entity.deliveryType,
      pickupAddress: entity.pickupAddress,
      pickupLat: entity.pickupLat,
      pickupLng: entity.pickupLng,
      dropoffAddress: entity.dropoffAddress,
      dropoffLat: entity.dropoffLat,
      dropoffLng: entity.dropoffLng,
      vehicleType: entity.vehicleType,
    );
  }

  Map<String, dynamic> toJson() => {
    'delivery_type': deliveryType,
    'pickup_address': pickupAddress,
    'pickup_lat': pickupLat,
    'pickup_lng': pickupLng,
    'dropoff_address': dropoffAddress,
    'dropoff_lat': dropoffLat,
    'dropoff_lng': dropoffLng,
    'vehicle_type': vehicleType,
  };
}

class FulfillmentResponseModel {
  final PaymentRequestData paymentRequest;
  final String paymentUrl;

  const FulfillmentResponseModel({
    required this.paymentRequest,
    required this.paymentUrl,
  });

  factory FulfillmentResponseModel.fromJson(Map<String, dynamic> json) {
    return FulfillmentResponseModel(
      paymentRequest: PaymentRequestData.fromJson(
        json['payment_request'] as Map<String, dynamic>,
      ),
      paymentUrl: json['payment_url'] ?? '',
    );
  }

  FulfillmentResponseEntity toEntity() {
    return FulfillmentResponseEntity(
      paymentRequestId: paymentRequest.id,
      sellerId: paymentRequest.sellerId,
      itemName: paymentRequest.itemName,
      itemDescription: paymentRequest.itemDescription,
      itemPrice: paymentRequest.itemPrice,
      deliveryType: paymentRequest.deliveryType,
      pickupAddress: paymentRequest.pickupAddress,
      dropoffAddress: paymentRequest.dropoffAddress,
      estimatedDeliveryFee: paymentRequest.estimatedDeliveryFee,
      buyerServiceFee: paymentRequest.buyerServiceFee,
      estimatedTotal: paymentRequest.estimatedTotal,
      paymentCode: paymentRequest.paymentCode,
      status: paymentRequest.status,
      createdAt: paymentRequest.createdAt,
      paymentUrl: paymentUrl,
    );
  }
}

class PaymentRequestData {
  final String id;
  final String sellerId;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String deliveryType;
  final String pickupAddress;
  final String dropoffAddress;
  final double estimatedDeliveryFee;
  final double buyerServiceFee;
  final double estimatedTotal;
  final String paymentCode;
  final String status;
  final DateTime createdAt;

  const PaymentRequestData({
    required this.id,
    required this.sellerId,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.deliveryType,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.estimatedDeliveryFee,
    required this.buyerServiceFee,
    required this.estimatedTotal,
    required this.paymentCode,
    required this.status,
    required this.createdAt,
  });

  factory PaymentRequestData.fromJson(Map<String, dynamic> json) {
    return PaymentRequestData(
      id: json['id'] ?? '',
      sellerId: json['seller_id'] ?? '',
      itemName: json['item_name'] ?? '',
      itemDescription: json['item_description'] ?? '',
      itemPrice: (json['item_price'] ?? 0).toDouble(),
      deliveryType: json['delivery_type'] ?? '',
      pickupAddress: json['pickup_address'] ?? '',
      dropoffAddress: json['dropoff_address'] ?? '',
      estimatedDeliveryFee: (json['estimated_delivery_fee'] ?? 0).toDouble(),
      buyerServiceFee: (json['buyer_service_fee'] ?? 0).toDouble(),
      estimatedTotal: (json['estimated_total'] ?? 0).toDouble(),
      paymentCode: json['payment_code'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
