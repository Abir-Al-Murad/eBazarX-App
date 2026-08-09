

import 'package:ebazarx/features/dashboard/domain/entities/admin_top_seller.dart';
import 'package:ebazarx/features/dashboard/domain/repositories/admin_dashboard_repository.dart';

class GetAdminTopSellersUseCase {
  final AdminDashboardRepository repository;

  GetAdminTopSellersUseCase(this.repository);

  Future<List<AdminTopSeller>> call({
    int limit = 5,
  }) {
    return repository.getTopSellers(
      limit: limit,
    );
  }
}