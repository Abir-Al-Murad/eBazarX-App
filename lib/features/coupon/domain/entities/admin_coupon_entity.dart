import 'package:equatable/equatable.dart';

class AdminCouponEntity extends Equatable {
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

  const AdminCouponEntity({
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

  @override
  List<Object?> get props => [
    id,
    code,
    description,
    discountType,
    discountValue,
    minOrderAmount,
    maxDiscount,
    usageLimit,
    perUserLimit,
    isActive,
    startDate,
    endDate,
    sellerId,
    usedCount,
    createdAt,
    updatedAt,
  ];
}
