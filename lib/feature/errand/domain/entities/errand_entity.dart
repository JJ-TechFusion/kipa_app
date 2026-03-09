import '../../../delivery/domain/entities/delivery_entities.dart';
import '../enums/errand_status.dart';

class ErrandEntity {
  final String id;
  final ErrandStatus status;
  final String pickupAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? pickupContactName;
  final String? pickupContactPhone;
  final String dropoffAddress;
  final double? dropoffLatitude;
  final double? dropoffLongitude;
  final String? dropoffContactName;
  final String? dropoffContactPhone;
  final String? packageDescription;
  final PackageSize? packageSize;
  final String? notes;
  final double? estimatedPrice;
  final double? estimatedDistanceKm;
  final int? estimatedDurationMins;
  final ErrandDeliveryJobEntity? deliveryJob;
  final String? dropoffCode;
  final ErrandTimelineEntity? timeline;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ErrandEntity({
    required this.id,
    required this.status,
    required this.pickupAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupContactName,
    this.pickupContactPhone,
    required this.dropoffAddress,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.dropoffContactName,
    this.dropoffContactPhone,
    this.packageDescription,
    this.packageSize,
    this.notes,
    this.estimatedPrice,
    this.estimatedDistanceKm,
    this.estimatedDurationMins,
    this.deliveryJob,
    this.dropoffCode,
    this.timeline,
    required this.createdAt,
    this.updatedAt,
  });

  ErrandEntity copyWith({
    String? id,
    ErrandStatus? status,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? pickupContactName,
    String? pickupContactPhone,
    String? dropoffAddress,
    double? dropoffLatitude,
    double? dropoffLongitude,
    String? dropoffContactName,
    String? dropoffContactPhone,
    String? packageDescription,
    PackageSize? packageSize,
    String? notes,
    double? estimatedPrice,
    double? estimatedDistanceKm,
    int? estimatedDurationMins,
    ErrandDeliveryJobEntity? deliveryJob,
    String? dropoffCode,
    ErrandTimelineEntity? timeline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ErrandEntity(
      id: id ?? this.id,
      status: status ?? this.status,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      pickupContactName: pickupContactName ?? this.pickupContactName,
      pickupContactPhone: pickupContactPhone ?? this.pickupContactPhone,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      dropoffLatitude: dropoffLatitude ?? this.dropoffLatitude,
      dropoffLongitude: dropoffLongitude ?? this.dropoffLongitude,
      dropoffContactName: dropoffContactName ?? this.dropoffContactName,
      dropoffContactPhone: dropoffContactPhone ?? this.dropoffContactPhone,
      packageDescription: packageDescription ?? this.packageDescription,
      packageSize: packageSize ?? this.packageSize,
      notes: notes ?? this.notes,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      estimatedDistanceKm: estimatedDistanceKm ?? this.estimatedDistanceKm,
      estimatedDurationMins:
          estimatedDurationMins ?? this.estimatedDurationMins,
      deliveryJob: deliveryJob ?? this.deliveryJob,
      dropoffCode: dropoffCode ?? this.dropoffCode,
      timeline: timeline ?? this.timeline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ErrandTimelineEntity {
  final List<ErrandTimelineStepEntity> steps;
  final String? currentStep;

  const ErrandTimelineEntity({required this.steps, this.currentStep});
}

class ErrandTimelineStepEntity {
  final String step;
  final String title;
  final String? description;
  final String status;
  final DateTime? timestamp;

  const ErrandTimelineStepEntity({
    required this.step,
    required this.title,
    this.description,
    required this.status,
    this.timestamp,
  });
}

class ErrandDeliveryJobEntity {
  final String id;
  final RiderEntity? rider;
  final String? pickupCode;
  final String? dropoffCode;
  final double? currentLatitude;
  final double? currentLongitude;

  const ErrandDeliveryJobEntity({
    required this.id,
    this.rider,
    this.pickupCode,
    this.dropoffCode,
    this.currentLatitude,
    this.currentLongitude,
  });

  ErrandDeliveryJobEntity copyWith({
    String? id,
    RiderEntity? rider,
    String? pickupCode,
    String? dropoffCode,
    double? currentLatitude,
    double? currentLongitude,
  }) {
    return ErrandDeliveryJobEntity(
      id: id ?? this.id,
      rider: rider ?? this.rider,
      pickupCode: pickupCode ?? this.pickupCode,
      dropoffCode: dropoffCode ?? this.dropoffCode,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
    );
  }
}

enum PackageSize {
  small,
  medium,
  large;

  static PackageSize fromString(String size) {
    switch (size.toLowerCase()) {
      case 'small':
        return PackageSize.small;
      case 'medium':
        return PackageSize.medium;
      case 'large':
        return PackageSize.large;
      default:
        return PackageSize.small;
    }
  }

  String get value {
    switch (this) {
      case PackageSize.small:
        return 'small';
      case PackageSize.medium:
        return 'medium';
      case PackageSize.large:
        return 'large';
    }
  }

  String get displayName {
    switch (this) {
      case PackageSize.small:
        return 'Small';
      case PackageSize.medium:
        return 'Medium';
      case PackageSize.large:
        return 'Large';
    }
  }

  String get description {
    switch (this) {
      case PackageSize.small:
        return 'Documents, small packages';
      case PackageSize.medium:
        return 'Medium boxes, groceries';
      case PackageSize.large:
        return 'Large items, furniture';
    }
  }
}

class CreateErrandParams {
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String? pickupContactName;
  final String? pickupContactPhone;
  final String dropoffAddress;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String? dropoffContactName;
  final String? dropoffContactPhone;
  final String? packageDescription;
  final String vehicleType;
  final String? notes;

  const CreateErrandParams({
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    this.pickupContactName,
    this.pickupContactPhone,
    required this.dropoffAddress,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    this.dropoffContactName,
    this.dropoffContactPhone,
    this.packageDescription,
    required this.vehicleType,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickup_address': pickupAddress,
      'pickup_lat': pickupLatitude,
      'pickup_lng': pickupLongitude,
      if (pickupContactName != null) 'pickup_contact_name': pickupContactName,
      if (pickupContactPhone != null)
        'pickup_contact_phone': pickupContactPhone,
      'dropoff_address': dropoffAddress,
      'dropoff_lat': dropoffLatitude,
      'dropoff_lng': dropoffLongitude,
      if (dropoffContactName != null)
        'dropoff_contact_name': dropoffContactName,
      if (dropoffContactPhone != null)
        'dropoff_contact_phone': dropoffContactPhone,
      if (packageDescription != null) 'package_description': packageDescription,
      'vehicle_type': vehicleType,
      if (notes != null) 'pickup_instructions': notes,
    };
  }
}

class CancellationResult {
  final String message;
  final double cancellationFee;

  const CancellationResult({
    required this.message,
    required this.cancellationFee,
  });
}
