import '../../domain/entities/delivery_entities.dart';

class DeliveryJobModel {
  static DeliveryJobEntity fromJson(Map<String, dynamic> json) {
    return DeliveryJobEntity(
      id: json['id'] ?? json['delivery_job_id'] ?? '',
      paymentRequestId: json['payment_request_id'] ?? '',
      status: json['status'] ?? 'created',
      rider: json['rider'] != null ? RiderModel.fromJson(json['rider']) : null,
      pickupAddress: json['pickup_address'] ?? '',
      dropoffAddress: json['dropoff_address'] ?? '',
      pickupLat: _parseDouble(json['pickup_lat']),
      pickupLng: _parseDouble(json['pickup_lng']),
      dropoffLat: _parseDouble(json['dropoff_lat']),
      dropoffLng: _parseDouble(json['dropoff_lng']),
      estimatedArrival: json['estimated_arrival'] != null
          ? DateTime.tryParse(json['estimated_arrival'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class RiderModel {
  static RiderEntity fromJson(Map<String, dynamic> json) {
    // Handle both first_name+last_name and name formats
    String name = json['name']?.toString() ?? json['full_name']?.toString() ?? '';
    if (name.isEmpty && (json['first_name'] != null || json['last_name'] != null)) {
      final firstName = json['first_name']?.toString() ?? '';
      final lastName = json['last_name']?.toString() ?? '';
      name = '$firstName $lastName'.trim();
    }
    if (name.isEmpty) name = 'Rider';

    return RiderEntity(
      id: json['id'] ?? json['rider_id'] ?? '',
      name: name,
      phone: json['phone'] ?? json['phone_number'] ?? '',
      photoUrl: json['photo_url'] ?? json['profile_photo_url'] ?? json['profile_picture'],
      vehicleType: json['vehicle_type'] ?? 'motorcycle',
      vehiclePlate: json['vehicle_plate'] ?? json['license_plate'],
      rating: _parseRating(json['rating']),
    );
  }

  static double _parseRating(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class RiderLocationModel {
  static RiderLocationEntity fromJson(Map<String, dynamic> json) {
    return RiderLocationEntity(
      latitude: _parseDouble(json['latitude'] ?? json['lat']) ?? 0.0,
      longitude: _parseDouble(json['longitude'] ?? json['lng']) ?? 0.0,
      heading: _parseDouble(json['heading']),
      speed: _parseDouble(json['speed']),
      timestamp: _parseTimestamp(json['ts'] ?? json['timestamp']),
      etaMinutes: json['eta_minutes'] as int?,
      distanceRemainingKm: _parseDouble(json['distance_remaining_km']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();

    // Handle unix timestamp (seconds)
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }

    // Handle ISO date string
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}

class ChatMessageModel {
  static ChatMessageEntity fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
      id:
          json['id'] ??
          json['message_id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: json['sender_id'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      message: json['message'] ?? json['content'] ?? '',
      isFromRider: json['is_from_rider'] ?? json['sender_type'] == 'rider',
      timestamp:
          DateTime.tryParse(json['timestamp'] ?? json['created_at'] ?? '') ??
          DateTime.now(),
    );
  }
}

class NearbyRiderModel {
  static NearbyRiderEntity fromJson(Map<String, dynamic> json) {
    return NearbyRiderEntity(
      riderId: json['rider_id'] ?? '',
      latitude: RiderLocationModel._parseDouble(json['lat']) ?? 0.0,
      longitude: RiderLocationModel._parseDouble(json['lng']) ?? 0.0,
      heading: RiderLocationModel._parseDouble(json['heading']),
      speed: RiderLocationModel._parseDouble(json['speed']),
      distanceKm: RiderLocationModel._parseDouble(json['distance_km']) ?? 0.0,
    );
  }

  static List<NearbyRiderEntity> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
