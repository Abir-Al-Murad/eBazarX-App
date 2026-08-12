import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:ebazarx/features/coupon/domain/usecases/get_seller_coupon_usecase.dart';
import 'package:ebazarx/seller/coupons/states/seller_coupon_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebazarx/core/failures/failure.dart';


class SellerCouponListNotifier
    extends StateNotifier<SellerCouponListState> {
  final GetSellerCouponsUseCase _getSellerCoupons;

  SellerCouponListNotifier(this._getSellerCoupons)
      : super(const SellerCouponListState());

  // ============================================================
  // LOAD COUPONS
  // ============================================================

  Future<void> loadCoupons() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
    );

    try {
      final coupons = await _getSellerCoupons(
        skip: 0,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoading: false,
        coupons: coupons,
        skip: coupons.length,
        hasMore: coupons.length == state.limit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ============================================================
  // LOAD MORE
  // ============================================================

  Future<void> loadMoreCoupons() async {
    if (state.isLoadingMore) return;
    if (!state.hasMore) return;

    state = state.copyWith(
      isLoadingMore: true,
      clearFailure: true,
    );

    try {
      final coupons = await _getSellerCoupons(
        skip: state.skip,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoadingMore: false,
        coupons: [
          ...state.coupons,
          ...coupons,
        ],
        skip: state.skip + coupons.length,
        hasMore: coupons.length == state.limit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshCoupons() async {
    state = state.copyWith(
      isRefreshing: true,
      skip: 0,
      hasMore: true,
      coupons: [],
      clearFailure: true,
    );

    await loadCoupons();

    state = state.copyWith(
      isRefreshing: false,
    );
  }

  // ============================================================
  // REMOVE COUPON LOCALLY
  // ============================================================

  void removeCoupon(String couponId) {
    state = state.copyWith(
      coupons: state.coupons
          .where((coupon) => coupon.id != couponId)
          .toList(),
    );
  }

  // ============================================================
  // UPDATE COUPON LOCALLY
  // ============================================================

  void updateCouponLocally(AdminCouponEntity updatedCoupon) {
    final coupons = state.coupons.map((coupon) {
      if (coupon.id == updatedCoupon.id) {
        return updatedCoupon;
      }
      return coupon;
    }).toList();

    state = state.copyWith(
      coupons: coupons,
    );
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const SellerCouponListState();
  }
}