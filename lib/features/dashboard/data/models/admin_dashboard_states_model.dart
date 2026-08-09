

import 'package:ebazarx/features/dashboard/domain/entities/admin_dashboard_stats_entity.dart';

class AdminDashboardStatsModel {
  final int totalOrders;
  final double totalRevenue;
  final int totalProducts;
  final int totalCustomers;
  final int totalSellers;

  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;

  final int totalReviews;
  final int totalCoupons;
  final int totalBanners;
  final int totalCategories;
  final int totalBrands;

  final int pendingSellers;
  final int pendingProducts;

  final int todayOrders;
  final double todayRevenue;

  const AdminDashboardStatsModel({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalProducts,
    required this.totalCustomers,
    required this.totalSellers,
    required this.pendingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.totalReviews,
    required this.totalCoupons,
    required this.totalBanners,
    required this.totalCategories,
    required this.totalBrands,
    required this.pendingSellers,
    required this.pendingProducts,
    required this.todayOrders,
    required this.todayRevenue,
  });

  factory AdminDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardStatsModel(
      totalOrders: json['total_orders'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      totalProducts: json['total_products'] ?? 0,
      totalCustomers: json['total_customers'] ?? 0,
      totalSellers: json['total_sellers'] ?? 0,

      pendingOrders: json['pending_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,

      totalReviews: json['total_reviews'] ?? 0,
      totalCoupons: json['total_coupons'] ?? 0,
      totalBanners: json['total_banners'] ?? 0,
      totalCategories: json['total_categories'] ?? 0,
      totalBrands: json['total_brands'] ?? 0,

      pendingSellers: json['pending_sellers'] ?? 0,
      pendingProducts: json['pending_products'] ?? 0,

      todayOrders: json['today_orders'] ?? 0,
      todayRevenue: (json['today_revenue'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'total_revenue': totalRevenue,
      'total_products': totalProducts,
      'total_customers': totalCustomers,
      'total_sellers': totalSellers,

      'pending_orders': pendingOrders,
      'completed_orders': completedOrders,
      'cancelled_orders': cancelledOrders,

      'total_reviews': totalReviews,
      'total_coupons': totalCoupons,
      'total_banners': totalBanners,
      'total_categories': totalCategories,
      'total_brands': totalBrands,

      'pending_sellers': pendingSellers,
      'pending_products': pendingProducts,

      'today_orders': todayOrders,
      'today_revenue': todayRevenue,
    };
  }

  AdminDashboardStats toEntity() {
    return AdminDashboardStats(
      totalOrders: totalOrders,
      totalRevenue: totalRevenue,
      totalProducts: totalProducts,
      totalCustomers: totalCustomers,
      totalSellers: totalSellers,

      pendingOrders: pendingOrders,
      completedOrders: completedOrders,
      cancelledOrders: cancelledOrders,

      totalReviews: totalReviews,
      totalCoupons: totalCoupons,
      totalBanners: totalBanners,
      totalCategories: totalCategories,
      totalBrands: totalBrands,

      pendingSellers: pendingSellers,
      pendingProducts: pendingProducts,

      todayOrders: todayOrders,
      todayRevenue: todayRevenue,
    );
  }

  factory AdminDashboardStatsModel.fromEntity(AdminDashboardStats entity) {
    return AdminDashboardStatsModel(
      totalOrders: entity.totalOrders,
      totalRevenue: entity.totalRevenue,
      totalProducts: entity.totalProducts,
      totalCustomers: entity.totalCustomers,
      totalSellers: entity.totalSellers,

      pendingOrders: entity.pendingOrders,
      completedOrders: entity.completedOrders,
      cancelledOrders: entity.cancelledOrders,

      totalReviews: entity.totalReviews,
      totalCoupons: entity.totalCoupons,
      totalBanners: entity.totalBanners,
      totalCategories: entity.totalCategories,
      totalBrands: entity.totalBrands,

      pendingSellers: entity.pendingSellers,
      pendingProducts: entity.pendingProducts,

      todayOrders: entity.todayOrders,
      todayRevenue: entity.todayRevenue,
    );
  }
}
