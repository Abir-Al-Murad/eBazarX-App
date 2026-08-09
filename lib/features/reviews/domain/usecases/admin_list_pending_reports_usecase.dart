

import 'package:ebazarx/features/reviews/domain/entities/review_report_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class AdminListPendingReportsUseCase {
  final ReviewRepository repository;

  const AdminListPendingReportsUseCase(this.repository);

  Future<List<ReviewReportEntity>> call({
    int skip = 0,
    int limit = 20,
  }) {
    return repository.adminListPendingReports(
      skip: skip,
      limit: limit,
    );
  }
}