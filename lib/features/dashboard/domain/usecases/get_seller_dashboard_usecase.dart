import 'package:ebazarx/features/dashboard/domain/entities/dashboad_entity.dart';
import 'package:ebazarx/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetSellerDashboardUseCase {
  final DashboardRepository _repository;
  GetSellerDashboardUseCase(this._repository);

  Future<DashboardEntity> call() async {
    return _repository.getDashboard();
  }
}