import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graney/graney/statistics/domain/entities/stats_entity.dart';

class StatsService {
  static Future<StatsEntity> getRegionalStats(
    LatLng location,
    int months,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final random = Random();
    final Map<String, double> monthlyAvg = {};

    for (int i = months; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i * 30));
      final month = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      monthlyAvg[month] = 0.3 + (random.nextDouble() * 0.5);
    }

    return StatsEntity(
      avgNdvi: 0.55,
      maxNdvi: 0.85,
      minNdvi: 0.25,
      totalBloomEvents: 12,
      bloomTypeDistribution: {'Primavera': 5, 'Tropical': 4, 'Agrícola': 3},
      monthlyAvgNdvi: monthlyAvg,
    );
  }
}
