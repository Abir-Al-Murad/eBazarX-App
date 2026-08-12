import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_delete_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_resolve_report_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_toggle_hide_review_usecase.dart';
import 'package:ebazarx/admin/reviews/states/admin_review_crud_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminReviewCrudNotifier
    extends StateNotifier<AdminReviewCrudState> {
  final AdminDeleteReviewUseCase _deleteReview;
  final AdminToggleHideReviewUseCase _toggleHideReview;
  final AdminResolveReportUseCase _resolveReport;

  AdminReviewCrudNotifier(
      this._deleteReview,
      this._toggleHideReview,
      this._resolveReport,
      ) : super(const AdminReviewCrudState());

  // ============================================================
  // TOGGLE HIDE REVIEW
  // ============================================================

  Future<bool> toggleHideReview(String reviewId) async {
    state = state.copyWith(
      isHiding: true,
      clearFailure: true,
    );

    try {
      final updatedReview =
      await _toggleHideReview(reviewId);

      state = state.copyWith(
        isHiding: false,
        selectedReview: updatedReview,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        isHiding: false,
        failure: e,
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        isHiding: false,
        failure: const UnknownFailure(
          'Failed to update review',
        ),
      );

      return false;
    }
  }

  // ============================================================
  // DELETE REVIEW
  // ============================================================

  Future<bool> deleteReview(String reviewId) async {
    state = state.copyWith(
      isDeleting: true,
      clearFailure: true,
    );

    try {
      await _deleteReview(reviewId);

      state = state.copyWith(
        isDeleting: false,
        clearSelectedReview: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        isDeleting: false,
        failure: e,
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        isDeleting: false,
        failure: const UnknownFailure(
          'Failed to delete review',
        ),
      );

      return false;
    }
  }

  // ============================================================
  // RESOLVE REPORT
  // ============================================================

  Future<bool> resolveReport(String reportId) async {
    state = state.copyWith(
      isResolvingReport: true,
      clearFailure: true,
    );

    try {
      final updatedReport =
      await _resolveReport(reportId);

      state = state.copyWith(
        isResolvingReport: false,
        selectedReport: updatedReport,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        isResolvingReport: false,
        failure: e,
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        isResolvingReport: false,
        failure: const UnknownFailure(
          'Failed to resolve report',
        ),
      );

      return false;
    }
  }

  // ============================================================
  // CLEAR SELECTED REVIEW
  // ============================================================

  void clearSelectedReview() {
    state = state.copyWith(
      clearSelectedReview: true,
    );
  }

  // ============================================================
  // CLEAR SELECTED REPORT
  // ============================================================

  void clearSelectedReport() {
    state = state.copyWith(
      clearSelectedReport: true,
    );
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {
    state = state.copyWith(
      clearFailure: true,
    );
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const AdminReviewCrudState();
  }
}