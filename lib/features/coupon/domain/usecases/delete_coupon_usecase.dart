// features/coupon/domain/usecases/delete_coupon_usecase.dart

import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class DeleteCouponUseCase {
  final CouponRepository _repository;

  DeleteCouponUseCase(this._repository);

  Future<void> call({
    required String couponId,
  }) async {
    return await _repository.deleteCoupon(couponId: couponId);
  }
}