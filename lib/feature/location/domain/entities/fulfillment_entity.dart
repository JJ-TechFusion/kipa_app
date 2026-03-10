import 'location_entity.dart';

class CreateFulfillmentEntity {
  final String deliveryType;
  final String? pickupAddress;
  final double? pickupLat;
  final double? pickupLng;
  final String? pickupState;
  final String? dropoffAddress;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? dropoffState;
  final String vehicleType;

  const CreateFulfillmentEntity({
    required this.deliveryType,
    this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    this.pickupState,
    this.dropoffAddress,
    this.dropoffLat,
    this.dropoffLng,
    this.dropoffState,
    required this.vehicleType,
  });

  factory CreateFulfillmentEntity.fromLocations({
    required String deliveryType,
    required LocationEntity pickup,
    required LocationEntity dropoff,
    required String vehicleType,
    String? pickupState,
    String? dropoffState,
  }) {
    return CreateFulfillmentEntity(
      deliveryType: deliveryType,
      pickupAddress: pickup.address,
      pickupLat: pickup.latitude,
      pickupLng: pickup.longitude,
      pickupState: pickupState,
      dropoffAddress: dropoff.address,
      dropoffLat: dropoff.latitude,
      dropoffLng: dropoff.longitude,
      dropoffState: dropoffState,
      vehicleType: vehicleType,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'delivery_type': deliveryType,
      'vehicle_type': vehicleType,
    };
    if (pickupAddress != null) map['pickup_address'] = pickupAddress;
    if (pickupLat != null) map['pickup_lat'] = pickupLat;
    if (pickupLng != null) map['pickup_lng'] = pickupLng;
    if (dropoffAddress != null) map['dropoff_address'] = dropoffAddress;
    if (dropoffLat != null) map['dropoff_lat'] = dropoffLat;
    if (dropoffLng != null) map['dropoff_lng'] = dropoffLng;
    if (pickupState != null) map['pickup_state'] = pickupState;
    if (dropoffState != null) map['dropoff_state'] = dropoffState;
    return map;
  }
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
