import 'package:ebazarx/features/reviews/data/models/review_image_model.dart';
import 'package:ebazarx/features/reviews/data/models/review_reply_model.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';

class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String? orderId;

  final int rating;
  final String? comment;

  final bool isVerified;
  final int likes;
  final int dislikes;
  final bool isHidden;

  final DateTime? editedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<ReviewImageModel> images;
  final ReviewReplyModel? reply;

  final String? userFullName;

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    this.orderId,
    required this.rating,
    this.comment,
    required this.isVerified,
    required this.likes,
    required this.dislikes,
    required this.isHidden,
    this.editedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    this.reply,
    this.userFullName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      orderId: json['order_id'],
      rating: json['rating'],
      comment: json['comment'],
      isVerified: json['is_verified'] ?? false,
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
      isHidden: json['is_hidden'] ?? false,
      editedAt: json['edited_at'] != null
          ? DateTime.parse(json['edited_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ReviewImageModel.fromJson(e))
          .toList(),
      reply: json['reply'] != null
          ? ReviewReplyModel.fromJson(json['reply'])
          : null,
      userFullName: json['user_full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'order_id': orderId,
      'rating': rating,
      'comment': comment,
      'is_verified': isVerified,
      'likes': likes,
      'dislikes': dislikes,
      'is_hidden': isHidden,
      'edited_at': editedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'images': images.map((e) => e.toJson()).toList(),
      'reply': reply?.toJson(),
      'user_full_name': userFullName,
    };
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      productId: productId,
      userId: userId,
      orderId: orderId,
      rating: rating,
      comment: comment,
      isVerified: isVerified,
      likes: likes,
      dislikes: dislikes,
      isHidden: isHidden,
      editedAt: editedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      images: images.map((e) => e.toEntity()).toList(),
      reply: reply?.toEntity(),
      userFullName: userFullName,
    );
  }

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      productId: entity.productId,
      userId: entity.userId,
      orderId: entity.orderId,
      rating: entity.rating,
      comment: entity.comment,
      isVerified: entity.isVerified,
      likes: entity.likes,
      dislikes: entity.dislikes,
      isHidden: entity.isHidden,
      editedAt: entity.editedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      images: entity.images
          .map((e) => ReviewImageModel.fromEntity(e))
          .toList(),
      reply: entity.reply != null
          ? ReviewReplyModel.fromEntity(entity.reply!)
          : null,
      userFullName: entity.userFullName,
    );
  }

  ReviewModel copyWith({
    String? id,
    String? productId,
    String? userId,
    String? orderId,
    int? rating,
    String? comment,
    bool? isVerified,
    int? likes,
    int? dislikes,
    bool? isHidden,
    DateTime? editedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ReviewImageModel>? images,
    ReviewReplyModel? reply,
    String? userFullName,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isVerified: isVerified ?? this.isVerified,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      isHidden: isHidden ?? this.isHidden,
      editedAt: editedAt ?? this.editedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      reply: reply ?? this.reply,
      userFullName: userFullName ?? this.userFullName,
    );
  }
}