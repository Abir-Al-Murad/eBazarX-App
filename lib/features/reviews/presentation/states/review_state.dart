import 'package:equatable/equatable.dart';

import '../../../../core/failures/failure.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/entities/review_report_entity.dart';
import '../../domain/entities/review_statistics_entity.dart';

class ReviewState extends Equatable {
  final bool isLoading;

  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  final bool isReplying;
  final bool isVoting;
  final bool isReporting;

  final bool isAdminLoading;
  final bool isAdminDeleting;
  final bool isAdminHiding;
  final bool isResolvingReport;

  final List<ReviewEntity> reviews;

  final List<ReviewReportEntity> reports;
  final ReviewReportEntity? report;

  final ReviewEntity? review;

  final ReviewStatisticsEntity? statistics;

  final Failure? failure;

  const ReviewState({
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.isReplying = false,
    this.isVoting = false,
    this.isReporting = false,
    this.isAdminLoading = false,
    this.isAdminDeleting = false,
    this.isAdminHiding = false,
    this.isResolvingReport = false,
    this.reviews = const [],
    this.reports = const [],
    this.review,
    this.report,
    this.statistics,
    this.failure,
  });

  ReviewState copyWith({
    bool? isLoading,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
    bool? isReplying,
    bool? isVoting,
    bool? isReporting,
    bool? isAdminLoading,
    bool? isAdminDeleting,
    bool? isAdminHiding,
    bool? isResolvingReport,
    List<ReviewEntity>? reviews,
    List<ReviewReportEntity>? reports,
    ReviewReportEntity? report,
    ReviewEntity? review,
    ReviewStatisticsEntity? statistics,
    Failure? failure,
    bool clearFailure = false,
    bool clearReview = false,
    bool clearStatistics = false,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      isReplying: isReplying ?? this.isReplying,
      isVoting: isVoting ?? this.isVoting,
      isReporting: isReporting ?? this.isReporting,
      isAdminLoading: isAdminLoading ?? this.isAdminLoading,
      isAdminDeleting: isAdminDeleting ?? this.isAdminDeleting,
      isAdminHiding: isAdminHiding ?? this.isAdminHiding,
      isResolvingReport:
      isResolvingReport ?? this.isResolvingReport,
      reviews: reviews ?? this.reviews,
      reports: reports ?? this.reports,
      report: report ?? this.report,
      review: clearReview ? null : (review ?? this.review),
      statistics: clearStatistics
          ? null
          : (statistics ?? this.statistics),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isCreating,
    isUpdating,
    isDeleting,
    isReplying,
    isVoting,
    isReporting,
    isAdminLoading,
    isAdminDeleting,
    isAdminHiding,
    isResolvingReport,
    reviews,
    reports,
    review,
    statistics,
    failure,
  ];
}