

import 'package:ebazarx/features/dashboard/domain/entities/admin_dashboard_stats_entity.dart';
import 'package:ebazarx/features/dashboard/domain/repositories/admin_dashboard_repository.dart';

class GetAdminDashboardUseCase {
  final AdminDashboardRepository repository;

  GetAdminDashboardUseCase(this.repository);

  Future<AdminDashboardStats> call() {
    return repository.getDashboard();
  }
}