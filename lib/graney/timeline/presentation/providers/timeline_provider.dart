import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/timeline_entity.dart';
import '../../infrastructure/services/timeline_service.dart';

class TimelineProvider extends ChangeNotifier {
  TimelineEntity? _timeline;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentIndex = 0;

  TimelineEntity? get timeline => _timeline;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentIndex => _currentIndex;

  Future<void> loadTimeline(
    LatLng location,
    DateTime startDate,
    DateTime endDate,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _timeline = await TimelineService.getTimeline(
        location,
        startDate,
        endDate,
      );
      _currentIndex = _timeline!.points.length - 1;
    } catch (e) {
      _errorMessage = 'Error cargando timeline: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateIndex(int index) {
    if (_timeline != null && index >= 0 && index < _timeline!.points.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void clearTimeline() {
    _timeline = null;
    _currentIndex = 0;
    _errorMessage = null;
    notifyListeners();
  }
}
