import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';



class UpdateReviewUseCase {
  final ReviewRepository repository;

  const UpdateReviewUseCase(this.repository);

  Future<ReviewEntity> call({
    required String reviewId,
    int? rating,
    String? comment,
    List<String>? images,
  }) {
    return repository.updateReview(
      reviewId: reviewId,
      rating: rating,
      comment: comment,
      images: images,
    );
  }
}