import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graney/graney/statistics/infrastructure/stats_service.dart';
import '../../domain/entities/stats_entity.dart';

class StatsProvider extends ChangeNotifier {
  StatsEntity? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  StatsEntity? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadStats(LatLng location, int months) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stats = await StatsService.getRegionalStats(location, months);
    } catch (e) {
      _errorMessage = 'Error cargando estadísticas: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearStats() {
    _stats = null;
    _errorMessage = null;
    notifyListeners();
  }
}
