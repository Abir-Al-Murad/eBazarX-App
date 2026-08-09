

import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class GetProductReviewsUseCase {
  final ReviewRepository repository;

  const GetProductReviewsUseCase(this.repository);

  Future<List<ReviewEntity>> call({
    required String productId,
    int skip = 0,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) {
    return repository.getProductReviews(
      productId: productId,
      skip: skip,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}