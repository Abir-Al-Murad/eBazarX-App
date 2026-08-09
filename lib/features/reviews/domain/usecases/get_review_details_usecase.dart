

import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class GetReviewDetailsUseCase {
  final ReviewRepository repository;

  const GetReviewDetailsUseCase(this.repository);

  Future<ReviewEntity> call({
    required String productId,
    required String reviewId,
  }) {
    return repository.getReviewDetails(
      productId: productId,
      reviewId: reviewId,
    );
  }
}