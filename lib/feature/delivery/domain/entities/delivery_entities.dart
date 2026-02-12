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
  final double? deliveryFee;
  final String? vehicleType;
  final bool riderAssigned;
  final String? riderId;
  final DateTime? acceptedAt;
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
    this.deliveryFee,
    this.vehicleType,
    this.riderAssigned = false,
    this.riderId,
    this.acceptedAt,
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
    double? deliveryFee,
    String? vehicleType,
    bool? riderAssigned,
    String? riderId,
    DateTime? acceptedAt,
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
      deliveryFee: deliveryFee ?? this.deliveryFee,
      vehicleType: vehicleType ?? this.vehicleType,
      riderAssigned: riderAssigned ?? this.riderAssigned,
      riderId: riderId ?? this.riderId,
      acceptedAt: acceptedAt ?? this.acceptedAt,
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
  final int totalDeliveries;

  const RiderEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.photoUrl,
    required this.vehicleType,
    this.vehiclePlate,
    required this.rating,
    this.totalDeliveries = 0,
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
  final String? mediaUrl;
  final String mediaType; // 'text' or 'image'
  final String status; // 'sent', 'delivered', 'read'
  final bool isFromRider;
  final bool isMe;
  final DateTime timestamp;

  const ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.mediaUrl,
    this.mediaType = 'text',
    this.status = 'sent',
    required this.isFromRider,
    this.isMe = false,
    required this.timestamp,
  });

  bool get isImage => mediaType == 'image' && mediaUrl != null;
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

/// Entity representing a location point in history
class LocationPointEntity {
  final double latitude;
  final double longitude;
  final double? heading;
  final double? speed;
  final DateTime timestamp;

  const LocationPointEntity({
    required this.latitude,
    required this.longitude,
    this.heading,
    this.speed,
    required this.timestamp,
  });
}

/// Entity representing location history for a delivery job
class LocationHistoryEntity {
  final String jobId;
  final int count;
  final List<LocationPointEntity> points;

  const LocationHistoryEntity({
    required this.jobId,
    required this.count,
    required this.points,
  });
}
