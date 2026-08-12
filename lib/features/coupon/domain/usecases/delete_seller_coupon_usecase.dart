import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class DeleteSellerCouponUseCase {
  final CouponRepository _repository;

  DeleteSellerCouponUseCase(this._repository);

  Future<void> call({
    required String couponId,
  }) {
    return _repository.deleteSellerCoupon(
      couponId: couponId,
    );
  }
}