import 'package:equatable/equatable.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';

class SellerCouponListState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;

  final int skip;
  final int limit;
  final bool hasMore;

  final List<AdminCouponEntity> coupons;

  final Failure? failure;

  const SellerCouponListState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.skip = 0,
    this.limit = 20,
    this.hasMore = true,
    this.coupons = const [],
    this.failure,
  });

  SellerCouponListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    int? skip,
    int? limit,
    bool? hasMore,
    List<AdminCouponEntity>? coupons,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return SellerCouponListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      coupons: coupons ?? this.coupons,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    isRefreshing,
    skip,
    limit,
    hasMore,
    coupons,
    failure,
  ];
}