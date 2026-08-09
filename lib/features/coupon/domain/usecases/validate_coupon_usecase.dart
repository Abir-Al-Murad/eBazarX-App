import 'package:ebazarx/features/coupon/domain/entities/coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class ValidateCouponUseCase {
  final CouponRepository _couponRepository;
  ValidateCouponUseCase(this._couponRepository);
  Future<CouponEntity> call({
    required String couponCode,
    required double subtotal,
    required String userId,
  }){
    return _couponRepository.validateCoupon(
      couponCode: couponCode,
      subtotal: subtotal,
      userId: userId,
    );
  }
}