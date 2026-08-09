import 'package:equatable/equatable.dart';

import '../../../../core/failures/failure.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/entities/review_report_entity.dart';

class AdminReviewState extends Equatable {
  //==================================================
  // Loading
  //==================================================

  final bool isLoadingReviews;
  final bool isLoadingMoreReviews;

  final bool isLoadingReports;
  final bool isLoadingMoreReports;

  final bool isRefreshing;

  final bool isDeleting;

  final bool isHiding;

  final bool isResolvingReport;

  //==================================================
  // Review Pagination
  //==================================================

  final int reviewSkip;

  final int reviewLimit;

  final bool hasMoreReviews;

  //==================================================
  // Report Pagination
  //==================================================

  final int reportSkip;

  final int reportLimit;

  final bool hasMoreReports;

  //==================================================
  // Filters
  //==================================================

  final String? productId;

  final String? userId;

  final bool? isHidden;

  final bool? includeDeleted;

  //==================================================
  // Data
  //==================================================

  final List<ReviewEntity> reviews;

  final List<ReviewReportEntity> reports;

  final ReviewEntity? selectedReview;

  final ReviewReportEntity? selectedReport;

  //==================================================
  // Error
  //==================================================

  final Failure? failure;

  const AdminReviewState({
    this.isLoadingReviews = false,
    this.isLoadingMoreReviews = false,
    this.isLoadingReports = false,
    this.isLoadingMoreReports = false,
    this.isRefreshing = false,
    this.isDeleting = false,
    this.isHiding = false,
    this.isResolvingReport = false,

    this.reviewSkip = 0,
    this.reviewLimit = 20,
    this.hasMoreReviews = true,

    this.reportSkip = 0,
    this.reportLimit = 20,
    this.hasMoreReports = true,

    this.productId,
    this.userId,
    this.isHidden,
    this.includeDeleted,

    this.reviews = const [],
    this.reports = const [],

    this.selectedReview,
    this.selectedReport,

    this.failure,
  });

  AdminReviewState copyWith({
    bool? isLoadingReviews,
    bool? isLoadingMoreReviews,
    bool? isLoadingReports,
    bool? isLoadingMoreReports,
    bool? isRefreshing,
    bool? isDeleting,
    bool? isHiding,
    bool? isResolvingReport,

    int? reviewSkip,
    int? reviewLimit,
    bool? hasMoreReviews,

    int? reportSkip,
    int? reportLimit,
    bool? hasMoreReports,

    String? productId,
    String? userId,
    bool? isHidden,
    bool? includeDeleted,

    List<ReviewEntity>? reviews,
    List<ReviewReportEntity>? reports,

    ReviewEntity? selectedReview,
    ReviewReportEntity? selectedReport,

    Failure? failure,

    bool clearFailure = false,
    bool clearSelectedReview = false,
    bool clearSelectedReport = false,
  }) {
    return AdminReviewState(
      isLoadingReviews:
      isLoadingReviews ?? this.isLoadingReviews,

      isLoadingMoreReviews:
      isLoadingMoreReviews ?? this.isLoadingMoreReviews,

      isLoadingReports:
      isLoadingReports ?? this.isLoadingReports,

      isLoadingMoreReports:
      isLoadingMoreReports ?? this.isLoadingMoreReports,

      isRefreshing:
      isRefreshing ?? this.isRefreshing,

      isDeleting:
      isDeleting ?? this.isDeleting,

      isHiding:
      isHiding ?? this.isHiding,

      isResolvingReport:
      isResolvingReport ?? this.isResolvingReport,

      reviewSkip:
      reviewSkip ?? this.reviewSkip,

      reviewLimit:
      reviewLimit ?? this.reviewLimit,

      hasMoreReviews:
      hasMoreReviews ?? this.hasMoreReviews,

      reportSkip:
      reportSkip ?? this.reportSkip,

      reportLimit:
      reportLimit ?? this.reportLimit,

      hasMoreReports:
      hasMoreReports ?? this.hasMoreReports,

      productId:
      productId ?? this.productId,

      userId:
      userId ?? this.userId,

      isHidden:
      isHidden ?? this.isHidden,

      includeDeleted:
      includeDeleted ?? this.includeDeleted,

      reviews:
      reviews ?? this.reviews,

      reports:
      reports ?? this.reports,

      selectedReview: clearSelectedReview
          ? null
          : (selectedReview ?? this.selectedReview),

      selectedReport: clearSelectedReport
          ? null
          : (selectedReport ?? this.selectedReport),

      failure: clearFailure
          ? null
          : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
    isLoadingReviews,
    isLoadingMoreReviews,
    isLoadingReports,
    isLoadingMoreReports,
    isRefreshing,
    isDeleting,
    isHiding,
    isResolvingReport,

    reviewSkip,
    reviewLimit,
    hasMoreReviews,

    reportSkip,
    reportLimit,
    hasMoreReports,

    productId,
    userId,
    isHidden,
    includeDeleted,

    reviews,
    reports,

    selectedReview,
    selectedReport,

    failure,
  ];
}