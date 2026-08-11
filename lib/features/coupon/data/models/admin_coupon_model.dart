import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';

class AdminCouponModel {
  final String id;
  final String code;
  final String? description;

  final String discountType;
  final double discountValue;

  final double? minOrderAmount;
  final double? maxDiscount;

  final int? usageLimit;
  final int? perUserLimit;

  final bool isActive;

  final DateTime startDate;
  final DateTime endDate;

  final String? sellerId;

  final int usedCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminCouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderAmount,
    required this.maxDiscount,
    required this.usageLimit,
    required this.perUserLimit,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.sellerId,
    required this.usedCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminCouponModel.fromJson(Map<String, dynamic> json) {
    return AdminCouponModel(
      id: json['id'].toString(),

      code: json['code'] ?? '',

      description: json['description']?.toString(),

      discountType: json['discount_type'] ?? '',

      discountValue:
          double.tryParse(json['discount_value']?.toString() ?? '0') ?? 0,

      minOrderAmount: json['min_order_amount'] == null
          ? null
          : double.tryParse(json['min_order_amount'].toString()),

      maxDiscount: json['max_discount'] == null
          ? null
          : double.tryParse(json['max_discount'].toString()),

      usageLimit: json['usage_limit'] == null
          ? null
          : int.tryParse(json['usage_limit'].toString()),

      perUserLimit: json['per_user_limit'] == null
          ? null
          : int.tryParse(json['per_user_limit'].toString()),

      isActive: json['is_active'] ?? true,

      startDate: DateTime.parse(json['start_date']),

      endDate: DateTime.parse(json['end_date']),

      sellerId: json['seller_id']?.toString(),

      usedCount: int.tryParse(json['used_count']?.toString() ?? '0') ?? 0,

      createdAt: DateTime.parse(json['created_at']),

      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_order_amount': minOrderAmount,
      'max_discount': maxDiscount,
      'usage_limit': usageLimit,
      'per_user_limit': perUserLimit,
      'is_active': isActive,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'seller_id': sellerId,
      'used_count': usedCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AdminCouponEntity toEntity() {
    return AdminCouponEntity(
      id: id,
      code: code,
      description: description,
      discountType: discountType,
      discountValue: discountValue,
      minOrderAmount: minOrderAmount,
      maxDiscount: maxDiscount,
      usageLimit: usageLimit,
      perUserLimit: perUserLimit,
      isActive: isActive,
      startDate: startDate,
      endDate: endDate,
      sellerId: sellerId,
      usedCount: usedCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory AdminCouponModel.fromEntity(AdminCouponEntity entity) {
    return AdminCouponModel(
      id: entity.id,
      code: entity.code,
      description: entity.description,
      discountType: entity.discountType,
      discountValue: entity.discountValue,
      minOrderAmount: entity.minOrderAmount,
      maxDiscount: entity.maxDiscount,
      usageLimit: entity.usageLimit,
      perUserLimit: entity.perUserLimit,
      isActive: entity.isActive,
      startDate: entity.startDate,
      endDate: entity.endDate,
      sellerId: entity.sellerId,
      usedCount: entity.usedCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
