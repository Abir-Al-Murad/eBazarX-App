import 'package:equatable/equatable.dart';

import '../../../../core/failures/failure.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/entities/review_report_entity.dart';
import '../../domain/entities/review_statistics_entity.dart';

class CustomerReviewState extends Equatable {
  /// -------------------------
  /// Loading
  /// -------------------------

  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;

  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  final bool isVoting;
  final bool isReporting;

  /// -------------------------
  /// Pagination
  /// -------------------------

  final int skip;
  final int limit;
  final bool hasMore;

  /// -------------------------
  /// Data
  /// -------------------------

  final List<ReviewEntity> reviews;

  final ReviewEntity? review;

  final ReviewStatisticsEntity? statistics;

  final ReviewReportEntity? report;

  /// -------------------------
  /// Error
  /// -------------------------

  final Failure? failure;

  const CustomerReviewState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.isVoting = false,
    this.isReporting = false,

    this.skip = 0,
    this.limit = 20,
    this.hasMore = true,

    this.reviews = const [],
    this.review,
    this.statistics,
    this.report,

    this.failure,
  });

  CustomerReviewState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,

    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,

    bool? isVoting,
    bool? isReporting,

    int? skip,
    int? limit,
    bool? hasMore,

    List<ReviewEntity>? reviews,
    ReviewEntity? review,
    ReviewStatisticsEntity? statistics,
    ReviewReportEntity? report,

    Failure? failure,

    bool clearFailure = false,
    bool clearReview = false,
    bool clearStatistics = false,
    bool clearReport = false,
  }) {
    return CustomerReviewState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,

      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,

      isVoting: isVoting ?? this.isVoting,
      isReporting: isReporting ?? this.isReporting,

      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,

      reviews: reviews ?? this.reviews,

      review: clearReview
          ? null
          : (review ?? this.review),

      statistics: clearStatistics
          ? null
          : (statistics ?? this.statistics),

      report: clearReport
          ? null
          : (report ?? this.report),

      failure: clearFailure
          ? null
          : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    isRefreshing,

    isCreating,
    isUpdating,
    isDeleting,

    isVoting,
    isReporting,

    skip,
    limit,
    hasMore,

    reviews,
    review,
    statistics,
    report,

    failure,
  ];
}