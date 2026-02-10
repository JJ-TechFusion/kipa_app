import '../../domain/entities/active_delivery_entity.dart';

class CounterpartyModel extends CounterpartyEntity {
  const CounterpartyModel({
    required super.role,
    required super.name,
    required super.phoneNumber,
    super.imageUrl,
  });

  factory CounterpartyModel.fromJson(Map<String, dynamic> json) {
    return CounterpartyModel(
      role: json['role']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
    );
  }

  CounterpartyEntity toEntity() {
    return CounterpartyEntity(
      role: role,
      name: name,
      phoneNumber: phoneNumber,
      imageUrl: imageUrl,
    );
  }
}

class ActiveDeliveryModel extends ActiveDeliveryEntity {
  const ActiveDeliveryModel({
    required super.paymentRequestId,
    required super.deliveryJobId,
    required super.viewerRole,
    required super.itemName,
    required super.itemDescription,
    required super.itemPrice,
    required super.deliveryStatus,
    required super.riderStatusText,
    required super.riderAssigned,
    required super.counterparty,
    required super.createdAt,
    super.acceptedAt,
    super.pickedUpAt,
  });

  factory ActiveDeliveryModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ActiveDeliveryModel(
      paymentRequestId: json['payment_request_id']?.toString() ?? '',
      deliveryJobId: json['delivery_job_id']?.toString() ?? '',
      viewerRole: json['viewer_role']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemDescription: json['item_description']?.toString() ?? '',
      itemPrice: parseDouble(json['item_price']),
      deliveryStatus: json['delivery_status']?.toString() ?? '',
      riderStatusText: json['rider_status_text']?.toString() ?? '',
      riderAssigned: json['rider_assigned'] as bool? ?? false,
      counterparty: CounterpartyModel.fromJson(
        json['counterparty'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      acceptedAt: json['accepted_at'] != null
          ? DateTime.tryParse(json['accepted_at'].toString())
          : null,
      pickedUpAt: json['picked_up_at'] != null
          ? DateTime.tryParse(json['picked_up_at'].toString())
          : null,
    );
  }

  ActiveDeliveryEntity toEntity() {
    return ActiveDeliveryEntity(
      paymentRequestId: paymentRequestId,
      deliveryJobId: deliveryJobId,
      viewerRole: viewerRole,
      itemName: itemName,
      itemDescription: itemDescription,
      itemPrice: itemPrice,
      deliveryStatus: deliveryStatus,
      riderStatusText: riderStatusText,
      riderAssigned: riderAssigned,
      counterparty: counterparty,
      createdAt: createdAt,
      acceptedAt: acceptedAt,
      pickedUpAt: pickedUpAt,
    );
  }
}

class ActiveDeliveriesResponseModel extends ActiveDeliveriesResponseEntity {
  const ActiveDeliveriesResponseModel({
    required super.activeDeliveries,
    required super.count,
  });

  factory ActiveDeliveriesResponseModel.fromJson(Map<String, dynamic> json) {
    final deliveriesList = json['active_deliveries'] as List<dynamic>? ?? [];

    return ActiveDeliveriesResponseModel(
      activeDeliveries: deliveriesList
          .map((e) => ActiveDeliveryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int? ?? 0,
    );
  }

  ActiveDeliveriesResponseEntity toEntity() {
    return ActiveDeliveriesResponseEntity(
      activeDeliveries: activeDeliveries,
      count: count,
    );
  }
}
