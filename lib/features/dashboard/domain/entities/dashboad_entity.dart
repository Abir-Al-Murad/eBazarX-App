import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
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

  const DashboardEntity({
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

  @override
  List<Object?> get props => [
    totalOrders,
    completedOrders,
    pendingOrders,
    cancelledOrders,
    totalRevenue,
    totalProducts,
    activeProducts,
    totalReviews,
    averageRating,
    availableBalance,
    pendingBalance,
    pendingWithdrawals,
  ];
}