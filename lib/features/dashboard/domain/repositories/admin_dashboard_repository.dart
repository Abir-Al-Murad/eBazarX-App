

import 'package:ebazarx/features/dashboard/domain/entities/admin_dashboard_stats_entity.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_recent_order.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_revenue.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_product.dart';
import 'package:ebazarx/features/dashboard/domain/entities/admin_top_seller.dart';

abstract class AdminDashboardRepository {
  Future<AdminDashboardStats> getDashboard();

  Future<List<AdminRecentOrder>> getRecentOrders({
    int limit = 10,
  });

  Future<List<AdminTopSeller>> getTopSellers({
    int limit = 5,
  });

  Future<List<AdminTopProduct>> getTopProducts({
    int limit = 5,
  });

  Future<List<AdminRevenue>> getRevenue({
    int days = 30,
  });
}