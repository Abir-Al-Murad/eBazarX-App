import 'package:equatable/equatable.dart';

class AdminDashboardStats extends Equatable {
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

  const AdminDashboardStats({
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

  @override
  // TODO: implement props
  List<Object?> get props => [ totalOrders, totalRevenue, totalProducts, totalCustomers, totalSellers, pendingOrders, completedOrders, cancelledOrders, totalReviews, totalCoupons, totalBanners, totalCategories, totalBrands, pendingSellers, pendingProducts, todayOrders, todayRevenue, ];
}