

import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class AdminToggleHideReviewUseCase {
  final ReviewRepository repository;

  const AdminToggleHideReviewUseCase(this.repository);

  Future<ReviewEntity> call(String reviewId) {
    return repository.adminToggleHide(reviewId);
  }
}