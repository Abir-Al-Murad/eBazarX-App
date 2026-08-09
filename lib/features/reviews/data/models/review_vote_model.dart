import 'package:ebazarx/features/reviews/domain/entities/review_vote_entity.dart';

class ReviewVoteModel {
  final String reviewId;
  final String voteType;

  const ReviewVoteModel({
    required this.reviewId,
    required this.voteType,
  });

  factory ReviewVoteModel.fromJson(Map<String, dynamic> json) {
    return ReviewVoteModel(
      reviewId: json['review_id'] as String,
      voteType: json['vote_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'vote_type': voteType,
    };
  }

  ReviewVoteEntity toEntity() {
    return ReviewVoteEntity(
      reviewId: reviewId,
      voteType: voteType,
    );
  }

  factory ReviewVoteModel.fromEntity(ReviewVoteEntity entity) {
    return ReviewVoteModel(
      reviewId: entity.reviewId,
      voteType: entity.voteType,
    );
  }

  ReviewVoteModel copyWith({
    String? reviewId,
    String? userId,
    String? voteType,
    DateTime? createdAt,
  }) {
    return ReviewVoteModel(
      reviewId: reviewId ?? this.reviewId,

      voteType: voteType ?? this.voteType,

    );
  }
}