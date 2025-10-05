import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graney/graney/bloom_analysis/domain/entities/bloom_data_point_entity.dart';

class NasaHistoricalService {
  static Future<List<BloomDataPointEntity>> getHistoricalNDVI(
    LatLng location,
    int monthsBack,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final List<BloomDataPointEntity> history = [];
    final now = DateTime.now();
    final random = Random(location.latitude.hashCode);

    for (int i = monthsBack; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      final seasonalFactor = _calculateSeasonalFactor(date, location.latitude);
      final baseNDVI = 0.3 + (seasonalFactor * 0.5);
      final variation = (random.nextDouble() * 0.3) - 0.15;
      final ndvi = (baseNDVI + variation).clamp(0.0, 1.0);

      final bloomProbability = _calculateBloomProbability(ndvi, seasonalFactor);

      history.add(
        BloomDataPointEntity(
          date: date,
          ndvi: ndvi,
          bloomProbability: bloomProbability,
        ),
      );
    }

    return history;
  }

  static double _calculateSeasonalFactor(DateTime date, double latitude) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;

    if (latitude > 0) {
      return (1 + cos(2 * pi * (dayOfYear - 172) / 365)) / 2;
    } else {
      return (1 + cos(2 * pi * (dayOfYear - 355) / 365)) / 2;
    }
  }

  static double _calculateBloomProbability(double ndvi, double seasonalFactor) {
    double probability = 0.0;

    if (ndvi > 0.7) {
      probability = 0.8 + (ndvi - 0.7) * 2.0;
    } else if (ndvi > 0.6) {
      probability = 0.5 + (ndvi - 0.6) * 3.0;
    } else if (ndvi > 0.5) {
      probability = 0.2 + (ndvi - 0.5) * 3.0;
    } else {
      probability = ndvi * 0.4;
    }

    probability *= seasonalFactor;

    final random = Random();
    final randomVariation = (random.nextDouble() * 0.2) - 0.1;

    return (probability + randomVariation).clamp(0.0, 1.0);
  }
}
