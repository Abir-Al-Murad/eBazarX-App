

import 'package:ebazarx/features/dashboard/domain/entities/dashboad_entity.dart';

abstract class DashboardRepository {
  Future<DashboardEntity> getDashboard();
}