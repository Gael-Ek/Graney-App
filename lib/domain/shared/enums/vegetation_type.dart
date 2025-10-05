enum VegetationType {
  forest,
  desert,
  tropical,
  agricultural,
  grassland;

  String get displayName {
    switch (this) {
      case VegetationType.forest:
        return 'Bosque';
      case VegetationType.desert:
        return 'Desierto';
      case VegetationType.tropical:
        return 'Tropical';
      case VegetationType.agricultural:
        return 'Agrícola';
      case VegetationType.grassland:
        return 'pradera';
    }
  }

  String get emoji {
    switch (this) {
      case VegetationType.forest:
        return '🌲';
      case VegetationType.desert:
        return '🏜️';
      case VegetationType.tropical:
        return '🌴';
      case VegetationType.agricultural:
        return '🌾';
      case VegetationType.grassland:
        return '🌿';
    }
  }
}
