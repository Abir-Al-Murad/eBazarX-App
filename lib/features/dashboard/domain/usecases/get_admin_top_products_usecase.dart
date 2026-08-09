

import 'package:ebazarx/features/dashboard/domain/entities/admin_top_product.dart';
import 'package:ebazarx/features/dashboard/domain/repositories/admin_dashboard_repository.dart';

class GetAdminTopProductsUseCase {
  final AdminDashboardRepository repository;

  GetAdminTopProductsUseCase(this.repository);

  Future<List<AdminTopProduct>> call({
    int limit = 5,
  }) {
    return repository.getTopProducts(
      limit: limit,
    );
  }
}