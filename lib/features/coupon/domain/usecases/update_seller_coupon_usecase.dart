import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/repositories/coupon_repository.dart';

class UpdateSellerCouponUseCase {
  final CouponRepository _repository;

  UpdateSellerCouponUseCase(this._repository);

  Future<AdminCouponEntity> call({
    required String couponId,
    String? code,
    String? description,
    String? discountType,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscount,
    int? usageLimit,
    int? perUserLimit,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? productIds,
    List<String>? categoryIds,
  }) {
    return _repository.updateSellerCoupon(
      couponId: couponId,
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
      productIds: productIds,
      categoryIds: categoryIds,
    );
  }
}