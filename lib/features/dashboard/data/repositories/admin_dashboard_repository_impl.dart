import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/dashboard/data/datasources/admin_dashboard_remote_datasource.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_dashboard_stats_entity.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_recent_order.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_revenue.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_product.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_seller.dart';
import 'package:ebazarx/features/dashboard/domain/repositories/admin_dashboard_repository.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminDashboardRemoteDataSource remoteDataSource;

  AdminDashboardRepositoryImpl({required this.remoteDataSource});

  // ===========================================================
  // DASHBOARD
  // ===========================================================

  @override
  Future<AdminDashboardStats> getDashboard() async {
    try {
      final model = await remoteDataSource.getDashboard();

      return model.toEntity();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  // ===========================================================
  // RECENT ORDERS
  // ===========================================================

  @override
  Future<List<AdminRecentOrder>> getRecentOrders({int limit = 10}) async {
    try {
      final models = await remoteDataSource.getRecentOrders(limit: limit);

      return models.map((model) => model.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  // ===========================================================
  // TOP SELLERS
  // ===========================================================

  @override
  Future<List<AdminTopSeller>> getTopSellers({int limit = 5}) async {
    try {
      final models = await remoteDataSource.getTopSellers(limit: limit);

      return models.map((model) => model.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  // ===========================================================
  // TOP PRODUCTS
  // ===========================================================

  @override
  Future<List<AdminTopProduct>> getTopProducts({int limit = 5}) async {
    try {
      final models = await remoteDataSource.getTopProducts(limit: limit);

      return models.map((model) => model.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  // ===========================================================
  // REVENUE
  // ===========================================================

  @override
  Future<List<AdminRevenue>> getRevenue({int days = 30}) async {
    try {
      final models = await remoteDataSource.getRevenue(days: days);

      return models.map((model) => model.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
