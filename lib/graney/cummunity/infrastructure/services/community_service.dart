import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/forum_post_entity.dart';
import '../../domain/entities/community_photo_entity.dart';
import '../../../../domain/shared/enums/bloom_type.dart';
import '../../../../domain/shared/enums/vegetation_type.dart';

class CommunityService {
  static Future<List<ForumPostEntity>> getForumPosts() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      ForumPostEntity(
        id: '1',
        user: 'María González',
        title: 'Floración masiva en Yucatán',
        content:
            'Esta semana observé una increíble floración de tajonal en la zona de Mérida. Los campos están completamente amarillos!',
        location: const LatLng(20.9674, -89.5926),
        date: DateTime.now().subtract(const Duration(days: 1)),
        likes: 24,
        comments: 8,
        imageUrl: 'https://example.com/floracion1.jpg',
        bloomType: BloomType.springWildflowers,
      ),
      ForumPostEntity(
        id: '2',
        user: 'Carlos Rodríguez',
        title: 'Cultivo de aguacate en floración',
        content:
            'Mis árboles de aguacate están en plena floración. ¿Alguien más está observando esto en la región?',
        location: const LatLng(19.4326, -99.1332),
        date: DateTime.now().subtract(const Duration(days: 3)),
        likes: 15,
        comments: 12,
        bloomType: BloomType.agricultural,
      ),
    ];
  }

  static Future<List<CommunityPhotoEntity>> getCommunityPhotos() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      CommunityPhotoEntity(
        id: '1',
        user: 'Ana Martínez',
        description: 'Floración de cempasúchil en Puebla',
        location: const LatLng(19.0414, -98.2063),
        date: DateTime.now().subtract(const Duration(days: 2)),
        likes: 42,
        imageUrl: 'https://example.com/photo1.jpg',
        bloomIntensity: 'alta',
        vegetationType: VegetationType.agricultural,
      ),
      CommunityPhotoEntity(
        id: '2',
        user: 'Roberto Sánchez',
        description: 'Bosque de coníferas en floración primaveral',
        location: const LatLng(19.1297, -99.2575),
        date: DateTime.now().subtract(const Duration(days: 5)),
        likes: 31,
        imageUrl: 'https://example.com/photo2.jpg',
        bloomIntensity: 'media',
        vegetationType: VegetationType.forest,
      ),
    ];
  }

  static Future<void> createPost(ForumPostEntity post) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simula envío a API
  }

  static Future<void> uploadPhoto(CommunityPhotoEntity photo) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simula upload de foto
  }
}
