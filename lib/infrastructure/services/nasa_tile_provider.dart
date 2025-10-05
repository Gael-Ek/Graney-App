import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graney/graney/bloom_analysis/infrastructure/services/nasa_worldview_service.dart';

class NasaTileProvider extends TileProvider {
  final String layerType;
  final DateTime? date;
  final LatLng? targetLocation;
  final double maxDistance;

  NasaTileProvider({
    required this.layerType,
    this.date,
    this.targetLocation,
    this.maxDistance = 0.5,
  });

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    if (zoom == null || zoom < 3 || zoom > 12) {
      return _createTransparentTile();
    }

    try {
      final n = 1 << zoom;
      final lonMin = (x / n) * 360.0 - 180.0;
      final lonMax = ((x + 1) / n) * 360.0 - 180.0;
      final latMax = _tile2lat(y, zoom);
      final latMin = _tile2lat(y + 1, zoom);

      // Filtrar tiles muy lejanas a la ubicación objetivo
      if (targetLocation != null &&
          !_isTileNearLocation(latMin, lonMin, latMax, lonMax)) {
        return _createTransparentTile();
      }

      // ✅ USAR EL NUEVO SERVICIO NASA WORLDVIEW
      final imageBytes = await NasaWorldviewService.getMapImage(
        layerType: layerType,
        minLat: latMin,
        minLon: lonMin,
        maxLat: latMax,
        maxLon: lonMax,
        date: date,
        width: 256,
        height: 256,
      );

      if (imageBytes != null && imageBytes.length > 1000) {
        return Tile(256, 256, imageBytes);
      } else {
        return _createColoredFallbackTile();
      }
    } catch (e) {
      debugPrint('Error en tile ($x, $y, $zoom): $e');
      return _createColoredFallbackTile();
    }
  }

  bool _isTileNearLocation(
    double tileLatMin,
    double tileLonMin,
    double tileLatMax,
    double tileLonMax,
  ) {
    if (targetLocation == null) return true;

    final centerLat = (tileLatMin + tileLatMax) / 2;
    final centerLon = (tileLonMin + tileLonMax) / 2;

    final latDistance = (centerLat - targetLocation!.latitude).abs();
    final lonDistance = (centerLon - targetLocation!.longitude).abs();

    return latDistance <= maxDistance && lonDistance <= maxDistance;
  }

  double _tile2lat(int y, int z) {
    final n = 1 << z;
    final latRad = math.atan(_sinh(math.pi * (1 - 2 * y / n)));
    return latRad * 180.0 / math.pi;
  }

  double _sinh(double x) {
    return (math.exp(x) - math.exp(-x)) / 2;
  }

  Future<Tile> _createTransparentTile() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()..color = const ui.Color(0x00000000);
    canvas.drawRect(const ui.Rect.fromLTWH(0, 0, 256, 256), paint);
    final picture = recorder.endRecording();
    final img = await picture.toImage(256, 256);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return Tile(256, 256, byteData!.buffer.asUint8List());
  }

  Future<Tile> _createColoredFallbackTile() async {
    Color color;
    switch (layerType) {
      case 'ndvi':
      case 'evi':
        color = Colors.green.withValues(alpha: .3);
        break;
      case 'temperature':
        color = Colors.orange.withValues(alpha: .3);
        break;
      case 'landsat':
      case 'sentinel':
        color = Colors.blue.withValues(alpha: .3);
        break;
      case 'viirs':
        color = Colors.cyan.withValues(alpha: .3);
        break;
      default:
        color = Colors.grey.withValues(alpha: .3);
    }
    return _createColoredTile(color);
  }

  Future<Tile> _createColoredTile(Color color) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()..color = color;
    canvas.drawRect(const ui.Rect.fromLTWH(0, 0, 256, 256), paint);

    // Patrón de cuadrícula
    final patternPaint = ui.Paint()
      ..color = Colors.black.withValues(alpha: .1)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 256; i += 16) {
      canvas.drawLine(
        ui.Offset(i.toDouble(), 0),
        ui.Offset(i.toDouble(), 256),
        patternPaint,
      );
      canvas.drawLine(
        ui.Offset(0, i.toDouble()),
        ui.Offset(256, i.toDouble()),
        patternPaint,
      );
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(256, 256);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return Tile(256, 256, byteData!.buffer.asUint8List());
  }
}
