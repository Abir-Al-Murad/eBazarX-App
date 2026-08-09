import '../repositories/review_repository.dart';

class VoteReviewUseCase {
  final ReviewRepository repository;

  const VoteReviewUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String reviewId,
    required String voteType,
  }) {
    return repository.voteReview(
      reviewId: reviewId,
      voteType: voteType,
    );
  }
}