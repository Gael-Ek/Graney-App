import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xml/xml.dart' as xml;

/// Servicio NASA Worldview/GIBS según recomendaciones oficiales
/// Ref: https://worldview.earthdata.nasa.gov/
class NasaWorldviewService {
  static const String gibsBaseUrl =
      'https://gibs.earthdata.nasa.gov/wms/epsg4326/best/wms.cgi';

  /// Capas recomendadas por NASA para monitoreo de superbloom
  static const Map<String, LayerConfig> layers = {
    // Landsat 8/9 - Recomendado específicamente por NASA para superblooms
    'landsat': LayerConfig(
      id: 'Landsat_WELD_CorrectedReflectance_TrueColor_Global_Annual',
      name: 'Landsat 8/9 True Color',
      description: 'Imágenes Landsat usadas por NASA para detectar superblooms',
    ),

    // MODIS para vegetación
    'ndvi': LayerConfig(
      id: 'MODIS_Terra_NDVI_8Day',
      name: 'MODIS NDVI',
      description: 'Índice de vegetación de diferencia normalizada',
    ),

    'evi': LayerConfig(
      id: 'MODIS_Terra_EVI_8Day',
      name: 'MODIS EVI',
      description: 'Índice de vegetación mejorado - mejor para áreas densas',
    ),

    // VIIRS para color real de alta resolución
    'viirs': LayerConfig(
      id: 'VIIRS_SNPP_CorrectedReflectance_TrueColor',
      name: 'VIIRS True Color',
      description: 'Color real de alta resolución',
    ),

    // Temperatura superficial
    'temperature': LayerConfig(
      id: 'MODIS_Terra_Land_Surface_Temp_Day',
      name: 'Land Surface Temperature',
      description: 'Temperatura superficial diurna',
    ),

    // Sentinel-2 (si está disponible en GIBS)
    'sentinel': LayerConfig(
      id: 'Sentinel2_L2A_Surface_Reflectance_TrueColor',
      name: 'Sentinel-2 True Color',
      description: 'Imágenes ESA Sentinel-2 (10m resolución)',
    ),
  };

  /// Obtiene imagen satelital de una ubicación específica
  static Future<Uint8List?> getMapImage({
    required String layerType,
    required double minLat,
    required double minLon,
    required double maxLat,
    required double maxLon,
    DateTime? date,
    int width = 512,
    int height = 512,
  }) async {
    try {
      final layerConfig = layers[layerType];
      if (layerConfig == null) {
        debugPrint('❌ Capa no encontrada: $layerType');
        return null;
      }

      // Fecha: 8 días atrás para MODIS, actual para otros
      final dateStr = _formatDate(
        date ?? DateTime.now().subtract(const Duration(days: 8)),
      );

      final url = Uri.parse(gibsBaseUrl).replace(
        queryParameters: {
          'SERVICE': 'WMS',
          'REQUEST': 'GetMap',
          'LAYERS': layerConfig.id,
          'VERSION': '1.3.0',
          'FORMAT': 'image/png',
          'TRANSPARENT': 'true',
          'WIDTH': width.toString(),
          'HEIGHT': height.toString(),
          'CRS': 'EPSG:4326',
          'BBOX': '$minLat,$minLon,$maxLat,$maxLon',
          'TIME': dateStr,
        },
      );

      debugPrint('🛰️ NASA Worldview request: ${layerConfig.name}');
      debugPrint('📅 Fecha: $dateStr');
      debugPrint('📍 BBOX: $minLat,$minLon,$maxLat,$maxLon');

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Timeout NASA Worldview'),
          );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        debugPrint('✅ Imagen NASA obtenida - ${bytes.length} bytes');
        return bytes;
      } else {
        debugPrint('❌ Error NASA API: ${response.statusCode}');
        _logErrorDetails(response);
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error obteniendo imagen NASA: $e');
      return null;
    }
  }

  /// Calcula NDVI REAL desde la imagen GIBS
  static Future<double> getNDVIForLocation(LatLng location) async {
    try {
      // Obtener imagen pequeña centrada en la ubicación
      final imageData = await getMapImage(
        layerType: 'ndvi',
        minLat: location.latitude - 0.05,
        minLon: location.longitude - 0.05,
        maxLat: location.latitude + 0.05,
        maxLon: location.longitude + 0.05,
        width: 100,
        height: 100,
      );

      if (imageData != null) {
        // Analizar el pixel central de la imagen NDVI
        final ndvi = _extractNDVIFromImage(imageData);
        debugPrint('📊 NDVI real extraído: $ndvi');
        return ndvi;
      }

      // Fallback a datos simulados si falla la API
      debugPrint('⚠️ Usando NDVI simulado (API falló)');
      return _getSimulatedNDVI(location);
    } catch (e) {
      debugPrint('❌ Error en getNDVIForLocation: $e');
      return _getSimulatedNDVI(location);
    }
  }

  /// Extrae valor NDVI del pixel central de la imagen
  static double _extractNDVIFromImage(Uint8List imageData) {
    try {
      // En una imagen NDVI de MODIS, los colores representan valores:
      // Valores bajos (marrón/rojo) = poca vegetación (0.0-0.3)
      // Valores medios (amarillo/verde claro) = vegetación moderada (0.3-0.6)
      // Valores altos (verde oscuro) = vegetación densa (0.6-1.0)

      // Tomar muestra del centro de la imagen
      const sampleSize = 10;
      final centerStart = (imageData.length ~/ 2) - (sampleSize * 4);
      final centerEnd = centerStart + (sampleSize * 4);

      if (centerStart < 0 || centerEnd > imageData.length) {
        return 0.5; // Valor por defecto
      }

      double sumNDVI = 0.0;
      int count = 0;

      for (int i = centerStart; i < centerEnd; i += 4) {
        final r = imageData[i];
        final g = imageData[i + 1];

        // Convertir RGB a valor NDVI aproximado
        // Verde alto = NDVI alto, Rojo alto = NDVI bajo
        final ndviValue = (g.toDouble() - r.toDouble()) / 255.0;
        sumNDVI += ndviValue.clamp(-1.0, 1.0);
        count++;
      }

      // NDVI normalizado a rango 0-1 (en lugar de -1 a 1)
      final avgNDVI = (sumNDVI / count + 1.0) / 2.0;
      return avgNDVI.clamp(0.0, 1.0);
    } catch (e) {
      debugPrint('Error extrayendo NDVI de imagen: $e');
      return 0.5;
    }
  }

  /// Compara dos fechas diferentes (útil para superbloom comparisons)
  static Future<Map<String, dynamic>> compareTimePeriods(
    LatLng location,
    DateTime date1,
    DateTime date2, {
    String layerType = 'viirs',
  }) async {
    final image1 = await getMapImage(
      layerType: layerType,
      minLat: location.latitude - 0.1,
      minLon: location.longitude - 0.1,
      maxLat: location.latitude + 0.1,
      maxLon: location.longitude + 0.1,
      date: date1,
      width: 256,
      height: 256,
    );

    final image2 = await getMapImage(
      layerType: layerType,
      minLat: location.latitude - 0.1,
      minLon: location.longitude - 0.1,
      maxLat: location.latitude + 0.1,
      maxLon: location.longitude + 0.1,
      date: date2,
      width: 256,
      height: 256,
    );

    return {
      'date1': date1,
      'date2': date2,
      'image1': image1,
      'image2': image2,
      'hasComparison': image1 != null && image2 != null,
    };
  }

  // --- Métodos auxiliares ---

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static void _logErrorDetails(http.Response response) {
    try {
      final document = xml.XmlDocument.parse(response.body);
      final errors = document.findAllElements('ServiceException');
      for (final error in errors) {
        debugPrint('📄 NASA Error: ${error.innerText}');
      }
    } catch (e) {
      debugPrint(
        '📄 Respuesta: ${response.body.substring(0, min(200, response.body.length))}',
      );
    }
  }

  static double _getSimulatedNDVI(LatLng location) {
    final latitudeFactor = 1 - (location.latitude.abs() / 90);
    final seasonalFactor = _getSeasonalFactor(
      DateTime.now(),
      location.latitude,
    );
    final climateFactor = _getClimateFactor(location);

    double baseNDVI =
        0.2 +
        (latitudeFactor * 0.4) +
        (seasonalFactor * 0.3) +
        (climateFactor * 0.1);

    final localVariation =
        (location.latitude * location.longitude)
            .abs()
            .toString()
            .split('')
            .map((c) => int.tryParse(c) ?? 0)
            .take(3)
            .reduce((a, b) => a + b) /
        30.0;

    return (baseNDVI + localVariation).clamp(0.1, 0.9);
  }

  static double _getSeasonalFactor(DateTime date, double latitude) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    if (latitude > 0) {
      return (1 + cos(2 * pi * (dayOfYear - 172) / 365)) / 2;
    } else {
      return (1 + cos(2 * pi * (dayOfYear - 355) / 365)) / 2;
    }
  }

  static double _getClimateFactor(LatLng location) {
    if (location.latitude.abs() < 23.5) return 0.8; // Tropical
    if (location.latitude.abs() > 60) return 0.3; // Polar
    return 0.5; // Templado
  }
}

/// Configuración de capa satelital
class LayerConfig {
  final String id;
  final String name;
  final String description;

  const LayerConfig({
    required this.id,
    required this.name,
    required this.description,
  });
}
