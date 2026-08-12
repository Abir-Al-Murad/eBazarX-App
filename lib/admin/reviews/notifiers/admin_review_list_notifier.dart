
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_list_pending_reports_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_list_reviews_usecase.dart';
import 'package:ebazarx/admin/reviews/states/admin_review_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminReviewListNotifier
    extends StateNotifier<AdminReviewListState> {
  final AdminListReviewsUseCase _listReviews;
  final AdminListPendingReportsUseCase _listReports;

  AdminReviewListNotifier(
      this._listReviews,
      this._listReports,
      ) : super(const AdminReviewListState());

  // ============================================================
  // LOAD REVIEWS
  // ============================================================

  Future<void> loadReviews() async {
    if (state.isLoadingReviews) return;

    state = state.copyWith(
      isLoadingReviews: true,
      clearFailure: true,
    );

    try {
      final reviews = await _listReviews(
        skip: 0,
        limit: state.reviewLimit,
        productId: state.productId,
        userId: state.userId,
        isHidden: state.isHidden,
        includeDeleted: state.includeDeleted,
      );

      state = state.copyWith(
        isLoadingReviews: false,
        reviews: reviews,
        reviewSkip: reviews.length,
        hasMoreReviews:
        reviews.length == state.reviewLimit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoadingReviews: false,
        failure: e,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingReviews: false,
        failure: const UnknownFailure(
          'Failed to load reviews',
        ),
      );
    }
  }

  // ============================================================
  // LOAD MORE REVIEWS
  // ============================================================

  Future<void> loadMoreReviews() async {
    if (state.isLoadingMoreReviews) return;
    if (!state.hasMoreReviews) return;

    state = state.copyWith(
      isLoadingMoreReviews: true,
      clearFailure: true,
    );

    try {
      final reviews = await _listReviews(
        skip: state.reviewSkip,
        limit: state.reviewLimit,
        productId: state.productId,
        userId: state.userId,
        isHidden: state.isHidden,
        includeDeleted: state.includeDeleted,
      );

      state = state.copyWith(
        isLoadingMoreReviews: false,
        reviews: [
          ...state.reviews,
          ...reviews,
        ],
        reviewSkip:
        state.reviewSkip + reviews.length,
        hasMoreReviews:
        reviews.length == state.reviewLimit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoadingMoreReviews: false,
        failure: e,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingMoreReviews: false,
        failure: const UnknownFailure(
          'Failed to load more reviews',
        ),
      );
    }
  }

  // ============================================================
  // REFRESH REVIEWS
  // ============================================================

  Future<void> refreshReviews() async {
    state = state.copyWith(
      isRefreshingReviews: true,
      reviewSkip: 0,
      hasMoreReviews: true,
      reviews: [],
    );

    await loadReviews();

    state = state.copyWith(
      isRefreshingReviews: false,
    );
  }

  // ============================================================
  // LOAD REPORTS
  // ============================================================

  Future<void> loadReports() async {
    if (state.isLoadingReports) return;

    state = state.copyWith(
      isLoadingReports: true,
      clearFailure: true,
    );

    try {
      final reports = await _listReports(
        skip: 0,
        limit: state.reportLimit,
      );

      state = state.copyWith(
        isLoadingReports: false,
        reports: reports,
        reportSkip: reports.length,
        hasMoreReports:
        reports.length == state.reportLimit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoadingReports: false,
        failure: e,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingReports: false,
        failure: const UnknownFailure(
          'Failed to load reports',
        ),
      );
    }
  }

  // ============================================================
  // LOAD MORE REPORTS
  // ============================================================

  Future<void> loadMoreReports() async {
    if (state.isLoadingMoreReports) return;
    if (!state.hasMoreReports) return;

    state = state.copyWith(
      isLoadingMoreReports: true,
      clearFailure: true,
    );

    try {
      final reports = await _listReports(
        skip: state.reportSkip,
        limit: state.reportLimit,
      );

      state = state.copyWith(
        isLoadingMoreReports: false,
        reports: [
          ...state.reports,
          ...reports,
        ],
        reportSkip:
        state.reportSkip + reports.length,
        hasMoreReports:
        reports.length == state.reportLimit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoadingMoreReports: false,
        failure: e,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingMoreReports: false,
        failure: const UnknownFailure(
          'Failed to load more reports',
        ),
      );
    }
  }

  // ============================================================
  // REFRESH REPORTS
  // ============================================================

  Future<void> refreshReports() async {
    state = state.copyWith(
      isRefreshingReports: true,
      reportSkip: 0,
      hasMoreReports: true,
      reports: [],
    );

    await loadReports();

    state = state.copyWith(
      isRefreshingReports: false,
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Future<void> applyFilters({
    String? productId,
    String? userId,
    bool? isHidden,
    bool? includeDeleted,
  }) async {
    state = state.copyWith(
      productId: productId,
      userId: userId,
      isHidden: isHidden,
      includeDeleted: includeDeleted,
      reviews: [],
      reviewSkip: 0,
      hasMoreReviews: true,
    );

    await loadReviews();
  }

  // ============================================================
  // RESET FILTERS
  // ============================================================

  Future<void> resetFilters() async {
    state = state.copyWith(
      clearProductId: true,
      clearUserId: true,
      clearIsHidden: true,
      clearIncludeDeleted: true,
      reviews: [],
      reviewSkip: 0,
      hasMoreReviews: true,
    );

    await loadReviews();
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {
    state = state.copyWith(
      clearFailure: true,
    );
  }
}