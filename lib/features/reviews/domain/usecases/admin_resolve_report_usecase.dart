

import 'package:ebazarx/features/reviews/domain/entities/review_report_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class AdminResolveReportUseCase {
  final ReviewRepository repository;

  const AdminResolveReportUseCase(this.repository);

  Future<ReviewReportEntity> call(String reportId) {
    return repository.adminResolveReport(reportId);
  }
}