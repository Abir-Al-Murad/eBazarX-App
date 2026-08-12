// import 'package:ebazarx/core/failures/failure.dart';
// import 'package:ebazarx/features/reviews/domain/usecases/admin_delete_review_usecase.dart';
// import 'package:ebazarx/features/reviews/domain/usecases/admin_list_pending_reports_usecase.dart';
// import 'package:ebazarx/features/reviews/domain/usecases/admin_list_reviews_usecase.dart';
// import 'package:ebazarx/features/reviews/domain/usecases/admin_resolve_report_usecase.dart';
// import 'package:ebazarx/features/reviews/domain/usecases/admin_toggle_hide_review_usecase.dart';
// import 'package:ebazarx/features/reviews/presentation/states/admin_review_state.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class AdminReviewNotifier extends StateNotifier<AdminReviewState> {
//   final AdminListReviewsUseCase _listReviews;
//   final AdminDeleteReviewUseCase _deleteReview;
//   final AdminToggleHideReviewUseCase _toggleHideReview;
//   final AdminListPendingReportsUseCase _listReports;
//   final AdminResolveReportUseCase _resolveReport;
//
//   AdminReviewNotifier(
//       this._listReviews,
//       this._deleteReview,
//       this._toggleHideReview,
//       this._listReports,
//       this._resolveReport,
//       ) : super(const AdminReviewState());
//
//   //============================================================
//   // Load Reviews
//   //============================================================
//
//   Future<void> loadReviews({
//     bool forceRefresh = false,
//   }) async {
//     if (state.isLoadingReviews) return;
//
//     state = state.copyWith(
//       isLoadingReviews: true,
//       clearFailure: true,
//     );
//
//     try {
//       final reviews = await _listReviews(
//         skip: 0,
//         limit: state.reviewLimit,
//         productId: state.productId,
//         userId: state.userId,
//         isHidden: state.isHidden,
//         includeDeleted: state.includeDeleted,
//       );
//
//       state = state.copyWith(
//         isLoadingReviews: false,
//         reviews: reviews,
//         reviewSkip: reviews.length,
//         hasMoreReviews: reviews.length == state.reviewLimit,
//       );
//     } on Failure catch (e) {
//       state = state.copyWith(
//         isLoadingReviews: false,
//         failure: e,
//       );
//     } catch (_) {
//       state = state.copyWith(
//         isLoadingReviews: false,
//         failure: const UnknownFailure("Failed to load reviews"),
//       );
//     }
//   }
//
//   //============================================================
//   // Load More Reviews
//   //============================================================
//
//   Future<void> loadMoreReviews() async {
//     if (state.isLoadingMoreReviews) return;
//
//     if (!state.hasMoreReviews) return;
//
//     state = state.copyWith(
//       isLoadingMoreReviews: true,
//       clearFailure: true,
//     );
//
//     try {
//       final reviews = await _listReviews(
//         skip: state.reviewSkip,
//         limit: state.reviewLimit,
//         productId: state.productId,
//         userId: state.userId,
//         isHidden: state.isHidden,
//         includeDeleted: state.includeDeleted,
//       );
//
//       state = state.copyWith(
//         isLoadingMoreReviews: false,
//         reviews: [
//           ...state.reviews,
//           ...reviews,
//         ],
//         reviewSkip: state.reviewSkip + reviews.length,
//         hasMoreReviews: reviews.length == state.reviewLimit,
//       );
//     } on Failure catch (e) {
//       state = state.copyWith(
//         isLoadingMoreReviews: false,
//         failure: e,
//       );
//     } catch (_) {
//       state = state.copyWith(
//         isLoadingMoreReviews: false,
//         failure: const UnknownFailure(
//           "Failed to load more reviews",
//         ),
//       );
//     }
//   }
//
//   //============================================================
//   // Refresh Reviews
//   //============================================================
//
//   Future<void> refreshReviews() async {
//     state = state.copyWith(
//       isRefreshing: true,
//       reviewSkip: 0,
//       hasMoreReviews: true,
//       reviews: [],
//     );
//
//     await loadReviews();
//
//     state = state.copyWith(
//       isRefreshing: false,
//     );
//   }
//
//   Future<void> toggleHideReview(String reviewId) async {
//     state = state.copyWith(
//       isHiding: true,
//       clearFailure: true,
//     );
//
//     try {
//       final updated = await _toggleHideReview(reviewId);
//
//       final reviews = state.reviews.map((e) {
//         if (e.id == updated.id) return updated;
//         return e;
//       }).toList();
//
//       state = state.copyWith(
//         isHiding: false,
//         reviews: reviews,
//         selectedReview: updated,
//       );
//     } on Failure catch (e) {
//       state = state.copyWith(
//         isHiding: false,
//         failure: e,
//       );
//     } catch (_) {
//       state = state.copyWith(
//         isHiding: false,
//         failure: const UnknownFailure(
//           "Failed to update review",
//         ),
//       );
//     }
//   }
//
//   Future<void> deleteReview(String reviewId) async {
//     state = state.copyWith(
//       isDeleting: true,
//       clearFailure: true,
//     );
//
//     try {
//       await _deleteReview(reviewId);
//
//       final reviews = state.reviews
//           .where((e) => e.id != reviewId)
//           .toList();
//
//       state = state.copyWith(
//         isDeleting: false,
//         reviews: reviews,
//       );
//     } on Failure catch (e) {
//       state = state.copyWith(
//         isDeleting: false,
//         failure: e,
//       );
//     } catch (_) {
//       state = state.copyWith(
//         isDeleting: false,
//         failure: const UnknownFailure(
//           "Failed to delete review",
//         ),
//       );
//     }
//   }
//
//
//   Future<void> applyFilters({
//     String? productId,
//     String? userId,
//     bool? isHidden,
//     bool? includeDeleted,
//   }) async {
//     state = state.copyWith(
//       productId: productId,
//       userId: userId,
//       isHidden: isHidden,
//       includeDeleted: includeDeleted,
//       reviews: [],
//       reviewSkip: 0,
//       hasMoreReviews: true,
//     );
//
//     await loadReviews();
//   }
//
//   Future<void> resetFilters() async {
//     state = state.copyWith(
//       productId: null,
//       userId: null,
//       isHidden: null,
//       includeDeleted: null,
//       reviews: [],
//       reviewSkip: 0,
//       hasMoreReviews: true,
//     );
//
//     await loadReviews();
//   }
//
//   Future<void> loadReports() async {
//     if (state.isLoadingReports) return;
//
//     state = state.copyWith(
//       isLoadingReports: true,
//       clearFailure: true,
//     );
//
//     try {
//       final reports = await _listReports(
//         skip: 0,
//         limit: state.reportLimit,
//       );
//
//       state = state.copyWith(
//         isLoadingReports: false,
//         reports: reports,
//         reportSkip: reports.length,
//         hasMoreReports: reports.length == state.reportLimit,
//       );
//     } on Failure catch (e) {
//       state = state.copyWith(
//         isLoadingReports: false,
//         failure: e,
//       );
//     } catch (_) {
//       state = state.copyWith(
//         isLoadingReports: false,
//         failure: const UnknownFailure(
//           "Failed to load reports",
//         ),
//       );
//     }
//   }
//   Future<void> loadMoreReports() async {
//     if (state.isLoadingMoreReports) return;
//
//     if (!state.hasMoreReports) return;
//
//     state = state.copyWith(
//       isLoadingMoreReports: true,
//       clearFailure: true,
//     );
//
//     try {
//       final reports = await _listReports(
//         skip: state.reportSkip,
//         limit: state.reportLimit,
//       );
//
//       state = state.copyWith(
//         isLoadingMoreReports: false,
//         reports: [
//           ...state.reports,
//           ...reports,
//         ],
//         reportSkip: state.reportSkip + reports.length,
//         hasMoreReports: reports.length == state.reportLimit,
//       );
//     } on Failure catch (e) {
//       state = state.copyWith(
//         isLoadingMoreReports: false,
//         failure: e,
//       );
//     } catch (_) {
//       state = state.copyWith(
//         isLoadingMoreReports: false,
//         failure: const UnknownFailure(
//           "Failed to load more reports",
//         ),
//       );
//     }
//   }
//   Future<void> refreshReports() async {
//     state = state.copyWith(
//       isRefreshing: true,
//       reportSkip: 0,
//       hasMoreReports: true,
//       reports: [],
//     );
//
//     await loadReports();
//
//     state = state.copyWith(
//       isRefreshing: false,
//     );
//   }
//
//   Future<void> resolveReport(String reportId) async {
//     state = state.copyWith(
//       isResolvingReport: true,
//       clearFailure: true,
//     );
//
//     try {
//       final report = await _resolveReport(reportId);
//
//       final reports = state.reports.map((e) {
//         if (e.id == report.id) {
//           return report;
//         }
//         return e;
//       }).toList();
//
//       state = state.copyWith(
//         isResolvingReport: false,
//         reports: reports,
//         selectedReport: report,
//       );
//     } on Failure catch (e) {
//       state = state.copyWith(
//         isResolvingReport: false,
//         failure: e,
//       );
//     } catch (_) {
//       state = state.copyWith(
//         isResolvingReport: false,
//         failure: const UnknownFailure(
//           "Failed to resolve report",
//         ),
//       );
//     }
//   }
// }