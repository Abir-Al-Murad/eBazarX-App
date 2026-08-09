import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_dashboard_stats_entity.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_recent_order.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_revenue.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_product.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_seller.dart';

class AdminDashboardState {
  final bool isLoading;
  final bool isRefreshing;

  final AdminDashboardStats? stats;
  final List<AdminRecentOrder> recentOrders;
  final List<AdminTopSeller> topSellers;
  final List<AdminTopProduct> topProducts;
  final List<AdminRevenue> revenue;

  final Failure? failure;

  const AdminDashboardState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.stats,
    this.recentOrders = const [],
    this.topSellers = const [],
    this.topProducts = const [],
    this.revenue = const [],
    this.failure,
  });

  AdminDashboardState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    AdminDashboardStats? stats,
    List<AdminRecentOrder>? recentOrders,
    List<AdminTopSeller>? topSellers,
    List<AdminTopProduct>? topProducts,
    List<AdminRevenue>? revenue,
    Failure? failure,
    bool clearFailure = false,
    bool clearStats = false,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,

      stats: clearStats ? null : (stats ?? this.stats),

      recentOrders: recentOrders ?? this.recentOrders,
      topSellers: topSellers ?? this.topSellers,
      topProducts: topProducts ?? this.topProducts,
      revenue: revenue ?? this.revenue,

      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
