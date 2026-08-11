// features/coupon/domain/usecases/get_coupon_by_id_usecase.dart

import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class GetCouponByIdUseCase {
  final CouponRepository _repository;

  GetCouponByIdUseCase(this._repository);

  Future<AdminCouponEntity> call({
    required String couponId,
  }) async {
    return await _repository.getCouponById(couponId: couponId);
  }
}