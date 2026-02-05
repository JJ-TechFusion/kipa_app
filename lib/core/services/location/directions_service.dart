import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteInfo {
  final List<LatLng> points;
  final int durationSeconds;
  final int distanceMeters;

  RouteInfo({
    required this.points,
    required this.durationSeconds,
    required this.distanceMeters,
  });

  DateTime get estimatedArrival =>
      DateTime.now().add(Duration(seconds: durationSeconds));
}

class DirectionsService {
  final String apiKey;
  final Dio _dio = Dio();

  DirectionsService({required this.apiKey});

  /// Get route between two points using Google Directions API
  Future<List<LatLng>?> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final routeInfo = await getRouteInfo(
      origin: origin,
      destination: destination,
    );
    return routeInfo?.points;
  }

  /// Get detailed route info including duration and distance
  Future<RouteInfo?> getRouteInfo({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/directions/json';
      final params = {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': apiKey,
        'mode': 'driving',
      };

      final response = await _dio.get(url, queryParameters: params);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final polyline = route['overview_polyline']['points'] as String;
          final leg = route['legs'][0];

          // Extract duration and distance
          final durationSeconds = leg['duration']['value'] as int? ?? 0;
          final distanceMeters = leg['distance']['value'] as int? ?? 0;

          // Decode the polyline
          final points = _decodePolyline(polyline);

          return RouteInfo(
            points: points,
            durationSeconds: durationSeconds,
            distanceMeters: distanceMeters,
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Decode Google's encoded polyline format
  /// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}
