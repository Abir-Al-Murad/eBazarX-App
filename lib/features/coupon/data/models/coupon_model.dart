import 'package:ebazarx/features/coupon/domain/entities/coupon_entity.dart';

class CouponModel {
  final String? id;
  final double discountAmount;
  final bool valid;
  final String message;

  const CouponModel({
    required this.id,
    required this.discountAmount,
    required this.valid,
    required this.message,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['coupon_id'],
      discountAmount: double.parse(json['discount_amount'].toString()),
      valid: json['valid'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupon_id': id,
      'discount_amount': discountAmount,
      'valid': valid,
      'message': message,
    };
  }

  CouponEntity toEntity() {
    return CouponEntity(
      id: id,
      discountAmount: discountAmount,
        valid: valid,
      message: message,
    );
  }

  factory CouponModel.fromEntity(CouponEntity entity) {
    return CouponModel(
      id: entity.id,
      discountAmount: entity.discountAmount,
      valid: entity.valid,
      message: entity.message,
    );
  }
}