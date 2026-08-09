
import 'package:ebazarx/features/reviews/domain/entities/review_reply_entity.dart';

class ReviewReplyModel {
  final String id;
  final String reviewId;
  final String sellerId;
  final String reply;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewReplyModel({
    required this.id,
    required this.reviewId,
    required this.sellerId,
    required this.reply,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewReplyModel.fromJson(Map<String, dynamic> json) {
    return ReviewReplyModel(
      id: json['id'] as String,
      reviewId: json['review_id'] as String,
      sellerId: json['seller_id'] as String,
      reply: json['reply'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review_id': reviewId,
      'seller_id': sellerId,
      'reply': reply,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ReviewReplyEntity toEntity() {
    return ReviewReplyEntity(
      id: id,
      reviewId: reviewId,
      sellerId: sellerId,
      reply: reply,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ReviewReplyModel.fromEntity(ReviewReplyEntity entity) {
    return ReviewReplyModel(
      id: entity.id,
      reviewId: entity.reviewId,
      sellerId: entity.sellerId,
      reply: entity.reply,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ReviewReplyModel copyWith({
    String? id,
    String? reviewId,
    String? sellerId,
    String? reply,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewReplyModel(
      id: id ?? this.id,
      reviewId: reviewId ?? this.reviewId,
      sellerId: sellerId ?? this.sellerId,
      reply: reply ?? this.reply,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}