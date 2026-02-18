import '../../domain/entities/ship_logistics_entity.dart';

class ShipLogisticsModel {
  final String carrier;
  final String? carrierOtherName;
  final String trackingNumber;
  final String trackingUrl;
  final String shipmentReceiptUrl;
  final DateTime estimatedDeliveryAt;

  const ShipLogisticsModel({
    required this.carrier,
    this.carrierOtherName,
    required this.trackingNumber,
    required this.trackingUrl,
    required this.shipmentReceiptUrl,
    required this.estimatedDeliveryAt,
  });

  factory ShipLogisticsModel.fromEntity(ShipLogisticsEntity entity) {
    return ShipLogisticsModel(
      carrier: entity.carrier,
      carrierOtherName: entity.carrierOtherName,
      trackingNumber: entity.trackingNumber,
      trackingUrl: entity.trackingUrl,
      shipmentReceiptUrl: entity.shipmentReceiptUrl,
      estimatedDeliveryAt: entity.estimatedDeliveryAt,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'carrier': carrier,
      'tracking_number': trackingNumber,
      'tracking_url': trackingUrl,
      'shipment_receipt_url': shipmentReceiptUrl,
      'estimated_delivery_at': estimatedDeliveryAt.toIso8601String(),
    };
    if (carrierOtherName != null) {
      map['carrier_other_name'] = carrierOtherName;
    }
    return map;
  }
}

class ShipLogisticsResponseModel {
  final String message;

  const ShipLogisticsResponseModel({
    required this.message,
  });

  factory ShipLogisticsResponseModel.fromJson(Map<String, dynamic> json) {
    return ShipLogisticsResponseModel(
      message: json['message'] ?? '',
    );
  }

  ShipLogisticsResponseEntity toEntity() {
    return ShipLogisticsResponseEntity(
      message: message,
    );
  }
}
