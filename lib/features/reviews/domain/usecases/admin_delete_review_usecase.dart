import '../repositories/review_repository.dart';

class AdminDeleteReviewUseCase {
  final ReviewRepository repository;

  const AdminDeleteReviewUseCase(this.repository);

  Future<void> call(String reviewId) {
    return repository.adminDeleteReview(reviewId);
  }
}