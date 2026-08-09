

import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class AdminListReviewsUseCase {
  final ReviewRepository repository;

  const AdminListReviewsUseCase(this.repository);

  Future<List<ReviewEntity>> call({
    int skip = 0,
    int limit = 20,
    String? productId,
    String? userId,
    bool? isHidden,
    bool? includeDeleted,
  }) {
    return repository.adminListReviews(
      skip: skip,
      limit: limit,
      productId: productId,
      userId: userId,
      isHidden: isHidden,
      includeDeleted: includeDeleted,
    );
  }
}