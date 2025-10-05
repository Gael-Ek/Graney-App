import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/timeline_entity.dart';
import '../../domain/entities/timeline_point_entity.dart';

class TimelineService {
  static Future<TimelineEntity> getTimeline(
    LatLng location,
    DateTime startDate,
    DateTime endDate,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final points = <TimelinePointEntity>[];
    final random = Random();

    var currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      final ndvi = 0.3 + (random.nextDouble() * 0.5);
      points.add(
        TimelinePointEntity(
          date: currentDate,
          ndvi: ndvi,
          hasBloom: ndvi > 0.6,
        ),
      );
      currentDate = currentDate.add(const Duration(days: 7));
    }

    return TimelineEntity(
      startDate: startDate,
      endDate: endDate,
      points: points,
      region: 'Yucatán, México',
    );
  }
}
