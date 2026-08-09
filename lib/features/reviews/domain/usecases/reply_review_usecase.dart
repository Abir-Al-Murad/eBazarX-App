

import 'package:ebazarx/features/reviews/domain/entities/review_reply_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class ReplyReviewUseCase {
  final ReviewRepository repository;

  const ReplyReviewUseCase(this.repository);

  Future<ReviewReplyEntity> call({
    required String reviewId,
    required String reply,
  }) {
    return repository.replyToReview(
      reviewId: reviewId,
      reply: reply,
    );
  }
}