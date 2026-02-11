class ReadyForReturnResponseEntity {
  final double deliveryFee;
  final String pickupAddress;
  final String dropoffAddress;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String returnJobId;
  final String status;

  const ReadyForReturnResponseEntity({
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
}
