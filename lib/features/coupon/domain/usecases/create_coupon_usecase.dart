// features/coupon/domain/usecases/create_coupon_usecase.dart

import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class CreateCouponUseCase {
  final CouponRepository _repository;

  CreateCouponUseCase(this._repository);

  Future<AdminCouponEntity> call({
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    double? minOrderAmount,
    double? maxDiscount,
    int? usageLimit,
    int? perUserLimit,
    bool isActive = true,
    required DateTime startDate,
    required DateTime endDate,
    String? sellerId,
    List<String>? productIds,
    List<String>? categoryIds,
  }) async {
    return await _repository.createCoupon(
      code: code,
      description: description,
      discountType: discountType,
      discountValue: discountValue,
      minOrderAmount: minOrderAmount,
      maxDiscount: maxDiscount,
      usageLimit: usageLimit,
      perUserLimit: perUserLimit,
      isActive: isActive,
      startDate: startDate,
      endDate: endDate,
      sellerId: sellerId,
      productIds: productIds,
      categoryIds: categoryIds,
    );
  }
}