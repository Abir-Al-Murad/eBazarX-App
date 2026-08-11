import 'package:ebazarx/admin/coupons/states/coupon_list_state.dart';
import 'package:ebazarx/features/coupon/domain/usecases/get_all_coupons_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponListNotifier extends StateNotifier<CouponListState> {
  final GetAllCouponsUseCase _getAllCouponsUseCase;

  static const int _pageSize = 20;

  int _skip = 0;

  CouponListNotifier(this._getAllCouponsUseCase)
      : super(const CouponListState());

  // ============================================================
  // GET INITIAL COUPONS
  // ============================================================

  Future<void> getAllCoupons() async {
    if (state.isLoading) return;

    _skip = 0;

    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
    );

    try {
      final coupons = await _getAllCouponsUseCase(
        skip: 0,
        limit: _pageSize,
      );

      _skip = coupons.length;

      state = state.copyWith(
        coupons: coupons,
        isLoading: false,
        hasMore: coupons.length >= _pageSize,
        clearFailure: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    }
  }

  // ============================================================
  // LOAD MORE
  // ============================================================

  Future<void> loadMoreCoupons() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) {
      return;
    }

    state = state.copyWith(
      isLoadingMore: true,
    );

    try {
      final coupons = await _getAllCouponsUseCase(
        skip: _skip,
        limit: _pageSize,
      );

      _skip += coupons.length;

      state = state.copyWith(
        coupons: [
          ...state.coupons,
          ...coupons,
        ],
        isLoadingMore: false,
        hasMore: coupons.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: e,
      );
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refresh() async {
    await getAllCoupons();
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clear() {
    _skip = 0;

    state = const CouponListState();
  }
}