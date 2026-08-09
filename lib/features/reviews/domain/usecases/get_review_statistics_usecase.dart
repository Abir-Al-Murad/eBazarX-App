import 'package:ebazarx/features/reviews/domain/entities/review_statistics_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class GetReviewStatisticsUseCase {
  final ReviewRepository repository;

  const GetReviewStatisticsUseCase(this.repository);

  Future<ReviewStatisticsEntity> call(String productId) {
    return repository.getReviewStatistics(productId);
  }
}