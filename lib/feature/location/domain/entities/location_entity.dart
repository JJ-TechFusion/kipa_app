class LocationEntity {
  final double latitude;
  final double longitude;
  final String address;
  final String? placeId;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.placeId,
  });

  @override
  String toString() =>
      'LocationEntity(lat: $latitude, lng: $longitude, address: $address)';
}
