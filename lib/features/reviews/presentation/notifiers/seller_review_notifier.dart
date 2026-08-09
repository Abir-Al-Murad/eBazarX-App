import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_reply_entity.dart';
import 'package:ebazarx/features/reviews/domain/usecases/get_review_details_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/reply_review_usecase.dart';
import 'package:ebazarx/features/reviews/presentation/states/seller_review_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class SellerReviewNotifier extends StateNotifier<SellerReviewState> {
  final ReplyReviewUseCase _replyReview;
  final GetReviewDetailsUseCase _getReviewDetails;

  SellerReviewNotifier(
      this._replyReview,
      this._getReviewDetails,
      ) : super(const SellerReviewState());

  ///------------------------------------------------------
  /// Get Review Details
  ///------------------------------------------------------

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

      state = state.copyWith(
        isLoading: false,
        review: review,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        failure: const UnknownFailure(
          "Failed to load review.",
        ),
      );
    }
  }

  ///------------------------------------------------------
  /// Reply Review
  ///------------------------------------------------------

  Future<bool> replyReview({
    required String reviewId,
    required String reply,
  }) async {
    state = state.copyWith(
      isReplying: true,
      clearFailure: true,
      clearReply: true,
    );

    try {
      final ReviewReplyEntity reviewReply =
      await _replyReview(
        reviewId: reviewId,
        reply: reply,
      );

      ReviewEntity? updatedReview;

      if (state.review != null) {
        updatedReview = state.review!.copyWith(
          reply: reviewReply,
        );
      }

      state = state.copyWith(
        isReplying: false,
        reply: reviewReply,
        review: updatedReview,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        isReplying: false,
        failure: e,
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        isReplying: false,
        failure: const UnknownFailure(
          "Failed to reply.",
        ),
      );

      return false;
    }
  }
}