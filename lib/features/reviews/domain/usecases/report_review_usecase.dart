

import 'package:ebazarx/features/reviews/domain/entities/review_report_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class ReportReviewUseCase {
  final ReviewRepository repository;

  const ReportReviewUseCase(this.repository);

  Future<ReviewReportEntity> call({
    required String reviewId,
    required String reason,
    String? description,
  }) {
    return repository.reportReview(
      reviewId: reviewId,
      reason: reason,
      description: description,
    );
  }
}