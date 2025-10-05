// application/community/domain/entities/community_photo_entity.dart
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/shared/enums/vegetation_type.dart';

class CommunityPhotoEntity extends Equatable {
  final String id;
  final String user;
  final String description;
  final LatLng location;
  final DateTime date;
  final int likes;
  final String imageUrl;
  final String bloomIntensity;
  final VegetationType vegetationType;

  const CommunityPhotoEntity({
    required this.id,
    required this.user,
    required this.description,
    required this.location,
    required this.date,
    required this.likes,
    required this.imageUrl,
    required this.bloomIntensity,
    required this.vegetationType,
  });

  @override
  List<Object?> get props => [id, user, date];
}
