import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/coupon/domain/entities/coupon_entity.dart';


class ValidateCouponState {
  final bool isLoading;
  final Failure? failure;
  final CouponEntity? coupon;
  final bool isValid;

  const ValidateCouponState({
    this.isLoading = false,
    this.failure,
    this.coupon,
    this.isValid = false,
  });

  ValidateCouponState copyWith({
    bool? isLoading,
    Failure? failure,
    CouponEntity? coupon,
    bool? isValid,
    bool clearFailure = false,
    bool clearCoupon = false,
  }) {
    return ValidateCouponState(
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      coupon: clearCoupon ? null : (coupon ?? this.coupon),
      isValid: isValid ?? this.isValid,
    );
  }
}