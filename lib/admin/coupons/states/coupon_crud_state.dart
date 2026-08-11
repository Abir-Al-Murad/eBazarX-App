import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';

enum CouponCrudStatus {
  initial,
  loading,
  success,
  failure,
}

class CouponCrudState {
  final CouponCrudStatus status;

  final AdminCouponEntity? coupon;

  final Failure? failure;

  const CouponCrudState({
    this.status = CouponCrudStatus.initial,
    this.coupon,
    this.failure,
  });

  bool get isLoading => status == CouponCrudStatus.loading;

  bool get isSuccess => status == CouponCrudStatus.success;

  bool get hasError => status == CouponCrudStatus.failure;

  CouponCrudState copyWith({
    CouponCrudStatus? status,
    AdminCouponEntity? coupon,
    Failure? failure,
    bool clearCoupon = false,
    bool clearFailure = false,
  }) {
    return CouponCrudState(
      status: status ?? this.status,
      coupon: clearCoupon ? null : coupon ?? this.coupon,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}