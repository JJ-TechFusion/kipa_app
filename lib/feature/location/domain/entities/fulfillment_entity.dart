import 'location_entity.dart';

class CreateFulfillmentEntity {
  final String deliveryType;
  final String pickupAddress;
  final double pickupLat;
  final double pickupLng;
  final String dropoffAddress;
  final double dropoffLat;
  final double dropoffLng;
  final String vehicleType;

  const CreateFulfillmentEntity({
    required this.deliveryType,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffAddress,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.vehicleType,
  });

  factory CreateFulfillmentEntity.fromLocations({
    required String deliveryType,
    required LocationEntity pickup,
    required LocationEntity dropoff,
    required String vehicleType,
  }) {
    return CreateFulfillmentEntity(
      deliveryType: deliveryType,
      pickupAddress: pickup.address,
      pickupLat: pickup.latitude,
      pickupLng: pickup.longitude,
      dropoffAddress: dropoff.address,
      dropoffLat: dropoff.latitude,
      dropoffLng: dropoff.longitude,
      vehicleType: vehicleType,
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

class FulfillmentResponseEntity {
  final String paymentRequestId;
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
  final String paymentUrl;

  const FulfillmentResponseEntity({
    required this.paymentRequestId,
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
    required this.paymentUrl,
  });
}
