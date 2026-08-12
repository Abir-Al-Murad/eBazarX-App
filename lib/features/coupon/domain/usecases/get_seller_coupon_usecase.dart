import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class GetSellerCouponsUseCase {
  final CouponRepository _repository;

  GetSellerCouponsUseCase(this._repository);

  Future<List<AdminCouponEntity>> call({
    int skip = 0,
    int limit = 20,
  }) {
    return _repository.getSellerCoupons(
      skip: skip,
      limit: limit,
    );
  }
}