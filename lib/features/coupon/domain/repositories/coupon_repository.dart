import 'package:ebazarx/features/coupon/domain/entities/coupon_entity.dart';

abstract class CouponRepository {

  Future<CouponEntity> validateCoupon({
    required String couponCode,
    required double subtotal,
    required String userId,
  });

}