// application/timeline/domain/entities/timeline_point_entity.dart
import 'package:equatable/equatable.dart';

class TimelinePointEntity extends Equatable {
  final DateTime date;
  final double ndvi;
  final bool hasBloom;
  final String? imageUrl;

  const TimelinePointEntity({
    required this.date,
    required this.ndvi,
    required this.hasBloom,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [date, ndvi, hasBloom];
}
