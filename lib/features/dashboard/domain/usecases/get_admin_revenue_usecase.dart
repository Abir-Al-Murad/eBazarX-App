

import 'package:ebazarx/features/dashboard/domain/entities/admin_revenue.dart';
import 'package:ebazarx/features/dashboard/domain/repositories/admin_dashboard_repository.dart';

class GetAdminRevenueUseCase {
  final AdminDashboardRepository repository;


  GetAdminRevenueUseCase(this.repository);

  Future<List<AdminRevenue>> call({
    int days = 30,
  }) {
    return repository.getRevenue(
      days: days,
    );
  }
}