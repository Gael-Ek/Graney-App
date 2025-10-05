enum BloomType {
  none,
  springWildflowers,
  tropical,
  australWildflowers,
  desertBloom,
  agricultural,
  superbloom, // ← NUEVO
  wildflower;

  String get displayName {
    switch (this) {
      case BloomType.none:
        return 'Sin Floración';
      case BloomType.springWildflowers:
        return 'Flores Silvestres de Primavera';
      case BloomType.tropical:
        return 'Floración Tropical';
      case BloomType.australWildflowers:
        return 'Flores Silvestres Australes';
      case BloomType.desertBloom:
        return 'Floración Desértica';
      case BloomType.agricultural:
        return 'Floración Agrícola';
      case BloomType.superbloom:
        return 'Superfloración'; // ← CORREGIDO
      case BloomType.wildflower:
        return 'Floración Silvestre';
    }
  }

  String get emoji {
    switch (this) {
      case BloomType.none:
        return '❌';
      case BloomType.springWildflowers:
        return '🌼';
      case BloomType.tropical:
        return '🌺';
      case BloomType.australWildflowers:
        return '💮';
      case BloomType.desertBloom:
        return '🌵';
      case BloomType.agricultural:
        return '🌾';
      case BloomType.superbloom:
        return '🌻🌄'; // ← EMOJI PARA SUPERBLOOM
      case BloomType.wildflower:
        return '🏵️';
    }
  }
}
