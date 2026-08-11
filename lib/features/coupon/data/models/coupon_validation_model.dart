import 'package:ebazarx/features/coupon/domain/entities/coupon_entity.dart';

class CouponValidationModel {
  final String? couponId;
  final double discountAmount;
  final bool valid;
  final String? message;

  const CouponValidationModel({
    required this.couponId,
    required this.discountAmount,
    required this.valid,
    required this.message,
  });

  factory CouponValidationModel.fromJson(Map<String, dynamic> json) {
    return CouponValidationModel(
      couponId: json['coupon_id']?.toString(),
      discountAmount:
          double.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0,
      valid: json['valid'] ?? false,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupon_id': couponId,
      'discount_amount': discountAmount,
      'valid': valid,
      'message': message,
    };
  }

  CouponValidationEntity toEntity() {
    return CouponValidationEntity(
      couponId: couponId,
      discountAmount: discountAmount,
      valid: valid,
      message: message ?? '',
    );
  }

  factory CouponValidationModel.fromEntity(CouponValidationEntity entity) {
    return CouponValidationModel(
      couponId: entity.couponId,
      discountAmount: entity.discountAmount,
      valid: entity.valid,
      message: entity.message,
    );
  }
}
