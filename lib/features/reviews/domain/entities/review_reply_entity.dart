import 'package:equatable/equatable.dart';

class ReviewReplyEntity extends Equatable {
  final String id;
  final String reviewId;
  final String sellerId;

  final String reply;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewReplyEntity({
    required this.id,
    required this.reviewId,
    required this.sellerId,
    required this.reply,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    reviewId,
    sellerId,
    reply,
    createdAt,
    updatedAt,
  ];
}