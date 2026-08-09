import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/dashboard/data/models/admin_dashboard_states_model.dart';
import 'package:ebazarx/features/dashboard/data/models/admin_recent_order_model.dart';
import 'package:ebazarx/features/dashboard/data/models/admin_revenue_model.dart';
import 'package:ebazarx/features/dashboard/data/models/admin_top_product_model.dart';
import 'package:ebazarx/features/dashboard/data/models/admin_top_seller_model.dart';

class AdminDashboardRemoteDataSource {
  final ApiClient _apiClient;

  const AdminDashboardRemoteDataSource(this._apiClient);

  // ===========================================================
  // DASHBOARD
  // ===========================================================

  Future<AdminDashboardStatsModel> getDashboard() async {
    final response = await _apiClient.get(
      '/admin/dashboard/',
    );

    if (response.isSuccess) {
      return AdminDashboardStatsModel.fromJson(
        response.body,
      );
    }

    throw response.failure ??
        Exception(
          response.errorMessage ?? 'Failed to load admin dashboard',
        );
  }

  // ===========================================================
  // RECENT ORDERS
  // ===========================================================

  Future<List<AdminRecentOrderModel>> getRecentOrders({
    int limit = 10,
  }) async {
    final response = await _apiClient.get(
      '/admin/dashboard/recent-orders',
      queryParameters: {
        'limit': limit,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map(
            (e) => AdminRecentOrderModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList();
    }

    throw response.failure ??
        Exception(
          response.errorMessage ?? 'Failed to fetch recent orders',
        );
  }

  // ===========================================================
  // TOP SELLERS
  // ===========================================================

  Future<List<AdminTopSellerModel>> getTopSellers({
    int limit = 5,
  }) async {
    final response = await _apiClient.get(
      '/admin/dashboard/top-sellers',
      queryParameters: {
        'limit': limit,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map(
            (e) => AdminTopSellerModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList();
    }

    throw response.failure ??
        Exception(
          response.errorMessage ?? 'Failed to fetch top sellers',
        );
  }

  // ===========================================================
  // TOP PRODUCTS
  // ===========================================================

  Future<List<AdminTopProductModel>> getTopProducts({
    int limit = 5,
  }) async {
    final response = await _apiClient.get(
      '/admin/dashboard/top-products',
      queryParameters: {
        'limit': limit,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map(
            (e) => AdminTopProductModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList();
    }

    throw response.failure ??
        Exception(
          response.errorMessage ?? 'Failed to fetch top products',
        );
  }

  // ===========================================================
  // REVENUE
  // ===========================================================

  Future<List<AdminRevenueModel>> getRevenue({
    int days = 30,
  }) async {
    final response = await _apiClient.get(
      '/admin/dashboard/revenue',
      queryParameters: {
        'days': days,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map(
            (e) => AdminRevenueModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList();
    }

    throw response.failure ??
        Exception(
          response.errorMessage ?? 'Failed to fetch revenue',
        );
  }
}