/// Constantes de API según recursos oficiales de NASA para el reto de Wildflower Bloom
///
/// Referencias oficiales:
/// - GLOBE Observer: https://observer.globe.gov/do-globe-observer/do-more/data-requests/wildflower-blooms
/// - NASA Worldview: https://worldview.earthdata.nasa.gov/
/// - Artículo NASA JPL: https://www.jpl.nasa.gov/news/nasa-takes-to-the-air-to-study-wildflowers/
class ApiConstants {
  // ============================================================================
  // NASA WORLDVIEW / GIBS
  // ============================================================================

  /// Base URL para NASA GIBS (Global Imagery Browse Services)
  /// Usado por NASA Worldview para visualizar superblooms
  static const String nasaWorldviewBaseUrl =
      'https://gibs.earthdata.nasa.gov/wms/epsg4326/best/wms.cgi';

  /// Capas satelitales recomendadas por NASA para monitoreo de floración
  /// Fuente: https://worldview.earthdata.nasa.gov/
  static const Map<String, String> nasaLayers = {
    // Landsat 8/9 - RECOMENDADO ESPECÍFICAMENTE POR NASA PARA SUPERBLOOMS
    'landsat_truecolor':
        'Landsat_WELD_CorrectedReflectance_TrueColor_Global_Annual',

    // MODIS Terra - Para análisis de vegetación
    'ndvi': 'MODIS_Terra_NDVI_8Day',
    'evi': 'MODIS_Terra_EVI_8Day',
    'temperature': 'MODIS_Terra_Land_Surface_Temp_Day',

    // VIIRS - Alta resolución para color real
    'viirs_truecolor': 'VIIRS_SNPP_CorrectedReflectance_TrueColor',
    'viirs_bands': 'VIIRS_SNPP_CorrectedReflectance_BandsM11-I2-I1',

    // Sentinel-2 (ESA) - Mencionado por NASA en artículos de superbloom
    'sentinel2_truecolor': 'Sentinel2_L2A_Surface_Reflectance_TrueColor',
  };

  // ============================================================================
  // GLOBE OBSERVER
  // ============================================================================

  /// API oficial de GLOBE Observer para observaciones ciudadanas
  /// Fuente: https://observer.globe.gov/
  static const String globeObserverApiUrl =
      'https://api.globe.gov/search/v1/measurement/protocol';

  /// Protocolos GLOBE para monitoreo de floración
  static const Map<String, String> globeProtocols = {
    'land_covers': 'land_covers', // Principal para flores
    'tree_heights': 'tree_heights', // Incluye fenología de árboles en flor
    'mosquito_habitat':
        'mosquito_habitat_mapper', // Puede incluir plantas florales
  };

  // ============================================================================
  // NASA POWER (datos climáticos complementarios)
  // ============================================================================

  /// NASA POWER API para datos meteorológicos históricos
  /// Útil para correlacionar precipitación con blooms
  static const String nasaPowerUrl =
      'https://power.larc.nasa.gov/api/temporal/daily/point';

  /// Parámetros climáticos relevantes para predicción de blooms
  static const List<String> powerParameters = [
    'PRECTOTCORR', // Precipitación (KEY para predecir superblooms)
    'T2M', // Temperatura a 2m
    'RH2M', // Humedad relativa
    'ALLSKY_SFC_SW_DWN', // Radiación solar
  ];

  // ============================================================================
  // CONFIGURACIÓN
  // ============================================================================

  static const Duration defaultTimeout = Duration(seconds: 20);
  static const int maxRetries = 3;

  /// Radio de búsqueda en kilómetros para GLOBE Observer
  static const double defaultSearchRadiusKm = 50.0;

  /// Resolución de imágenes satelitales
  static const Map<String, int> imageResolutions = {
    'thumbnail': 256,
    'preview': 512,
    'standard': 1024,
    'high': 2048,
  };

  // ============================================================================
  // RANGOS DE VALORES PARA ANÁLISIS
  // ============================================================================

  /// Umbrales de NDVI para clasificación de vegetación
  static const Map<String, double> ndviThresholds = {
    'bare_soil': 0.2,
    'sparse_vegetation': 0.4,
    'moderate_vegetation': 0.6,
    'dense_vegetation': 0.8,
  };

  /// Umbrales de probabilidad de bloom
  static const Map<String, double> bloomProbabilityThresholds = {
    'very_low': 0.2,
    'low': 0.4,
    'moderate': 0.6,
    'high': 0.8,
  };

  // ============================================================================
  // INFORMACIÓN DE CAPAS
  // ============================================================================

  /// Información detallada sobre cada capa satelital
  static const Map<String, LayerInfo> layerDetails = {
    'landsat': LayerInfo(
      name: 'Landsat 8/9',
      resolution: '30m',
      revisitTime: '16 días',
      bestFor: 'Comparaciones temporales de superblooms',
      source: 'NASA/USGS',
    ),
    'sentinel2': LayerInfo(
      name: 'Sentinel-2',
      resolution: '10m',
      revisitTime: '5 días',
      bestFor: 'Alta resolución espacial',
      source: 'ESA',
    ),
    'modis': LayerInfo(
      name: 'MODIS',
      resolution: '250m-1km',
      revisitTime: '1-2 días',
      bestFor: 'Monitoreo temporal frecuente',
      source: 'NASA',
    ),
    'viirs': LayerInfo(
      name: 'VIIRS',
      resolution: '375m',
      revisitTime: 'Diario',
      bestFor: 'Color real de alta calidad',
      source: 'NASA/NOAA',
    ),
  };

  // ============================================================================
  // VALIDACIÓN
  // ============================================================================

  /// Verifica si una capa es válida
  static bool isValidLayer(String layerType) {
    return nasaLayers.containsKey(layerType);
  }

  /// Obtiene el ID de capa para NASA GIBS
  static String? getLayerId(String layerType) {
    return nasaLayers[layerType];
  }

  /// Obtiene información sobre una capa
  static LayerInfo? getLayerInfo(String layerType) {
    // Mapear tipo de capa a categoría
    if (layerType.contains('landsat')) return layerDetails['landsat'];
    if (layerType.contains('sentinel')) return layerDetails['sentinel2'];
    if (layerType.contains('modis') ||
        layerType == 'ndvi' ||
        layerType == 'evi') {
      return layerDetails['modis'];
    }
    if (layerType.contains('viirs')) return layerDetails['viirs'];
    return null;
  }
}

/// Información sobre una capa satelital
class LayerInfo {
  final String name;
  final String resolution;
  final String revisitTime;
  final String bestFor;
  final String source;

  const LayerInfo({
    required this.name,
    required this.resolution,
    required this.revisitTime,
    required this.bestFor,
    required this.source,
  });

  @override
  String toString() {
    return '$name ($source)\n'
        'Resolución: $resolution\n'
        'Tiempo de revisita: $revisitTime\n'
        'Mejor para: $bestFor';
  }
}

/// Rangos de fechas recomendados para buscar superblooms
class SuperbloomSeasons {
  /// California superblooms típicamente ocurren en primavera
  static const Map<String, DateRange> california = {
    'peak': DateRange(startMonth: 3, endMonth: 5), // Marzo-Mayo
    'early': DateRange(startMonth: 2, endMonth: 3), // Febrero-Marzo
    'late': DateRange(startMonth: 5, endMonth: 6), // Mayo-Junio
  };

  /// Yucatán (México) tiene diferentes patrones
  static const Map<String, DateRange> yucatan = {
    'rainy_season': DateRange(startMonth: 5, endMonth: 10), // Mayo-Octubre
    'dry_season': DateRange(startMonth: 11, endMonth: 4), // Nov-Abril
  };
}

class DateRange {
  final int startMonth;
  final int endMonth;

  const DateRange({required this.startMonth, required this.endMonth});
}

/// URLs de referencia oficiales de NASA
class NasaReferences {
  /// NASA Worldview
  static const String worldview = 'https://worldview.earthdata.nasa.gov/';
}
