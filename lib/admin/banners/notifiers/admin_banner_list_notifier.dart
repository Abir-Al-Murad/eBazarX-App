import 'package:ebazarx/admin/banners/states/admin_banner_list_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/banner/domain/usecases/list_admin_banners_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminBannerListNotifier extends StateNotifier<AdminBannerListState> {
  static const int _pageSize = 20;

  final ListAdminBannersUseCase _listAdminBannersUseCase;

  AdminBannerListNotifier(this._listAdminBannersUseCase)
    : super(AdminBannerListState());

  // ------------------------------------------------------------
  // Initial fetch / refresh
  // ------------------------------------------------------------
  Future<void> fetchBanners({bool refresh = false}) async {
    // Prevent duplicate requests
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      hasMore: refresh ? true : state.hasMore,
    );

    try {
      final result = await _listAdminBannersUseCase(skip: 0, limit: _pageSize);

      state = state.copyWith(
        isLoading: false,
        banners: result,
        hasMore: result.length == _pageSize,
        isLoadingMore: false,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    } catch (e, s) {
      debugPrint('fetchBanners error: $e');
      debugPrintStack(stackTrace: s);

      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ------------------------------------------------------------
  // Load more banners
  // ------------------------------------------------------------
  Future<void> loadMore() async {
    // Don't load if:
    // 1. Initial request is running
    // 2. Another pagination request is running
    // 3. Server says there is no more data
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final result = await _listAdminBannersUseCase(
        skip: state.banners.length,
        limit: _pageSize,
      );

      final updatedBanners = [...state.banners, ...result];

      state = state.copyWith(
        isLoadingMore: false,
        banners: updatedBanners,
        hasMore: result.length == _pageSize,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoadingMore: false, failure: e);
    } catch (e, s) {
      debugPrint('loadMore banners error: $e');
      debugPrintStack(stackTrace: s);

      state = state.copyWith(
        isLoadingMore: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ------------------------------------------------------------
  // Refresh
  // ------------------------------------------------------------
  Future<void> refresh() async {
    await fetchBanners(refresh: true);
  }

  // ------------------------------------------------------------
  // Clear state
  // ------------------------------------------------------------
  void clear() {
    state = AdminBannerListState();
  }
}
