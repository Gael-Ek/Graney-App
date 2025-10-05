import 'package:equatable/equatable.dart';

class StatsEntity extends Equatable {
  final double avgNdvi;
  final double maxNdvi;
  final double minNdvi;
  final int totalBloomEvents;
  final Map<String, int> bloomTypeDistribution;
  final Map<String, double> monthlyAvgNdvi;

  const StatsEntity({
    required this.avgNdvi,
    required this.maxNdvi,
    required this.minNdvi,
    required this.totalBloomEvents,
    required this.bloomTypeDistribution,
    required this.monthlyAvgNdvi,
  });

  @override
  List<Object?> get props => [
    avgNdvi,
    maxNdvi,
    minNdvi,
    totalBloomEvents,
    bloomTypeDistribution,
    monthlyAvgNdvi,
  ];
}
