import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Servicio mejorado según recomendaciones oficiales de NASA GLOBE Observer
/// https://observer.globe.gov/do-globe-observer/do-more/data-requests/wildflower-blooms
class GlobeObserverService {
  static const String globeApiUrl =
      'https://api.globe.gov/search/v1/measurement/protocol';

  /// Obtiene observaciones de floración según las especificaciones de NASA
  static Future<List<FlowerObservation>> getFloweringObservations(
    LatLng location,
    double radiusKm, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Parámetros correctos según documentación NASA GLOBE
      final url = Uri.parse(globeApiUrl).replace(
        queryParameters: {
          'lat': location.latitude.toString(),
          'lon': location.longitude.toString(),
          'radius': (radiusKm * 1000).toString(), // API espera metros
          'protocols': 'land_covers', // Correcto según docs
          'startdate': (startDate ?? DateTime(2020, 1, 1))
              .toIso8601String()
              .split('T')[0],
          'enddate': (endDate ?? DateTime.now()).toIso8601String().split(
            'T',
          )[0],
          'geojson': 'TRUE',
          'sample': 'FALSE', // Obtener todos los datos, no muestra
        },
      );

      debugPrint('🌍 GLOBE Observer URL: $url');

      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return _parseFloweringObservations(response.body);
      } else {
        debugPrint('❌ GLOBE API error: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error GLOBE API: $e');
    }

    return [];
  }

  static List<FlowerObservation> _parseFloweringObservations(
    String responseBody,
  ) {
    try {
      final data = json.decode(responseBody);
      final results = data['results'] as List? ?? [];

      debugPrint('📊 GLOBE resultados totales: ${results.length}');

      final flowerObs = results
          .where((obs) {
            final props = obs['properties'] ?? {};

            // Filtros específicos para flores según NASA GLOBE
            final landCover =
                props['landCoverType']?.toString().toLowerCase() ?? '';
            final description =
                props['description']?.toString().toLowerCase() ?? '';
            final classification =
                props['classification']?.toString().toLowerCase() ?? '';

            // Buscar indicadores de floración
            return landCover.contains('flower') ||
                landCover.contains('bloom') ||
                description.contains('flower') ||
                description.contains('bloom') ||
                description.contains('blossom') ||
                classification.contains('flowering');
          })
          .map((obs) {
            final props = obs['properties'] ?? {};
            final geometry = obs['geometry'] ?? {};
            final coords = geometry['coordinates'] as List? ?? [0.0, 0.0];

            return FlowerObservation(
              id: obs['id']?.toString() ?? '',
              date:
                  DateTime.tryParse(
                    props['measuredDate']?.toString() ??
                        props['measuredAt']?.toString() ??
                        '',
                  ) ??
                  DateTime.now(),
              latitude: coords.length > 1 ? coords[1].toDouble() : 0.0,
              longitude: coords.isNotEmpty ? coords[0].toDouble() : 0.0,
              landCoverType: props['landCoverType']?.toString() ?? 'Unknown',
              classification: props['classification']?.toString(),
              description: props['description']?.toString(),
              observer:
                  props['mosquitohabitatmapperScientistName']?.toString() ??
                  props['observer']?.toString() ??
                  'Anonymous',
              photos: _parsePhotos(props),
              hasFlowers: true,
            );
          })
          .toList();

      debugPrint('🌸 Observaciones de flores encontradas: ${flowerObs.length}');

      return flowerObs;
    } catch (e) {
      debugPrint('❌ Error parseando GLOBE response: $e');
      return [];
    }
  }

  static List<String> _parsePhotos(Map<String, dynamic> props) {
    try {
      // GLOBE puede tener múltiples formatos de fotos
      final photos = props['photos'] as List? ?? [];
      final photoUrls = photos
          .map((photo) {
            if (photo is String) return photo;
            if (photo is Map) return photo['url']?.toString() ?? '';
            return '';
          })
          .where((url) => url.isNotEmpty)
          .toList();

      // También buscar campos alternativos
      if (photoUrls.isEmpty) {
        final photoUrl = props['photoUrl']?.toString();
        if (photoUrl != null && photoUrl.isNotEmpty) {
          photoUrls.add(photoUrl);
        }
      }

      return photoUrls;
    } catch (e) {
      debugPrint('Error parseando fotos: $e');
      return [];
    }
  }

  /// Obtiene estadísticas agregadas de floración para un área
  static Future<FloweringStats?> getFloweringStats(
    LatLng location,
    double radiusKm,
  ) async {
    final observations = await getFloweringObservations(
      location,
      radiusKm,
      startDate: DateTime.now().subtract(const Duration(days: 365)),
    );

    if (observations.isEmpty) return null;

    // Agrupar por mes
    final monthlyCount = <int, int>{};
    for (final obs in observations) {
      final month = obs.date.month;
      monthlyCount[month] = (monthlyCount[month] ?? 0) + 1;
    }

    return FloweringStats(
      totalObservations: observations.length,
      monthlyDistribution: monthlyCount,
      peakMonth: monthlyCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key,
      averageObservationsPerMonth: observations.length / 12,
    );
  }
}

/// Modelo de observación de flores según GLOBE Observer
class FlowerObservation {
  final String id;
  final DateTime date;
  final double latitude;
  final double longitude;
  final String landCoverType;
  final String? classification;
  final String? description;
  final String observer;
  final List<String> photos;
  final bool hasFlowers;

  FlowerObservation({
    required this.id,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.landCoverType,
    this.classification,
    this.description,
    required this.observer,
    required this.photos,
    this.hasFlowers = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'landCoverType': landCoverType,
    'classification': classification,
    'description': description,
    'observer': observer,
    'photos': photos,
    'hasFlowers': hasFlowers,
  };
}

/// Estadísticas de floración
class FloweringStats {
  final int totalObservations;
  final Map<int, int> monthlyDistribution;
  final int peakMonth;
  final double averageObservationsPerMonth;

  FloweringStats({
    required this.totalObservations,
    required this.monthlyDistribution,
    required this.peakMonth,
    required this.averageObservationsPerMonth,
  });
}
