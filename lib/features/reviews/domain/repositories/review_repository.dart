import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_reply_entity.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_report_entity.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_statistics_entity.dart';

abstract class ReviewRepository {
  // ==========================================================
  // Customer
  // ==========================================================

  Future<ReviewEntity> createReview({
    required String productId,
    required String orderId,
    required int rating,
    String? comment,
    List<String>? images,
  });

  Future<ReviewEntity> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
    List<String>? images,
  });

  Future<void> deleteReview(String reviewId);

  Future<Map<String, dynamic>> voteReview({
    required String reviewId,
    required String voteType,
  });

  Future<ReviewReportEntity> reportReview({
    required String reviewId,
    required String reason,
    String? description,
  });

  // ==========================================================
  // Public
  // ==========================================================

  Future<List<ReviewEntity>> getProductReviews({
    required String productId,
    int skip = 0,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  });

  Future<ReviewEntity> getReviewDetails({
    required String productId,
    required String reviewId,
  });

  Future<ReviewStatisticsEntity> getReviewStatistics(String productId);

  // ==========================================================
  // Seller
  // ==========================================================

  Future<ReviewReplyEntity> replyToReview({
    required String reviewId,
    required String reply,
  });

  // ==========================================================
  // Admin
  // ==========================================================

  Future<List<ReviewEntity>> adminListReviews({
    int skip = 0,
    int limit = 20,
    String? productId,
    String? userId,
    bool? isHidden,
    bool? includeDeleted,
  });

  Future<ReviewEntity> adminToggleHide(String reviewId);

  Future<void> adminDeleteReview(String reviewId);

  Future<List<ReviewReportEntity>> adminListPendingReports({
    int skip = 0,
    int limit = 20,
  });

  Future<ReviewReportEntity> adminResolveReport(String reportId);
}
