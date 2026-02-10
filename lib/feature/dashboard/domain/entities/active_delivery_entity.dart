class CounterpartyEntity {
  final String role;
  final String name;
  final String phoneNumber;
  final String? imageUrl;

  const CounterpartyEntity({
    required this.role,
    required this.name,
    required this.phoneNumber,
    this.imageUrl,
  });
}

class ActiveDeliveryEntity {
  final String paymentRequestId;
  final String deliveryJobId;
  final String viewerRole;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String deliveryStatus;
  final String riderStatusText;
  final bool riderAssigned;
  final CounterpartyEntity counterparty;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;

  const ActiveDeliveryEntity({
    required this.paymentRequestId,
    required this.deliveryJobId,
    required this.viewerRole,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.deliveryStatus,
    required this.riderStatusText,
    required this.riderAssigned,
    required this.counterparty,
    required this.createdAt,
    this.acceptedAt,
    this.pickedUpAt,
  });

  bool get isBuyer => viewerRole == 'buyer';
  bool get isSeller => viewerRole == 'seller';
}

class ActiveDeliveriesResponseEntity {
  final List<ActiveDeliveryEntity> activeDeliveries;
  final int count;

  const ActiveDeliveriesResponseEntity({
    required this.activeDeliveries,
    required this.count,
  });
}
