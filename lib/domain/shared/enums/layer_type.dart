enum LayerType {
  truecolor,
  ndvi,
  temperature,
  evi;

  String get displayName {
    switch (this) {
      case LayerType.truecolor:
        return 'Color Verdadero';
      case LayerType.ndvi:
        return 'Índice de Vegetación (NDVI)';
      case LayerType.temperature:
        return 'Temperatura Superficial';
      case LayerType.evi:
        return 'Índice de Vegetación Mejorado';
    }
  }

  String get layerKey {
    switch (this) {
      case LayerType.truecolor:
        return 'truecolor';
      case LayerType.ndvi:
        return 'ndvi';
      case LayerType.temperature:
        return 'temperature';
      case LayerType.evi:
        return 'evi';
    }
  }
}
