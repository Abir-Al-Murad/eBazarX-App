import 'package:equatable/equatable.dart';

import '../../../../core/failures/failure.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/entities/review_reply_entity.dart';

class SellerReviewState extends Equatable {
  // ===========================
  // Loading
  // ===========================

  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;

  final bool isReplying;
  final bool isUpdatingReply;
  final bool isDeletingReply;

  // ===========================
  // Pagination
  // ===========================

  final int skip;
  final int limit;
  final bool hasMore;

  // ===========================
  // Data
  // ===========================

  final List<ReviewEntity> reviews;

  final ReviewEntity? review;

  final ReviewReplyEntity? reply;

  // ===========================
  // Error
  // ===========================

  final Failure? failure;

  const SellerReviewState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,

    this.isReplying = false,
    this.isUpdatingReply = false,
    this.isDeletingReply = false,

    this.skip = 0,
    this.limit = 20,
    this.hasMore = true,

    this.reviews = const [],
    this.review,
    this.reply,

    this.failure,
  });

  SellerReviewState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,

    bool? isReplying,
    bool? isUpdatingReply,
    bool? isDeletingReply,

    int? skip,
    int? limit,
    bool? hasMore,

    List<ReviewEntity>? reviews,
    ReviewEntity? review,
    ReviewReplyEntity? reply,

    Failure? failure,

    bool clearFailure = false,
    bool clearReview = false,
    bool clearReply = false,
  }) {
    return SellerReviewState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,

      isReplying: isReplying ?? this.isReplying,
      isUpdatingReply: isUpdatingReply ?? this.isUpdatingReply,
      isDeletingReply: isDeletingReply ?? this.isDeletingReply,

      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,

      reviews: reviews ?? this.reviews,

      review: clearReview
          ? null
          : (review ?? this.review),

      reply: clearReply
          ? null
          : (reply ?? this.reply),

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

    isReplying,
    isUpdatingReply,
    isDeletingReply,

    skip,
    limit,
    hasMore,

    reviews,
    review,
    reply,

    failure,
  ];
}