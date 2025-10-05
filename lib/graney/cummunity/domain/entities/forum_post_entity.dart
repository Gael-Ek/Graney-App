import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/shared/enums/bloom_type.dart';

class ForumPostEntity extends Equatable {
  final String id;
  final String user;
  final String title;
  final String content;
  final LatLng location;
  final DateTime date;
  final int likes;
  final int comments;
  final String? imageUrl;
  final BloomType bloomType;

  const ForumPostEntity({
    required this.id,
    required this.user,
    required this.title,
    required this.content,
    required this.location,
    required this.date,
    required this.likes,
    required this.comments,
    this.imageUrl,
    required this.bloomType,
  });

  @override
  List<Object?> get props => [id, user, title, date];
}
