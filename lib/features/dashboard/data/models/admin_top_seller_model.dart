import 'package:ebazarx/features/dashboard/domain/entities/admin_top_seller.dart';

class AdminTopSellerModel {
  final String sellerId;
  final String shopName;
  final double totalRevenue;
  final int totalOrders;

  const AdminTopSellerModel({
    required this.sellerId,
    required this.shopName,
    required this.totalRevenue,
    required this.totalOrders,
  });

  factory AdminTopSellerModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdminTopSellerModel(
      sellerId: json['seller_id']?.toString() ?? '',
      shopName: json['shop_name']?.toString() ?? '',
      totalRevenue:
      double.tryParse(json['total_revenue']?.toString() ?? '0') ?? 0.0,
      totalOrders: json['total_orders'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seller_id': sellerId,
      'shop_name': shopName,
      'total_revenue': totalRevenue,
      'total_orders': totalOrders,
    };
  }

  AdminTopSeller toEntity() {
    return AdminTopSeller(
      sellerId: sellerId,
      shopName: shopName,
      totalRevenue: totalRevenue,
      totalOrders: totalOrders,
    );
  }

  factory AdminTopSellerModel.fromEntity(
      AdminTopSeller entity,
      ) {
    return AdminTopSellerModel(
      sellerId: entity.sellerId,
      shopName: entity.shopName,
      totalRevenue: entity.totalRevenue,
      totalOrders: entity.totalOrders,
    );
  }
}