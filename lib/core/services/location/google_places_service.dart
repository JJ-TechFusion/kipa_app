import 'package:dio/dio.dart';
import 'package:kipa/feature/location/domain/entities/location_entity.dart';
import 'package:kipa/utils/constant.dart';

class GooglePlacesService {
  final String apiKey;
  final Dio _dio;

  static const String _placesBaseUrl =
      'https://maps.googleapis.com/maps/api/place';

  GooglePlacesService({required this.apiKey, Dio? dio}) : _dio = dio ?? Dio();

  Future<List<PlacePrediction>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await _dio.get(
        '$_placesBaseUrl/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': apiKey,
          'components': 'country:ng',
        },
      );

      if (response.data['status'] == 'OK') {
        final predictions = response.data['predictions'] as List;
        return predictions.map((p) => PlacePrediction.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      logMessage('GooglePlacesService', 'Error searching places: $e');
      return [];
    }
  }

  /// Get place details including coordinates from place ID
  Future<LocationEntity?> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        '$_placesBaseUrl/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry,formatted_address',
          'key': apiKey,
        },
      );

      if (response.data['status'] == 'OK') {
        final result = response.data['result'];
        final location = result['geometry']['location'];

        return LocationEntity(
          latitude: location['lat'].toDouble(),
          longitude: location['lng'].toDouble(),
          address: result['formatted_address'] ?? '',
          placeId: placeId,
        );
      }
      return null;
    } catch (e) {
      logMessage('GooglePlacesService', 'Error getting place details: $e');
      return null;
    }
  }

  /// Geocode an address string to get coordinates
  Future<LocationEntity?> geocodeAddress(String address) async {
    if (address.isEmpty) return null;

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {'address': address, 'key': apiKey, 'region': 'ng'},
      );

      if (response.data['status'] == 'OK') {
        final results = response.data['results'] as List;
        if (results.isNotEmpty) {
          final location = results[0]['geometry']['location'];
          return LocationEntity(
            latitude: location['lat'].toDouble(),
            longitude: location['lng'].toDouble(),
            address: results[0]['formatted_address'] ?? address,
          );
        }
      }
      return null;
    } catch (e) {
      logMessage('GooglePlacesService', 'Error geocoding address: $e');
      return null;
    }
  }
}

class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  const PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredFormatting = json['structured_formatting'] ?? {};
    return PlacePrediction(
      placeId: json['place_id'] ?? '',
      description: json['description'] ?? '',
      mainText: structuredFormatting['main_text'] ?? '',
      secondaryText: structuredFormatting['secondary_text'] ?? '',
    );
  }
}
