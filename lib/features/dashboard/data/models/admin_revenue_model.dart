import 'package:ebazarx/features/dashboard/domain/entities/admin_revenue.dart';

class AdminRevenueModel {
  final String period;
  final double revenue;
  final int orders;

  const AdminRevenueModel({
    required this.period,
    required this.revenue,
    required this.orders,
  });

  factory AdminRevenueModel.fromJson(Map<String, dynamic> json) {
    return AdminRevenueModel(
      period: json['period']?.toString() ?? '',
      revenue: (json['revenue'] ?? 0).toDouble(),
      orders: json['orders'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'period': period, 'revenue': revenue, 'orders': orders};
  }

  AdminRevenue toEntity() {
    return AdminRevenue(period: period, revenue: revenue, orders: orders);
  }

  factory AdminRevenueModel.fromEntity(AdminRevenue entity) {
    return AdminRevenueModel(
      period: entity.period,
      revenue: entity.revenue,
      orders: entity.orders,
    );
  }
}
