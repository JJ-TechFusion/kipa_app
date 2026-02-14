import '../../../delivery/data/models/delivery_models.dart';
import '../../domain/entities/errand_entity.dart';
import '../../domain/enums/errand_status.dart';

class ErrandModel {
  static ErrandEntity fromJson(Map<String, dynamic> json) {
    final id =
        json['id']?.toString() ??
        json['errand_id']?.toString() ??
        json['_id']?.toString() ??
        json['errandId']?.toString() ??
        '';

    ErrandDeliveryJobEntity? deliveryJob;
    if (json['delivery_job'] != null) {
      deliveryJob = ErrandDeliveryJobModel.fromJson(json['delivery_job']);
    } else if (json['delivery_job_id'] != null || json['job_id'] != null) {
      deliveryJob = ErrandDeliveryJobEntity(
        id:
            json['delivery_job_id']?.toString() ??
            json['job_id']?.toString() ??
            '',
        rider: json['rider'] != null
            ? RiderModel.fromJson(json['rider'])
            : null,
        pickupCode: json['pickup_code'],
        dropoffCode: json['dropoff_code'],
        currentLatitude: _parseDouble(json['current_lat']),
        currentLongitude: _parseDouble(json['current_lng']),
      );
    }

    // Parse timeline if present
    ErrandTimelineEntity? timeline;
    if (json['timeline'] != null) {
      timeline = ErrandTimelineModel.fromJson(json['timeline']);
    }

    return ErrandEntity(
      id: id,
      status: ErrandStatus.fromString(json['status'] ?? 'draft'),
      pickupAddress: json['pickup_address'] ?? '',
      pickupLatitude: _parseDouble(json['pickup_lat']),
      pickupLongitude: _parseDouble(json['pickup_lng']),
      pickupContactName: json['pickup_contact_name'] ?? '',
      pickupContactPhone: json['pickup_contact_phone'] ?? '',
      dropoffAddress: json['dropoff_address'] ?? '',
      dropoffLatitude: _parseDouble(json['dropoff_lat']),
      dropoffLongitude: _parseDouble(json['dropoff_lng']),
      dropoffContactName: json['dropoff_contact_name'] ?? '',
      dropoffContactPhone: json['dropoff_contact_phone'] ?? '',
      packageDescription: json['package_description'] ?? '',
      packageSize: PackageSize.fromString(
        json['package_size'] ?? json['vehicle_type'] ?? 'small',
      ),
      notes: json['notes'],
      estimatedPrice: _parseDouble(
        json['delivery_fee'] ?? json['estimated_price'],
      ),
      estimatedDistanceKm: _parseDouble(
        json['distance_km'] ?? json['estimated_distance_km'],
      ),
      estimatedDurationMins: json['estimated_duration_mins'] as int?,
      deliveryJob: deliveryJob,
      dropoffCode: json['dropoff_code'],
      timeline: timeline,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  static List<ErrandEntity> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class ErrandDeliveryJobModel {
  static ErrandDeliveryJobEntity fromJson(Map<String, dynamic> json) {
    return ErrandDeliveryJobEntity(
      id: json['id'] ?? '',
      rider: json['rider'] != null ? RiderModel.fromJson(json['rider']) : null,
      pickupCode: json['pickup_code'],
      dropoffCode: json['dropoff_code'],
      currentLatitude: _parseDouble(
        json['current_lat'] ?? json['current_latitude'],
      ),
      currentLongitude: _parseDouble(
        json['current_lng'] ?? json['current_longitude'],
      ),
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

class CancellationResultModel {
  static CancellationResult fromJson(Map<String, dynamic> json) {
    return CancellationResult(
      message: json['message'] ?? 'Errand cancelled successfully',
      cancellationFee: _parseDouble(json['cancellation_fee']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}

class ErrandTimelineModel {
  static ErrandTimelineEntity fromJson(Map<String, dynamic> json) {
    final stepsList = json['steps'] as List<dynamic>? ?? [];
    final steps = stepsList
        .map((s) => ErrandTimelineStepModel.fromJson(s as Map<String, dynamic>))
        .toList();

    return ErrandTimelineEntity(
      steps: steps,
      currentStep: json['current_step'],
    );
  }
}

class ErrandTimelineStepModel {
  static ErrandTimelineStepEntity fromJson(Map<String, dynamic> json) {
    return ErrandTimelineStepEntity(
      step: json['step'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'pending',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }
}
