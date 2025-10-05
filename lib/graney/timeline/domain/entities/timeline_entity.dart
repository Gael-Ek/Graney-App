import 'package:equatable/equatable.dart';
import 'timeline_point_entity.dart';

class TimelineEntity extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final List<TimelinePointEntity> points;
  final String region;

  const TimelineEntity({
    required this.startDate,
    required this.endDate,
    required this.points,
    required this.region,
  });

  @override
  List<Object?> get props => [startDate, endDate, points, region];
}
