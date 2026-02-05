/// Entity representing a delivery job
class DeliveryJobEntity {
  final String id;
  final String paymentRequestId;
  final String status;
  final RiderEntity? rider;
  final String pickupAddress;
  final String dropoffAddress;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final DateTime? estimatedArrival;
  final DateTime createdAt;

  const DeliveryJobEntity({
    required this.id,
    required this.paymentRequestId,
    required this.status,
    this.rider,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.estimatedArrival,
    required this.createdAt,
  });

  DeliveryJobEntity copyWith({
    String? id,
    String? paymentRequestId,
    String? status,
    RiderEntity? rider,
    String? pickupAddress,
    String? dropoffAddress,
    double? pickupLat,
    double? pickupLng,
    double? dropoffLat,
    double? dropoffLng,
    DateTime? estimatedArrival,
    DateTime? createdAt,
  }) {
    return DeliveryJobEntity(
      id: id ?? this.id,
      paymentRequestId: paymentRequestId ?? this.paymentRequestId,
      status: status ?? this.status,
      rider: rider ?? this.rider,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      dropoffLat: dropoffLat ?? this.dropoffLat,
      dropoffLng: dropoffLng ?? this.dropoffLng,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Entity representing a rider
class RiderEntity {
  final String id;
  final String name;
  final String phone;
  final String? photoUrl;
  final String vehicleType;
  final String? vehiclePlate;
  final double rating;

  const RiderEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.photoUrl,
    required this.vehicleType,
    this.vehiclePlate,
    required this.rating,
  });
}

/// Entity representing rider's live location
class RiderLocationEntity {
  final double latitude;
  final double longitude;
  final double? heading;
  final double? speed;
  final DateTime timestamp;
  final int? etaMinutes;
  final double? distanceRemainingKm;

  const RiderLocationEntity({
    required this.latitude,
    required this.longitude,
    this.heading,
    this.speed,
    required this.timestamp,
    this.etaMinutes,
    this.distanceRemainingKm,
  });
}

/// Entity representing a chat message
class ChatMessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final bool isFromRider;
  final DateTime timestamp;

  const ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isFromRider,
    required this.timestamp,
  });
}

/// Entity representing a nearby available rider
class NearbyRiderEntity {
  final String riderId;
  final double latitude;
  final double longitude;
  final double? heading;
  final double? speed;
  final double distanceKm;

  const NearbyRiderEntity({
    required this.riderId,
    required this.latitude,
    required this.longitude,
    this.heading,
    this.speed,
    required this.distanceKm,
  });
}
