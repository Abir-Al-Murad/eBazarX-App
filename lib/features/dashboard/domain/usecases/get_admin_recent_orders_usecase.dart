

import 'package:ebazarx/features/dashboard/domain/entities/admin_recent_order.dart';
import 'package:ebazarx/features/dashboard/domain/repositories/admin_dashboard_repository.dart';

class GetAdminRecentOrdersUseCase {
  final AdminDashboardRepository repository;

  GetAdminRecentOrdersUseCase(this.repository);

  Future<List<AdminRecentOrder>> call({
    int limit = 10,
  }) {
    return repository.getRecentOrders(
      limit: limit,
    );
  }
}