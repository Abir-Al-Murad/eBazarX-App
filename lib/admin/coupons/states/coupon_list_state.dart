import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';

class CouponListState {
  final List<AdminCouponEntity> coupons;

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  final Object? failure;

  const CouponListState({
    this.coupons = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.failure,
  });

  CouponListState copyWith({
    List<AdminCouponEntity>? coupons,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Object? failure,
    bool clearFailure = false,
  }) {
    return CouponListState(
      coupons: coupons ?? this.coupons,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}