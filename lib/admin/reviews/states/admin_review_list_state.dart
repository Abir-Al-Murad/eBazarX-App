import 'package:equatable/equatable.dart';

import '../../../core/failures/failure.dart';
import '../../../features/reviews/domain/entities/review_entity.dart';
import '../../../features/reviews/domain/entities/review_report_entity.dart';

class AdminReviewListState extends Equatable {
  // ============================================================
  // REVIEW LOADING
  // ============================================================

  final bool isLoadingReviews;
  final bool isLoadingMoreReviews;
  final bool isRefreshingReviews;

  // ============================================================
  // REPORT LOADING
  // ============================================================

  final bool isLoadingReports;
  final bool isLoadingMoreReports;
  final bool isRefreshingReports;

  // ============================================================
  // REVIEW PAGINATION
  // ============================================================

  final int reviewSkip;
  final int reviewLimit;
  final bool hasMoreReviews;

  // ============================================================
  // REPORT PAGINATION
  // ============================================================

  final int reportSkip;
  final int reportLimit;
  final bool hasMoreReports;

  // ============================================================
  // FILTERS
  // ============================================================

  final String? productId;
  final String? userId;
  final bool? isHidden;
  final bool? includeDeleted;

  // ============================================================
  // DATA
  // ============================================================

  final List<ReviewEntity> reviews;
  final List<ReviewReportEntity> reports;

  // ============================================================
  // ERROR
  // ============================================================

  final Failure? failure;

  const AdminReviewListState({
    this.isLoadingReviews = false,
    this.isLoadingMoreReviews = false,
    this.isRefreshingReviews = false,

    this.isLoadingReports = false,
    this.isLoadingMoreReports = false,
    this.isRefreshingReports = false,

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

    this.failure,
  });

  bool get isLoading =>
      isLoadingReviews || isLoadingReports;

  bool get isLoadingMore =>
      isLoadingMoreReviews || isLoadingMoreReports;

  bool get isRefreshing =>
      isRefreshingReviews || isRefreshingReports;

  bool get isFailure => failure != null;

  AdminReviewListState copyWith({
    bool? isLoadingReviews,
    bool? isLoadingMoreReviews,
    bool? isRefreshingReviews,

    bool? isLoadingReports,
    bool? isLoadingMoreReports,
    bool? isRefreshingReports,

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

    Failure? failure,

    bool clearFailure = false,
    bool clearProductId = false,
    bool clearUserId = false,
    bool clearIsHidden = false,
    bool clearIncludeDeleted = false,
  }) {
    return AdminReviewListState(
      isLoadingReviews:
      isLoadingReviews ?? this.isLoadingReviews,

      isLoadingMoreReviews:
      isLoadingMoreReviews ?? this.isLoadingMoreReviews,

      isRefreshingReviews:
      isRefreshingReviews ?? this.isRefreshingReviews,

      isLoadingReports:
      isLoadingReports ?? this.isLoadingReports,

      isLoadingMoreReports:
      isLoadingMoreReports ?? this.isLoadingMoreReports,

      isRefreshingReports:
      isRefreshingReports ?? this.isRefreshingReports,

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

      productId: clearProductId
          ? null
          : productId ?? this.productId,

      userId: clearUserId
          ? null
          : userId ?? this.userId,

      isHidden: clearIsHidden
          ? null
          : isHidden ?? this.isHidden,

      includeDeleted: clearIncludeDeleted
          ? null
          : includeDeleted ?? this.includeDeleted,

      reviews:
      reviews ?? this.reviews,

      reports:
      reports ?? this.reports,

      failure: clearFailure
          ? null
          : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingReviews,
    isLoadingMoreReviews,
    isRefreshingReviews,

    isLoadingReports,
    isLoadingMoreReports,
    isRefreshingReports,

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

    failure,
  ];
}