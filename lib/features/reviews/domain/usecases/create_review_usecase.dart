

import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class CreateReviewUseCase {
  final ReviewRepository repository;

  const CreateReviewUseCase(this.repository);

  Future<ReviewEntity> call({
    required String productId,
    required String orderId,
    required int rating,
    String? comment,
    List<String>? images,
  }) {
    return repository.createReview(
      productId: productId,
      orderId: orderId,
      rating: rating,
      comment: comment,
      images: images,
    );
  }
}