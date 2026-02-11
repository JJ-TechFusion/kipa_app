import '../../domain/entities/ready_for_return_response_entity.dart';

class ReadyForReturnResponseModel {
  final double deliveryFee;
  final String pickupAddress;
  final String dropoffAddress;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String returnJobId;
  final String status;

  const ReadyForReturnResponseModel({
    required this.deliveryFee,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.returnJobId,
    required this.status,
  });

  factory ReadyForReturnResponseModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ReadyForReturnResponseModel(
      deliveryFee: parseDouble(json['delivery_fee']),
      pickupAddress: json['pickup_address']?.toString() ?? '',
      dropoffAddress: json['dropoff_address']?.toString() ?? '',
      pickupLat: parseDouble(json['pickup_lat']),
      pickupLng: parseDouble(json['pickup_lng']),
      dropoffLat: parseDouble(json['dropoff_lat']),
      dropoffLng: parseDouble(json['dropoff_lng']),
      returnJobId: json['return_job_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  ReadyForReturnResponseEntity toEntity() {
    return ReadyForReturnResponseEntity(
      deliveryFee: deliveryFee,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
      returnJobId: returnJobId,
      status: status,
    );
  }
}
