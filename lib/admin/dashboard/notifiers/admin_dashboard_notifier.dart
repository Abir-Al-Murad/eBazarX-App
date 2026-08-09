import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_dashboard_usecase.dart';
import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_recent_orders_usecase.dart';
import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_revenue_usecase.dart';
import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_top_products_usecase.dart';
import 'package:ebazarx/features/dashboard/domain/usecases/get_admin_top_sellers_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebazarx/core/failures/failure.dart';


import '../states/admin_dashboard_state.dart';

class AdminDashboardNotifier extends StateNotifier<AdminDashboardState> {
  final GetAdminDashboardUseCase _getDashboard;
  final GetAdminRecentOrdersUseCase _getRecentOrders;
  final GetAdminTopSellersUseCase _getTopSellers;
  final GetAdminTopProductsUseCase _getTopProducts;
  final GetAdminRevenueUseCase _getRevenue;

  AdminDashboardNotifier({
    required GetAdminDashboardUseCase getDashboard,
    required GetAdminRecentOrdersUseCase getRecentOrders,
    required GetAdminTopSellersUseCase getTopSellers,
    required GetAdminTopProductsUseCase getTopProducts,
    required GetAdminRevenueUseCase getRevenue,
  }) : _getDashboard = getDashboard,
       _getRecentOrders = getRecentOrders,
       _getTopSellers = getTopSellers,
       _getTopProducts = getTopProducts,
       _getRevenue = getRevenue,
       super(const AdminDashboardState());

  // ===========================================================
  // LOAD EVERYTHING
  // ===========================================================

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    try {
      final results = await Future.wait([
        _getDashboard(),
        _getRecentOrders(),
        _getTopSellers(),
        _getTopProducts(),
        _getRevenue(),
      ]);

      state = state.copyWith(
        isLoading: false,
        stats: results[0] as dynamic,
        recentOrders: results[1] as dynamic,
        topSellers: results[2] as dynamic,
        topProducts: results[3] as dynamic,
        revenue: results[4] as dynamic,
        clearFailure: true,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ===========================================================
  // REFRESH
  // ===========================================================

  Future<void> refreshDashboard() async {
    state = state.copyWith(isRefreshing: true, clearFailure: true);

    try {
      final results = await Future.wait([
        _getDashboard(),
        _getRecentOrders(),
        _getTopSellers(),
        _getTopProducts(),
        _getRevenue(),
      ]);

      state = state.copyWith(
        isRefreshing: false,
        stats: results[0] as dynamic,
        recentOrders: results[1] as dynamic,
        topSellers: results[2] as dynamic,
        topProducts: results[3] as dynamic,
        revenue: results[4] as dynamic,
        clearFailure: true,
      );
    } on Failure catch (e) {
      state = state.copyWith(isRefreshing: false, failure: e);
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ===========================================================
  // INDIVIDUAL LOADS
  // ===========================================================

  Future<void> loadRecentOrders({int limit = 10}) async {
    try {
      final orders = await _getRecentOrders(limit: limit);

      state = state.copyWith(recentOrders: orders, clearFailure: true);
    } on Failure catch (e) {
      state = state.copyWith(failure: e);
    } catch (e) {
      state = state.copyWith(failure: UnknownFailure(e.toString()));
    }
  }

  Future<void> loadTopSellers({int limit = 5}) async {
    try {
      final sellers = await _getTopSellers(limit: limit);

      state = state.copyWith(topSellers: sellers, clearFailure: true);
    } on Failure catch (e) {
      state = state.copyWith(failure: e);
    } catch (e) {
      state = state.copyWith(failure: UnknownFailure(e.toString()));
    }
  }

  Future<void> loadTopProducts({int limit = 5}) async {
    try {
      final products = await _getTopProducts(limit: limit);

      state = state.copyWith(topProducts: products, clearFailure: true);
    } on Failure catch (e) {
      state = state.copyWith(failure: e);
    } catch (e) {
      state = state.copyWith(failure: UnknownFailure(e.toString()));
    }
  }

  Future<void> loadRevenue({int days = 30}) async {
    try {
      final revenue = await _getRevenue(days: days);

      state = state.copyWith(revenue: revenue, clearFailure: true);
    } on Failure catch (e) {
      state = state.copyWith(failure: e);
    } catch (e) {
      state = state.copyWith(failure: UnknownFailure(e.toString()));
    }
  }
}
