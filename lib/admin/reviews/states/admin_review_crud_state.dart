import 'package:equatable/equatable.dart';

import '../../../core/failures/failure.dart';
import '../../../features/reviews/domain/entities/review_entity.dart';
import '../../../features/reviews/domain/entities/review_report_entity.dart';

class AdminReviewCrudState extends Equatable {
  // ============================================================
  // LOADING
  // ============================================================

  final bool isDeleting;
  final bool isHiding;
  final bool isResolvingReport;

  // ============================================================
  // SELECTED DATA
  // ============================================================

  final ReviewEntity? selectedReview;
  final ReviewReportEntity? selectedReport;

  // ============================================================
  // ERROR
  // ============================================================

  final Failure? failure;

  const AdminReviewCrudState({
    this.isDeleting = false,
    this.isHiding = false,
    this.isResolvingReport = false,

    this.selectedReview,
    this.selectedReport,

    this.failure,
  });

  bool get isLoading =>
      isDeleting ||
          isHiding ||
          isResolvingReport;

  bool get isFailure => failure != null;

  AdminReviewCrudState copyWith({
    bool? isDeleting,
    bool? isHiding,
    bool? isResolvingReport,

    ReviewEntity? selectedReview,
    ReviewReportEntity? selectedReport,

    Failure? failure,

    bool clearFailure = false,
    bool clearSelectedReview = false,
    bool clearSelectedReport = false,
  }) {
    return AdminReviewCrudState(
      isDeleting:
      isDeleting ?? this.isDeleting,

      isHiding:
      isHiding ?? this.isHiding,

      isResolvingReport:
      isResolvingReport ?? this.isResolvingReport,

      selectedReview: clearSelectedReview
          ? null
          : selectedReview ?? this.selectedReview,

      selectedReport: clearSelectedReport
          ? null
          : selectedReport ?? this.selectedReport,

      failure: clearFailure
          ? null
          : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    isDeleting,
    isHiding,
    isResolvingReport,
    selectedReview,
    selectedReport,
    failure,
  ];
}