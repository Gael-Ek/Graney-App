// infrastructure/core/utils/coordinate_converter.dart
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoordinateConverter {
  static double calculateDistance(LatLng point1, LatLng point2) {
    const earthRadius = 6371.0; // km

    final lat1Rad = point1.latitude * pi / 180;
    final lat2Rad = point2.latitude * pi / 180;
    final deltaLat = (point2.latitude - point1.latitude) * pi / 180;
    final deltaLon = (point2.longitude - point1.longitude) * pi / 180;

    final a =
        sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static LatLng getMidpoint(LatLng point1, LatLng point2) {
    return LatLng(
      (point1.latitude + point2.latitude) / 2,
      (point1.longitude + point2.longitude) / 2,
    );
  }

  static LatLngBounds getBounds(LatLng center, double radiusKm) {
    const earthRadius = 6371.0;
    final latDelta = (radiusKm / earthRadius) * (180 / pi);
    final lonDelta =
        (radiusKm / (earthRadius * cos(center.latitude * pi / 180))) *
        (180 / pi);

    return LatLngBounds(
      southwest: LatLng(
        center.latitude - latDelta,
        center.longitude - lonDelta,
      ),
      northeast: LatLng(
        center.latitude + latDelta,
        center.longitude + lonDelta,
      ),
    );
  }

  static String formatCoordinates(LatLng location) {
    return '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
  }
}
