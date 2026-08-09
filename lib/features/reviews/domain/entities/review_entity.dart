import 'package:equatable/equatable.dart';

import 'review_image_entity.dart';
import 'review_reply_entity.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String? orderId;

  final int rating;
  final String? comment;

  final bool isVerified;
  final bool isHidden;

  final int likes;
  final int dislikes;

  final DateTime? editedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? userFullName;

  final List<ReviewImageEntity> images;
  final ReviewReplyEntity? reply;

  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    this.orderId,
    required this.rating,
    this.comment,
    required this.isVerified,
    required this.isHidden,
    required this.likes,
    required this.dislikes,
    this.editedAt,
    required this.createdAt,
    required this.updatedAt,
    this.userFullName,
    this.images = const [],
    this.reply,
  });

  ReviewEntity copyWith({
    String? id,
    String? productId,
    String? userId,
    String? orderId,
    int? rating,
    String? comment,
    bool? isVerified,
    bool? isHidden,
    int? likes,
    int? dislikes,
    DateTime? editedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userFullName,
    List<ReviewImageEntity>? images,
    ReviewReplyEntity? reply,
    bool clearReply = false,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isVerified: isVerified ?? this.isVerified,
      isHidden: isHidden ?? this.isHidden,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      editedAt: editedAt ?? this.editedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userFullName: userFullName ?? this.userFullName,
      images: images ?? this.images,
      reply: clearReply ? null : (reply ?? this.reply),
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    userId,
    orderId,
    rating,
    comment,
    isVerified,
    isHidden,
    likes,
    dislikes,
    editedAt,
    createdAt,
    updatedAt,
    userFullName,
    images,
    reply,
  ];
}