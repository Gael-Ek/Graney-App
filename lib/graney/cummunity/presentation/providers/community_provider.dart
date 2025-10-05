import 'package:flutter/material.dart';
import '../../domain/entities/forum_post_entity.dart';
import '../../domain/entities/community_photo_entity.dart';
import '../../infrastructure/services/community_service.dart';

class CommunityProvider extends ChangeNotifier {
  List<ForumPostEntity> _posts = [];
  List<CommunityPhotoEntity> _photos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ForumPostEntity> get posts => _posts;
  List<CommunityPhotoEntity> get photos => _photos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadForumPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await CommunityService.getForumPosts();
    } catch (e) {
      _errorMessage = 'Error cargando posts: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCommunityPhotos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _photos = await CommunityService.getCommunityPhotos();
    } catch (e) {
      _errorMessage = 'Error cargando fotos: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(ForumPostEntity post) async {
    try {
      await CommunityService.createPost(post);
      await loadForumPosts();
    } catch (e) {
      _errorMessage = 'Error creando post: $e';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }
}
