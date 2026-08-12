import 'package:equatable/equatable.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';

enum SellerCouponCrudStatus {
  initial,
  loading,
  success,
  failure,
}

class SellerCouponCrudState extends Equatable {
  final SellerCouponCrudStatus status;

  final AdminCouponEntity? coupon;

  final Failure? failure;

  const SellerCouponCrudState({
    this.status = SellerCouponCrudStatus.initial,
    this.coupon,
    this.failure,
  });

  bool get isLoading =>
      status == SellerCouponCrudStatus.loading;

  bool get isSuccess =>
      status == SellerCouponCrudStatus.success;

  bool get isFailure =>
      status == SellerCouponCrudStatus.failure;

  SellerCouponCrudState copyWith({
    SellerCouponCrudStatus? status,
    AdminCouponEntity? coupon,
    Failure? failure,
    bool clearCoupon = false,
    bool clearFailure = false,
  }) {
    return SellerCouponCrudState(
      status: status ?? this.status,
      coupon: clearCoupon
          ? null
          : (coupon ?? this.coupon),
      failure: clearFailure
          ? null
          : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
    status,
    coupon,
    failure,
  ];
}