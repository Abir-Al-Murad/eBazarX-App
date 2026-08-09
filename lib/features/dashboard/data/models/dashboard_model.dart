import 'package:ebazarx/features/dashboard/domain/entities/dashboad_entity.dart';


class DashboardModel {
  final int totalOrders;
  final int completedOrders;
  final int pendingOrders;
  final int cancelledOrders;

  final double totalRevenue;

  final int totalProducts;
  final int activeProducts;

  final int totalReviews;
  final double averageRating;

  final double availableBalance;
  final double pendingBalance;
  final double pendingWithdrawals;

  const DashboardModel({
    required this.totalOrders,
    required this.completedOrders,
    required this.pendingOrders,
    required this.cancelledOrders,
    required this.totalRevenue,
    required this.totalProducts,
    required this.activeProducts,
    required this.totalReviews,
    required this.averageRating,
    required this.availableBalance,
    required this.pendingBalance,
    required this.pendingWithdrawals,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalOrders: json['total_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      totalProducts: json['total_products'] ?? 0,
      activeProducts: json['active_products'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      availableBalance: (json['available_balance'] ?? 0).toDouble(),
      pendingBalance: (json['pending_balance'] ?? 0).toDouble(),
      pendingWithdrawals: (json['pending_withdrawals'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'completed_orders': completedOrders,
      'pending_orders': pendingOrders,
      'cancelled_orders': cancelledOrders,
      'total_revenue': totalRevenue,
      'total_products': totalProducts,
      'active_products': activeProducts,
      'total_reviews': totalReviews,
      'average_rating': averageRating,
      'available_balance': availableBalance,
      'pending_balance': pendingBalance,
      'pending_withdrawals': pendingWithdrawals,
    };
  }

  DashboardEntity toEntity() {
    return DashboardEntity(
      totalOrders: totalOrders,
      completedOrders: completedOrders,
      pendingOrders: pendingOrders,
      cancelledOrders: cancelledOrders,
      totalRevenue: totalRevenue,
      totalProducts: totalProducts,
      activeProducts: activeProducts,
      totalReviews: totalReviews,
      averageRating: averageRating,
      availableBalance: availableBalance,
      pendingBalance: pendingBalance,
      pendingWithdrawals: pendingWithdrawals,
    );
  }

  factory DashboardModel.fromEntity(DashboardEntity entity) {
    return DashboardModel(
      totalOrders: entity.totalOrders,
      completedOrders: entity.completedOrders,
      pendingOrders: entity.pendingOrders,
      cancelledOrders: entity.cancelledOrders,
      totalRevenue: entity.totalRevenue,
      totalProducts: entity.totalProducts,
      activeProducts: entity.activeProducts,
      totalReviews: entity.totalReviews,
      averageRating: entity.averageRating,
      availableBalance: entity.availableBalance,
      pendingBalance: entity.pendingBalance,
      pendingWithdrawals: entity.pendingWithdrawals,
    );
  }
}