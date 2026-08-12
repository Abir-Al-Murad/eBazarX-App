import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class GetSellerCouponByIdUseCase {
  final CouponRepository _repository;

  GetSellerCouponByIdUseCase(this._repository);

  Future<AdminCouponEntity> call({
    required String couponId,
  }) {
    return _repository.getSellerCouponById(
      couponId: couponId,
    );
  }
}