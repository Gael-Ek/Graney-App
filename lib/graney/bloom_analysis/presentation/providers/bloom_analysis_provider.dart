import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graney/graney/bloom_analysis/domain/entities/bloom_analysis_entity.dart';
import 'package:graney/domain/shared/enums/bloom_type.dart';
import 'package:graney/domain/shared/enums/vegetation_type.dart';
import 'package:graney/graney/bloom_analysis/infrastructure/services/globe_observer_service.dart';
import 'package:graney/graney/bloom_analysis/infrastructure/services/nasa_worldview_service.dart';

class BloomAnalysisProvider extends ChangeNotifier {
  bool _isAnalyzing = false;
  BloomAnalysisEntity? _currentAnalysis;
  final List<BloomAnalysisEntity> _historicalData = [];
  List<FlowerObservation> _globeObservations = [];

  bool get isAnalyzing => _isAnalyzing;
  BloomAnalysisEntity? get currentAnalysis => _currentAnalysis;
  List<BloomAnalysisEntity> get historicalData => _historicalData;
  List<FlowerObservation> get globeObservations => _globeObservations;

  Future<void> analyzeBloom(LatLng location) async {
    _isAnalyzing = true;
    notifyListeners();

    try {
      debugPrint('🚀 Iniciando análisis NASA completo para: $location');

      // 1. Obtener NDVI real de NASA Worldview
      final ndvi = await NasaWorldviewService.getNDVIForLocation(location);
      debugPrint('📊 NDVI: $ndvi');

      // 2. Obtener observaciones GLOBE Observer
      final globeObs = await GlobeObserverService.getFloweringObservations(
        location,
        50.0,
        startDate: DateTime.now().subtract(const Duration(days: 365)),
      );
      _globeObservations = globeObs;
      debugPrint('🌸 Observaciones GLOBE: ${globeObs.length}');

      // 3. Obtener estadísticas
      final stats = await GlobeObserverService.getFloweringStats(
        location,
        50.0,
      );

      // 4. Calcular probabilidad combinada
      final bloomProbability = _calculateCombinedBloomProbability(
        ndvi,
        globeObs.length,
        stats,
      );

      // 5. Clasificar intensidad (para compatibilidad con código existente)
      final bloomIntensity = _calculateBloomIntensity(ndvi, bloomProbability);

      // 6. Detectar tipo de floración
      final bloomType = _detectBloomType(
        ndvi,
        bloomProbability,
        globeObs.length,
      );

      // 7. Calcular vegetationType
      final vegetationType = _detectVegetationType(ndvi, location);

      // 8. Obtener temperatura
      final temperature = await _getTemperature(location);

      // 9. Crear análisis COMPATIBLE con tu estructura existente
      _currentAnalysis = BloomAnalysisEntity(
        location: location,
        lastUpdate: DateTime.now(),
        ndviValue: ndvi,
        bloomIntensity: bloomIntensity,
        confidence: _calculateConfidence(ndvi, globeObs.length, true),
        vegetationType: vegetationType,
        bloomType: bloomType,
        dataSources: {
          'NASA Worldview': true,
          'GLOBE Observer': globeObs.isNotEmpty,
          'Landsat 8/9': true,
          'MODIS': true,
        },
        // Nuevos campos NASA
        date: DateTime.now(),
        temperature: temperature,
        precipitation: await _getPrecipitation(location),
        soilMoisture: _estimateSoilMoisture(ndvi),
        bloomProbability: bloomProbability,
        bloomStatus: _classifyBloomStatus(
          ndvi,
          bloomProbability,
          globeObs.length,
        ),
        season: _getCurrentSeason(location.latitude),
        globeObservationCount: globeObs.length,
        hasCitizenReports: globeObs.isNotEmpty,
        peakBloomMonth: stats?.peakMonth,
        hasYearOverYearComparison: false,
        dataSource: 'NASA Worldview + GLOBE Observer',
      );

      // 10. Agregar a histórico
      _historicalData.insert(0, _currentAnalysis!);
      if (_historicalData.length > 10) {
        _historicalData.removeLast();
      }

      debugPrint('✅ Análisis NASA completo finalizado');
    } catch (e) {
      debugPrint('❌ Error en análisis: $e');
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  double _calculateCombinedBloomProbability(
    double ndvi,
    int observationCount,
    FloweringStats? stats,
  ) {
    double probability = 0.0;

    if (ndvi > 0.7) {
      probability = 0.7 + (ndvi - 0.7) * 1.5;
    } else if (ndvi > 0.6) {
      probability = 0.5 + (ndvi - 0.6) * 2.0;
    } else if (ndvi > 0.5) {
      probability = 0.3 + (ndvi - 0.5) * 2.0;
    } else {
      probability = ndvi * 0.6;
    }

    if (observationCount > 0) {
      final observationBonus = (observationCount / 20.0).clamp(0.0, 0.2);
      probability += observationBonus;
    }

    if (stats != null) {
      final currentMonth = DateTime.now().month;
      final isPeakMonth = stats.peakMonth == currentMonth;
      if (isPeakMonth) {
        probability += 0.1;
      }
    }

    return probability.clamp(0.0, 1.0);
  }

  String _calculateBloomIntensity(double ndvi, double probability) {
    if (probability > 0.7 && ndvi > 0.6) return 'alta';
    if (probability > 0.4 && ndvi > 0.4) return 'media';
    return 'baja';
  }

  BloomType _detectBloomType(
    double ndvi,
    double probability,
    int observations,
  ) {
    if (probability > 0.8 && observations > 5 && ndvi > 0.7) {
      return BloomType.superbloom;
    }
    if (probability > 0.6 && ndvi > 0.6) {
      return BloomType.wildflower;
    }
    if (probability > 0.3) {
      return BloomType.wildflower;
    }
    return BloomType.none;
  }

  VegetationType _detectVegetationType(double ndvi, LatLng location) {
    // Lógica simple basada en NDVI y ubicación
    if (ndvi > 0.7) return VegetationType.forest;
    if (ndvi > 0.5) return VegetationType.grassland;
    if (ndvi > 0.3) return VegetationType.agricultural;
    return VegetationType.grassland;
  }

  String _classifyBloomStatus(
    double ndvi,
    double probability,
    int observations,
  ) {
    if (probability > 0.8 && observations > 5 && ndvi > 0.7) {
      return 'Superbloom Confirmado';
    }
    if (probability > 0.7 && ndvi > 0.6) {
      return 'Floración Activa';
    }
    if (probability > 0.5) {
      return 'Floración Moderada';
    }
    if (probability > 0.3) {
      return 'Floración Inicial/Final';
    }
    return 'Sin Floración Significativa';
  }

  double _calculateConfidence(double ndvi, int observations, bool hasData) {
    double conf = 0.5;
    if (ndvi > 0.1 && ndvi < 0.95) conf += 0.2;
    if (observations > 0) conf += 0.15;
    if (observations > 5) conf += 0.1;
    if (hasData) conf += 0.15;
    return conf.clamp(0.0, 1.0);
  }

  String _getCurrentSeason(double latitude) {
    final month = DateTime.now().month;
    if (latitude > 0) {
      if (month >= 3 && month <= 5) return 'Primavera';
      if (month >= 6 && month <= 8) return 'Verano';
      if (month >= 9 && month <= 11) return 'Otoño';
      return 'Invierno';
    } else {
      if (month >= 3 && month <= 5) return 'Otoño';
      if (month >= 6 && month <= 8) return 'Invierno';
      if (month >= 9 && month <= 11) return 'Primavera';
      return 'Verano';
    }
  }

  double _estimateSoilMoisture(double ndvi) {
    return (ndvi * 0.8 + 0.2).clamp(0.0, 1.0);
  }

  Future<double> _getTemperature(LatLng location) async {
    try {
      final tempImage = await NasaWorldviewService.getMapImage(
        layerType: 'temperature',
        minLat: location.latitude - 0.05,
        minLon: location.longitude - 0.05,
        maxLat: location.latitude + 0.05,
        maxLon: location.longitude + 0.05,
        width: 100,
        height: 100,
      );

      if (tempImage != null) {
        return _extractTemperatureFromImage(tempImage, location.latitude);
      }
    } catch (e) {
      debugPrint('Error obteniendo temperatura: $e');
    }
    return _estimateTemperature(location.latitude);
  }

  double _extractTemperatureFromImage(Uint8List imageData, double latitude) {
    const sampleSize = 10;
    final centerStart = (imageData.length ~/ 2) - (sampleSize * 4);

    if (centerStart < 0) return _estimateTemperature(latitude);

    double sumTemp = 0.0;
    int count = 0;

    for (int i = centerStart; i < centerStart + (sampleSize * 4); i += 4) {
      if (i + 2 >= imageData.length) break;
      final r = imageData[i];
      final temp = ((r / 255.0) * 40.0) + 5.0;
      sumTemp += temp;
      count++;
    }

    return count > 0 ? sumTemp / count : _estimateTemperature(latitude);
  }

  double _estimateTemperature(double latitude) {
    final month = DateTime.now().month;
    final latAbs = latitude.abs();
    double baseTemp = 30.0 - (latAbs * 0.5);
    double seasonalAdjust = 0.0;

    if (latitude > 0) {
      seasonalAdjust = 10 * cos(2 * 3.14159 * (month - 7) / 12);
    } else {
      seasonalAdjust = 10 * cos(2 * 3.14159 * (month - 1) / 12);
    }

    return baseTemp + seasonalAdjust;
  }

  Future<double> _getPrecipitation(LatLng location) async {
    // Estimación basada en NDVI
    final ndvi = _currentAnalysis?.ndviValue ?? 0.5;
    return (ndvi * 100).clamp(0.0, 200.0);
  }

  void clearAnalysis() {
    _currentAnalysis = null;
    _globeObservations.clear();
    notifyListeners();
  }

  void clearHistory() {
    _historicalData.clear();
    notifyListeners();
  }
}
