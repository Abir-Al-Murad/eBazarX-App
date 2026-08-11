// features/coupon/domain/usecases/get_all_coupons_usecase.dart

import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class GetAllCouponsUseCase {
  final CouponRepository _repository;

  GetAllCouponsUseCase(this._repository);

  Future<List<AdminCouponEntity>> call({
    int skip = 0,
    int limit = 20,
  }) async {
    return await _repository.getAllCoupons(
      skip: skip,
      limit: limit,
    );
  }
}