import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graney/domain/shared/enums/bloom_type.dart';
import 'package:graney/domain/shared/enums/vegetation_type.dart';

class BloomAnalysisEntity {
  // ========== CAMPOS EXISTENTES (mantener compatibilidad) ==========
  final LatLng location;
  final DateTime lastUpdate;
  final double ndviValue;
  final String
  bloomIntensity; // 'muy alta', 'alta', 'media', 'baja', 'muy baja'
  final double confidence;
  final VegetationType vegetationType;
  final BloomType? bloomType;
  final Map<String, bool>? dataSources;

  // ========== NUEVOS CAMPOS NASA ==========
  final DateTime date;
  final double? evi;
  final double temperature;
  final double precipitation;
  final double soilMoisture;
  final double bloomProbability;
  final String bloomStatus;
  final String season;

  // Datos GLOBE Observer
  final int globeObservationCount;
  final bool hasCitizenReports;
  final int? peakBloomMonth;

  // Comparación temporal
  final bool hasYearOverYearComparison;
  final double? yearOverYearChange;

  final String dataSource;

  BloomAnalysisEntity({
    required this.location,
    required this.lastUpdate,
    required this.ndviValue,
    required this.bloomIntensity,
    required this.confidence,
    required this.vegetationType,
    this.bloomType,
    this.dataSources,
    // Nuevos con valores por defecto para compatibilidad
    DateTime? date,
    this.evi,
    double? temperature,
    double? precipitation,
    double? soilMoisture,
    double? bloomProbability,
    String? bloomStatus,
    String? season,
    this.globeObservationCount = 0,
    this.hasCitizenReports = false,
    this.peakBloomMonth,
    this.hasYearOverYearComparison = false,
    this.yearOverYearChange,
    this.dataSource = 'NASA Worldview + GLOBE Observer',
  }) : date = date ?? lastUpdate,
       temperature = temperature ?? 25.0,
       precipitation = precipitation ?? 50.0,
       soilMoisture = soilMoisture ?? 0.5,
       bloomProbability = bloomProbability ?? (ndviValue * 0.8),
       bloomStatus = bloomStatus ?? _deriveBloomStatus(bloomIntensity),
       season = season ?? 'Primavera';

  static String _deriveBloomStatus(String intensity) {
    switch (intensity.toLowerCase()) {
      case 'muy alta':
        return 'Superfloración Activa';
      case 'alta':
        return 'Floración Activa';
      case 'media':
        return 'Floración Moderada';
      case 'baja':
        return 'Floración Inicial/Final';
      case 'muy baja':
        return 'Sin Floración Significativa';
      default:
        return 'Sin Floración Significativa';
    }
  }

  // ========== SISTEMA DE COLORES UNIFICADO ==========

  /// Color principal según intensidad (para fondos, banners)
  String get primaryColor {
    switch (bloomIntensity.toLowerCase()) {
      case 'muy alta':
      case 'alta':
        return '#4CAF50'; // Verde intenso
      case 'media':
      case 'moderada':
        return '#FFC107'; // Amarillo
      case 'baja':
        return '#9E9E9E'; // Gris
      case 'muy baja':
        return '#757575'; // Gris oscuro
      default:
        return '#9E9E9E';
    }
  }

  /// Color para texto sobre el fondo primario
  String get textOnPrimaryColor {
    switch (bloomIntensity.toLowerCase()) {
      case 'muy alta':
      case 'alta':
        return '#FFFFFF'; // Blanco sobre verde
      case 'media':
      case 'moderada':
        return '#000000'; // Negro sobre amarillo
      case 'baja':
      case 'muy baja':
        return '#FFFFFF'; // Blanco sobre gris
      default:
        return '#FFFFFF';
    }
  }

  /// Color para elementos secundarios (bordes, iconos)
  String get secondaryColor {
    switch (bloomIntensity.toLowerCase()) {
      case 'muy alta':
      case 'alta':
        return '#388E3C'; // Verde más oscuro
      case 'media':
      case 'moderada':
        return '#FFA000'; // Amarillo anaranjado
      case 'baja':
        return '#616161'; // Gris medio
      case 'muy baja':
        return '#424242'; // Gris oscuro
      default:
        return '#616161';
    }
  }

  /// Color para indicadores de progreso
  String get progressColor {
    switch (bloomIntensity.toLowerCase()) {
      case 'muy alta':
      case 'alta':
        return '#4CAF50'; // Verde
      case 'media':
      case 'moderada':
        return '#FFC107'; // Amarillo
      case 'baja':
        return '#9E9E9E'; // Gris
      case 'muy baja':
        return '#757575'; // Gris oscuro
      default:
        return '#9E9E9E';
    }
  }

  /// Color para iconos
  String get iconColor {
    switch (bloomIntensity.toLowerCase()) {
      case 'muy alta':
      case 'alta':
        return '#FFFFFF'; // Blanco
      case 'media':
      case 'moderada':
        return '#000000'; // Negro
      case 'baja':
      case 'muy baja':
        return '#FFFFFF'; // Blanco
      default:
        return '#FFFFFF';
    }
  }

  /// Estilo completo para el badge de intensidad
  Map<String, String> get intensityBadgeStyle {
    switch (bloomIntensity.toLowerCase()) {
      case 'muy alta':
        return {
          'background': '#4CAF50',
          'text': '#FFFFFF',
          'border': '#388E3C',
          'emoji': '🌻🌄',
        };
      case 'alta':
        return {
          'background': '#4CAF50',
          'text': '#FFFFFF',
          'border': '#388E3C',
          'emoji': '🌺',
        };
      case 'media':
      case 'moderada':
        return {
          'background': '#FFC107',
          'text': '#000000',
          'border': '#FFA000',
          'emoji': '🌼',
        };
      case 'baja':
        return {
          'background': '#9E9E9E',
          'text': '#FFFFFF',
          'border': '#616161',
          'emoji': '🌱',
        };
      case 'muy baja':
        return {
          'background': '#757575',
          'text': '#FFFFFF',
          'border': '#424242',
          'emoji': '❌',
        };
      default:
        return {
          'background': '#9E9E9E',
          'text': '#FFFFFF',
          'border': '#616161',
          'emoji': '📊',
        };
    }
  }

  // ========== GETTERS COMPATIBLES ==========

  /// Alias para ndviValue (para compatibilidad con código nuevo)
  double get ndvi => ndviValue;

  /// Detecta si hay floración basado en intensidad
  bool get isBloomDetected =>
      bloomIntensity.toLowerCase() != 'baja' &&
      bloomIntensity.toLowerCase() != 'muy baja';

  /// Verifica si es superbloom
  bool get isSuperbloom {
    return bloomProbability > 0.85 &&
        ndviValue > 0.75 &&
        bloomIntensity.toLowerCase() == 'muy alta' &&
        (globeObservationCount > 10 || hasCitizenReports);
  }

  /// Verifica si hay floración activa
  bool get hasActiveBloom {
    return bloomProbability > 0.6 && ndviValue > 0.6;
  }

  /// Color para representar el estado (manteniendo compatibilidad)
  String get bloomColor => primaryColor;

  /// Descripción legible con emojis de color
  String get description {
    final badgeStyle = intensityBadgeStyle;
    final emoji = badgeStyle['emoji']!;
    final parts = <String>[];
    parts.add('$emoji Estado: $bloomStatus');
    parts.add('Probabilidad: ${(bloomProbability * 100).toStringAsFixed(0)}%');
    parts.add('NDVI: ${ndviValue.toStringAsFixed(2)}');
    parts.add('Temperatura: ${temperature.toStringAsFixed(1)}°C');

    if (globeObservationCount > 0) {
      parts.add('👥 Observaciones: $globeObservationCount');
    }

    return parts.join(' • ');
  }

  /// Recomendaciones con colores coherentes
  List<Map<String, dynamic>> get coloredRecommendations {
    final recs = <Map<String, dynamic>>[];

    if (isSuperbloom) {
      recs.add({
        'text': '¡SUPERBLOOM DETECTADO! Momento ideal para visitar',
        'color': primaryColor,
        'icon': '🌻',
        'type': 'success',
      });
      recs.add({
        'text': 'Comparte tus observaciones en GLOBE Observer',
        'color': primaryColor,
        'icon': '📱',
        'type': 'info',
      });
    } else if (hasActiveBloom) {
      recs.add({
        'text': 'Floración activa. Buen momento para observación',
        'color': primaryColor,
        'icon': '🌺',
        'type': 'success',
      });
    } else if (bloomProbability > 0.3) {
      recs.add({
        'text': 'Floración en desarrollo. Revisar en 1-2 semanas',
        'color': primaryColor,
        'icon': '📅',
        'type': 'warning',
      });
    } else {
      recs.add({
        'text': 'No hay floración significativa actualmente',
        'color': primaryColor,
        'icon': 'ℹ️',
        'type': 'info',
      });
    }

    // Recomendaciones basadas en condiciones climáticas
    if (precipitation < 20) {
      recs.add({
        'text': 'Baja precipitación. Floración limitada esperada',
        'color': primaryColor,
        'icon': '💧',
        'type': 'warning',
      });
    } else if (precipitation > 100) {
      recs.add({
        'text': 'Alta precipitación. Condiciones favorables',
        'color': primaryColor,
        'icon': '🌧️',
        'type': 'success',
      });
    }

    return recs;
  }

  /// Factores contribuyentes con colores unificados
  Map<String, dynamic> get contributingFactors {
    return {
      'ndvi': {
        'value': ndviValue,
        'status': ndviValue > 0.6 ? 'Favorable' : 'Desfavorable',
        'weight': 0.4,
        'color': primaryColor,
      },
      'precipitation': {
        'value': precipitation,
        'status': precipitation > 50 ? 'Favorable' : 'Desfavorable',
        'weight': 0.3,
        'color': primaryColor,
      },
      'temperature': {
        'value': temperature,
        'status': (temperature > 15 && temperature < 28)
            ? 'Favorable'
            : 'Subóptima',
        'weight': 0.2,
        'color': primaryColor,
      },
      'citizen_observations': {
        'value': globeObservationCount,
        'status': hasCitizenReports ? 'Confirmado' : 'No confirmado',
        'weight': 0.1,
        'color': primaryColor,
      },
    };
  }

  /// Método helper para obtener Color objects desde strings hexadecimales
  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  // ========== SERIALIZACIÓN ==========

  Map<String, dynamic> toJson() {
    return {
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'lastUpdate': lastUpdate.toIso8601String(),
      'ndviValue': ndviValue,
      'bloomIntensity': bloomIntensity,
      'confidence': confidence,
      'vegetationType': vegetationType.toString(),
      'bloomType': bloomType?.toString(),
      'dataSources': dataSources,
      // Nuevos campos
      'date': date.toIso8601String(),
      'evi': evi,
      'temperature': temperature,
      'precipitation': precipitation,
      'soilMoisture': soilMoisture,
      'bloomProbability': bloomProbability,
      'bloomStatus': bloomStatus,
      'season': season,
      'globeObservationCount': globeObservationCount,
      'hasCitizenReports': hasCitizenReports,
      'peakBloomMonth': peakBloomMonth,
      'hasYearOverYearComparison': hasYearOverYearComparison,
      'yearOverYearChange': yearOverYearChange,
      'dataSource': dataSource,
    };
  }

  factory BloomAnalysisEntity.fromJson(Map<String, dynamic> json) {
    final locData = json['location'] as Map<String, dynamic>;
    return BloomAnalysisEntity(
      location: LatLng(
        locData['latitude'] as double,
        locData['longitude'] as double,
      ),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
      ndviValue: json['ndviValue'] as double,
      bloomIntensity: json['bloomIntensity'] as String,
      confidence: json['confidence'] as double,
      vegetationType: VegetationType.values.firstWhere(
        (e) => e.toString() == json['vegetationType'],
        orElse: () => VegetationType.grassland,
      ),
      bloomType: json['bloomType'] != null
          ? BloomType.values.firstWhere(
              (e) => e.toString() == json['bloomType'],
              orElse: () => BloomType.none,
            )
          : null,
      dataSources: json['dataSources'] != null
          ? Map<String, bool>.from(json['dataSources'] as Map)
          : null,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
      evi: json['evi'] as double?,
      temperature: json['temperature'] as double?,
      precipitation: json['precipitation'] as double?,
      soilMoisture: json['soilMoisture'] as double?,
      bloomProbability: json['bloomProbability'] as double?,
      bloomStatus: json['bloomStatus'] as String?,
      season: json['season'] as String?,
      globeObservationCount: json['globeObservationCount'] as int? ?? 0,
      hasCitizenReports: json['hasCitizenReports'] as bool? ?? false,
      peakBloomMonth: json['peakBloomMonth'] as int?,
      hasYearOverYearComparison:
          json['hasYearOverYearComparison'] as bool? ?? false,
      yearOverYearChange: json['yearOverYearChange'] as double?,
      dataSource:
          json['dataSource'] as String? ?? 'NASA Worldview + GLOBE Observer',
    );
  }

  BloomAnalysisEntity copyWith({
    LatLng? location,
    DateTime? lastUpdate,
    double? ndviValue,
    String? bloomIntensity,
    double? confidence,
    VegetationType? vegetationType,
    BloomType? bloomType,
    Map<String, bool>? dataSources,
    DateTime? date,
    double? evi,
    double? temperature,
    double? precipitation,
    double? soilMoisture,
    double? bloomProbability,
    String? bloomStatus,
    String? season,
    int? globeObservationCount,
    bool? hasCitizenReports,
    int? peakBloomMonth,
    bool? hasYearOverYearComparison,
    double? yearOverYearChange,
    String? dataSource,
  }) {
    return BloomAnalysisEntity(
      location: location ?? this.location,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      ndviValue: ndviValue ?? this.ndviValue,
      bloomIntensity: bloomIntensity ?? this.bloomIntensity,
      confidence: confidence ?? this.confidence,
      vegetationType: vegetationType ?? this.vegetationType,
      bloomType: bloomType ?? this.bloomType,
      dataSources: dataSources ?? this.dataSources,
      date: date ?? this.date,
      evi: evi ?? this.evi,
      temperature: temperature ?? this.temperature,
      precipitation: precipitation ?? this.precipitation,
      soilMoisture: soilMoisture ?? this.soilMoisture,
      bloomProbability: bloomProbability ?? this.bloomProbability,
      bloomStatus: bloomStatus ?? this.bloomStatus,
      season: season ?? this.season,
      globeObservationCount:
          globeObservationCount ?? this.globeObservationCount,
      hasCitizenReports: hasCitizenReports ?? this.hasCitizenReports,
      peakBloomMonth: peakBloomMonth ?? this.peakBloomMonth,
      hasYearOverYearComparison:
          hasYearOverYearComparison ?? this.hasYearOverYearComparison,
      yearOverYearChange: yearOverYearChange ?? this.yearOverYearChange,
      dataSource: dataSource ?? this.dataSource,
    );
  }

  @override
  String toString() {
    return 'BloomAnalysis(status: $bloomStatus, '
        'intensity: $bloomIntensity, '
        'ndvi: ${ndviValue.toStringAsFixed(2)}, '
        'color: $primaryColor, '
        'observations: $globeObservationCount)';
  }
}
