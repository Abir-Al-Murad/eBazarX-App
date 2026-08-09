import 'package:ebazarx/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:ebazarx/features/dashboard/domain/entities/dashboad_entity.dart';
import 'package:ebazarx/features/dashboard/domain/repositories/dashboard_repository.dart';


class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<DashboardEntity> getDashboard() async {
    final model = await remoteDataSource.getDashboard();
    return model.toEntity();
  }
}