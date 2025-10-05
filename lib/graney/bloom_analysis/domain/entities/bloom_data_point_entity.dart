import 'package:equatable/equatable.dart';

class BloomDataPointEntity extends Equatable {
  final DateTime date;
  final double ndvi;
  final double bloomProbability;
  final bool? bloomActive;

  const BloomDataPointEntity({
    required this.date,
    required this.ndvi,
    required this.bloomProbability,
    this.bloomActive,
  });

  @override
  List<Object?> get props => [date, ndvi, bloomProbability, bloomActive];
}
