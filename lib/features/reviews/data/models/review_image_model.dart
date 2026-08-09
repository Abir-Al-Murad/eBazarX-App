import 'package:ebazarx/features/reviews/domain/entities/review_image_entity.dart';

class ReviewImageModel {
  final String id;
  final String reviewId;
  final String url;
  final int sortOrder;
  final DateTime createdAt;

  const ReviewImageModel({
    required this.id,
    required this.reviewId,
    required this.url,
    required this.sortOrder,
    required this.createdAt,
  });

  factory ReviewImageModel.fromJson(Map<String, dynamic> json) {
    return ReviewImageModel(
      id: json['id'] as String,
      reviewId: json['review_id'] as String,
      url: json['url'] as String,
      sortOrder: json['sort_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review_id': reviewId,
      'url': url,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ReviewImageEntity toEntity() {
    return ReviewImageEntity(
      id: id,
      reviewId: reviewId,
      url: url,
      sortOrder: sortOrder,
      createdAt: createdAt,
    );
  }

  factory ReviewImageModel.fromEntity(ReviewImageEntity entity) {
    return ReviewImageModel(
      id: entity.id,
      reviewId: entity.reviewId,
      url: entity.url,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
    );
  }

  ReviewImageModel copyWith({
    String? id,
    String? reviewId,
    String? url,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return ReviewImageModel(
      id: id ?? this.id,
      reviewId: reviewId ?? this.reviewId,
      url: url ?? this.url,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}