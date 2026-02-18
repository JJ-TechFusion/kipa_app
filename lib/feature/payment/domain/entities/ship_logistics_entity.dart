class ShipLogisticsEntity {
  final String carrier;
  final String? carrierOtherName;
  final String trackingNumber;
  final String trackingUrl;
  final String shipmentReceiptUrl;
  final DateTime estimatedDeliveryAt;

  const ShipLogisticsEntity({
    required this.carrier,
    this.carrierOtherName,
    required this.trackingNumber,
    required this.trackingUrl,
    required this.shipmentReceiptUrl,
    required this.estimatedDeliveryAt,
  });

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

class ShipLogisticsResponseEntity {
  final String message;

  const ShipLogisticsResponseEntity({
    required this.message,
  });
}
