import 'package:ebazarx/features/dashboard/domain/entities/admin_top_product.dart';

class AdminTopProductModel {
  final String productId;
  final String productName;
  final int totalSales;
  final double revenue;

  const AdminTopProductModel({
    required this.productId,
    required this.productName,
    required this.totalSales,
    required this.revenue,
  });

  factory AdminTopProductModel.fromJson(Map<String, dynamic> json) {
    return AdminTopProductModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      totalSales: json['total_sales'] ?? 0,
      revenue: double.tryParse(
        json['revenue']?.toString() ?? '0',
      ) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'total_sales': totalSales,
      'revenue': revenue,
    };
  }

  AdminTopProduct toEntity() {
    return AdminTopProduct(
      productId: productId,
      productName: productName,
      totalSales: totalSales,
      revenue: revenue,
    );
  }

  factory AdminTopProductModel.fromEntity(AdminTopProduct entity) {
    return AdminTopProductModel(
      productId: entity.productId,
      productName: entity.productName,
      totalSales: entity.totalSales,
      revenue: entity.revenue,
    );
  }
}
