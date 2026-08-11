import 'package:ebazarx/admin/dashboard/notifiers/admin_dashboard_notifier.dart';
import 'package:ebazarx/admin/dashboard/states/admin_dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ebazarx/core/network/api_client.dart';

import 'package:ebazarx/features/dashboard/data/datasources/admin_dashboard_remote_datasource.dart';
import 'package:ebazarx/features/dashboard/data/repositories/admin_dashboard_repository_impl.dart';

import 'package:ebazarx/features/dashboard/domain/repositories/admin_dashboard_repository.dart';

import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_dashboard_usecase.dart';
import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_recent_orders_usecase.dart';
import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_top_sellers_usecase.dart';
import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_top_products_usecase.dart';
import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_revenue_usecase.dart';

// ===========================================================
// REMOTE DATA SOURCE
// ===========================================================

final adminDashboardRemoteDataSourceProvider =
    Provider<AdminDashboardRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);

      return AdminDashboardRemoteDataSource(apiClient);
    });

// ===========================================================
// REPOSITORY
// ===========================================================

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((
  ref,
) {
  final remoteDataSource = ref.watch(adminDashboardRemoteDataSourceProvider);

  return AdminDashboardRepositoryImpl(remoteDataSource: remoteDataSource);
});

// ===========================================================
// USE CASES
// ===========================================================

final getAdminDashboardUseCaseProvider = Provider<GetAdminDashboardUseCase>((
  ref,
) {
  return GetAdminDashboardUseCase(ref.watch(adminDashboardRepositoryProvider));
});

final getAdminRecentOrdersUseCaseProvider =
    Provider<GetAdminRecentOrdersUseCase>((ref) {
      return GetAdminRecentOrdersUseCase(
        ref.watch(adminDashboardRepositoryProvider),
      );
    });

final getAdminTopSellersUseCaseProvider = Provider<GetAdminTopSellersUseCase>((
  ref,
) {
  return GetAdminTopSellersUseCase(ref.watch(adminDashboardRepositoryProvider));
});

final getAdminTopProductsUseCaseProvider = Provider<GetAdminTopProductsUseCase>(
  (ref) {
    return GetAdminTopProductsUseCase(
      ref.watch(adminDashboardRepositoryProvider),
    );
  },
);

final getAdminRevenueUseCaseProvider = Provider<GetAdminRevenueUseCase>((ref) {
  return GetAdminRevenueUseCase(ref.watch(adminDashboardRepositoryProvider));
});

// ===========================================================
// NOTIFIER
// ===========================================================

final adminDashboardNotifierProvider =
    StateNotifierProvider<AdminDashboardNotifier, AdminDashboardState>((ref) {
      return AdminDashboardNotifier(
        getDashboard: ref.watch(getAdminDashboardUseCaseProvider),
        getRecentOrders: ref.watch(getAdminRecentOrdersUseCaseProvider),
        getTopSellers: ref.watch(getAdminTopSellersUseCaseProvider),
        getTopProducts: ref.watch(getAdminTopProductsUseCaseProvider),
        getRevenue: ref.watch(getAdminRevenueUseCaseProvider),
      );
    });
