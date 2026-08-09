

import 'package:ebazarx/features/dashboard/domain/entities/admin_recent_order.dart';

class AdminRecentOrderModel {
  final String id;
  final String orderNumber;
  final double grandTotal;
  final String orderStatus;
  final DateTime createdAt;
  final String? customerName;

  const AdminRecentOrderModel({
    required this.id,
    required this.orderNumber,
    required this.grandTotal,
    required this.orderStatus,
    required this.createdAt,
    this.customerName,
  });

  factory AdminRecentOrderModel.fromJson(Map<String, dynamic> json) {
    return AdminRecentOrderModel(
      id: json['id'].toString(),
      orderNumber: json['order_number']?.toString() ?? '',
      grandTotal: (json['grand_total'] ?? 0).toDouble(),
      orderStatus: json['order_status']?.toString() ?? 'pending',
      createdAt: DateTime.parse(json['created_at'].toString()),
      customerName: json['customer_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'grand_total': grandTotal,
      'order_status': orderStatus,
      'created_at': createdAt.toIso8601String(),
      'customer_name': customerName,
    };
  }

  AdminRecentOrder toEntity() {
    return AdminRecentOrder(
      id: id,
      orderNumber: orderNumber,
      grandTotal: grandTotal,
      orderStatus: orderStatus,
      createdAt: createdAt,
      customerName: customerName,
    );
  }

  factory AdminRecentOrderModel.fromEntity(AdminRecentOrder entity) {
    return AdminRecentOrderModel(
      id: entity.id,
      orderNumber: entity.orderNumber,
      grandTotal: entity.grandTotal,
      orderStatus: entity.orderStatus,
      createdAt: entity.createdAt,
      customerName: entity.customerName,
    );
  }
}
