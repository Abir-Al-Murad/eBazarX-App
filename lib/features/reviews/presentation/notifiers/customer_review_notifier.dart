import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/reviews/domain/usecases/create_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/delete_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/get_product_reviews_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/get_review_details_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/get_review_statistics_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/report_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/update_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/vote_review_usecase.dart';
import 'package:ebazarx/features/reviews/presentation/states/customer_review_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerReviewNotifier extends StateNotifier<CustomerReviewState> {
  final GetProductReviewsUseCase _getProductReviews;
  final GetReviewDetailsUseCase _getReviewDetails;
  final GetReviewStatisticsUseCase _getReviewStatistics;

  final CreateReviewUseCase _createReview;
  final UpdateReviewUseCase _updateReview;
  final DeleteReviewUseCase _deleteReview;
  final VoteReviewUseCase _voteReview;
  final ReportReviewUseCase _reportReview;

  CustomerReviewNotifier(
    this._getProductReviews,
    this._getReviewDetails,
    this._getReviewStatistics,
    this._createReview,
    this._updateReview,
    this._deleteReview,
    this._voteReview,
    this._reportReview,
  ) : super(const CustomerReviewState());

  //==========================================================
  // Load Product Reviews
  //==========================================================

  Future<void> loadReviews({required String productId}) async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    try {
      print("Loading reviews for productId: $productId");
      final reviews = await _getProductReviews(
        productId: productId,
        skip: 0,
        limit: state.limit,
      );
      print("Loaded reviews: $reviews");
      state = state.copyWith(
        isLoading: false,
        reviews: reviews,
        skip: reviews.length,
        hasMore: reviews.length == state.limit,
        clearFailure: true
      );
      print("State after loading reviews: $state");
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    } catch (e,s) {
      print("Error loading reviews: $e");
      print("Stack trace: $s");
      state = state.copyWith(
        isLoading: false,
        failure: const UnknownFailure("Failed to load reviews"),
      );
    }
  }
  //==========================================================
  // Load More Reviews
  //==========================================================

  Future<void> loadMoreReviews({required String productId}) async {
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearFailure: true);

    try {
      final reviews = await _getProductReviews(
        productId: productId,
        skip: state.skip,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoadingMore: false,
        reviews: [...state.reviews, ...reviews],
        skip: state.skip + reviews.length,
        hasMore: reviews.length == state.limit,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoadingMore: false, failure: e);
    } catch (_) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: const UnknownFailure("Failed to load more reviews"),
      );
    }
  }

  //==========================================================
  // Refresh
  //==========================================================

  Future<void> refreshReviews({required String productId}) async {
    state = state.copyWith(
      isRefreshing: true,
      skip: 0,
      hasMore: true,
      reviews: const [],
      clearFailure: true,
    );

    await loadReviews(productId: productId);

    state = state.copyWith(isRefreshing: false);
  }

  Future<void> getReviewDetails({
    required String productId,
    required String reviewId,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
      clearReview: true,
    );

    try {
      final review = await _getReviewDetails(
        productId: productId,
        reviewId: reviewId,
      );

      state = state.copyWith(isLoading: false, review: review);
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        failure: const UnknownFailure("Failed to load review details"),
      );
    }
  }

  Future<void> getReviewStatistics({required String productId}) async {
    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
      clearStatistics: true,
    );

    try {
      final statistics = await _getReviewStatistics(productId);

      state = state.copyWith(isLoading: false, statistics: statistics,clearFailure: true);
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        failure: const UnknownFailure("Failed to load review statistics"),
      );
    }
  }

  Future<bool> createReview({
    required String productId,
    required String orderId,
    required int rating,
    String? comment,
    List<String>? images,
  }) async {
    state = state.copyWith(isCreating: true, clearFailure: true);

    try {
      final review = await _createReview(
        productId: productId,
        orderId: orderId,
        rating: rating,
        comment: comment,
        images: images,
      );

      state = state.copyWith(
        isCreating: false,
        reviews: [review, ...state.reviews],
        review: review,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(isCreating: false, failure: e);
      return false;
    } catch (_) {
      state = state.copyWith(
        isCreating: false,
        failure: const UnknownFailure("Failed to create review"),
      );
      return false;
    }
  }

  Future<bool> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
    List<String>? images,
  }) async {
    state = state.copyWith(isUpdating: true, clearFailure: true);

    try {
      final review = await _updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
        images: images,
      );

      final reviews = state.reviews.map((e) {
        if (e.id == review.id) {
          return review;
        }
        return e;
      }).toList();

      state = state.copyWith(
        isUpdating: false,
        reviews: reviews,
        review: review,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(isUpdating: false, failure: e);
      return false;
    } catch (_) {
      state = state.copyWith(
        isUpdating: false,
        failure: const UnknownFailure("Failed to update review"),
      );
      return false;
    }
  }

  Future<bool> deleteReview(String reviewId) async {
    state = state.copyWith(isDeleting: true, clearFailure: true);

    try {
      await _deleteReview(reviewId);

      final reviews = state.reviews.where((e) => e.id != reviewId).toList();

      state = state.copyWith(
        isDeleting: false,
        reviews: reviews,
        clearReview: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(isDeleting: false, failure: e);

      return false;
    } catch (_) {
      state = state.copyWith(
        isDeleting: false,
        failure: const UnknownFailure("Failed to delete review"),
      );

      return false;
    }
  }

  Future<bool> voteReview({
    required String reviewId,
    required String voteType,
  }) async {
    state = state.copyWith(isVoting: true, clearFailure: true);

    try {
      await _voteReview(reviewId: reviewId, voteType: voteType);

      state = state.copyWith(isVoting: false);

      return true;
    } on Failure catch (e) {
      state = state.copyWith(isVoting: false, failure: e);

      return false;
    } catch (_) {
      state = state.copyWith(
        isVoting: false,
        failure: const UnknownFailure("Failed to vote review"),
      );

      return false;
    }
  }

  Future<bool> reportReview({
    required String reviewId,
    required String reason,
    String? description,
  }) async {
    state = state.copyWith(
      isReporting: true,
      clearFailure: true,
      clearReport: true,
    );

    try {
      final report = await _reportReview(
        reviewId: reviewId,
        reason: reason,
        description: description,
      );

      state = state.copyWith(isReporting: false, report: report);

      return true;
    } on Failure catch (e) {
      state = state.copyWith(isReporting: false, failure: e);
      return false;
    } catch (_) {
      state = state.copyWith(
        isReporting: false,
        failure: const UnknownFailure("Failed to report review"),
      );
      return false;
    }
  }

  void clearCustomerState() {
    state = const CustomerReviewState();
  }
}
