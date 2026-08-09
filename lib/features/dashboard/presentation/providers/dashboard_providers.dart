
import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:ebazarx/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRemoteDataSourceProvider = Provider((ref) => DashboardRemoteDataSource(ref.read(apiClientProvider)));
final dashboardRepositoryProvider = Provider((ref) => DashboardRepositoryImpl(ref.read(dashboardRemoteDataSourceProvider)));
