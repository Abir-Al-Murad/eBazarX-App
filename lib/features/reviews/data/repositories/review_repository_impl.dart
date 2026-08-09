import 'package:ebazarx/features/reviews/data/datasources/review_remote_data_source.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_reply_entity.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_report_entity.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_statistics_entity.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  const ReviewRepositoryImpl(this.remoteDataSource);

  //==========================================================
  // Customer
  //==========================================================

  @override
  Future<ReviewEntity> createReview({
    required String productId,
    required String orderId,
    required int rating,
    String? comment,
    List<String>? images,
  }) async {
    final review = await remoteDataSource.createReview(
      productId: productId,
      orderId: orderId,
      rating: rating,
      comment: comment,
      images: images,
    );

    return review.toEntity();
  }

  @override
  Future<ReviewEntity> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
    List<String>? images,
  }) async {
    final review = await remoteDataSource.updateReview(
      reviewId: reviewId,
      rating: rating,
      comment: comment,
      images: images,
    );

    return review.toEntity();
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    await remoteDataSource.deleteReview(reviewId);
  }

  @override
  Future<Map<String, dynamic>> voteReview({
    required String reviewId,
    required String voteType,
  }) async {
    return await remoteDataSource.voteReview(
      reviewId: reviewId,
      voteType: voteType,
    );
  }

  @override
  Future<ReviewReportEntity> reportReview({
    required String reviewId,
    required String reason,
    String? description,
  }) async {
    final report = await remoteDataSource.reportReview(
      reviewId: reviewId,
      reason: reason,
      description: description,
    );

    return report.toEntity();
  }

  //==========================================================
  // Public
  //==========================================================

  @override
  Future<List<ReviewEntity>> getProductReviews({
    required String productId,
    int skip = 0,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final reviews = await remoteDataSource.getProductReviews(
      productId: productId,
      skip: skip,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );

    return reviews.map((e) => e.toEntity()).toList();
  }

  @override
  Future<ReviewEntity> getReviewDetails({
    required String productId,
    required String reviewId,
  }) async {
    final review = await remoteDataSource.getReviewDetails(
      productId: productId,
      reviewId: reviewId,
    );

    return review.toEntity();
  }

  @override
  Future<ReviewStatisticsEntity> getReviewStatistics(
      String productId,
      ) async {
    final statistics =
    await remoteDataSource.getReviewStatistics(productId);

    return statistics.toEntity();
  }

  //==========================================================
  // Seller
  //==========================================================

  @override
  Future<ReviewReplyEntity> replyToReview({
    required String reviewId,
    required String reply,
  }) async {
    final replyModel = await remoteDataSource.replyToReview(
      reviewId: reviewId,
      reply: reply,
    );

    return replyModel.toEntity();
  }

  //==========================================================
  // Admin
  //==========================================================

  @override
  Future<List<ReviewEntity>> adminListReviews({
    int skip = 0,
    int limit = 20,
    String? productId,
    String? userId,
    bool? isHidden,
    bool? includeDeleted,
  }) async {
    final reviews = await remoteDataSource.adminListReviews(
      skip: skip,
      limit: limit,
      productId: productId,
      userId: userId,
      isHidden: isHidden,
      includeDeleted: includeDeleted,
    );

    return reviews.map((e) => e.toEntity()).toList();
  }

  @override
  Future<ReviewEntity> adminToggleHide(
      String reviewId,
      ) async {
    final review = await remoteDataSource.adminToggleHide(reviewId);

    return review.toEntity();
  }

  @override
  Future<void> adminDeleteReview(
      String reviewId,
      ) async {
    await remoteDataSource.adminDeleteReview(reviewId);
  }

  @override
  Future<List<ReviewReportEntity>> adminListPendingReports({
    int skip = 0,
    int limit = 20,
  }) async {
    final reports = await remoteDataSource.adminListPendingReports(
      skip: skip,
      limit: limit,
    );

    return reports.map((e) => e.toEntity()).toList();
  }

  @override
  Future<ReviewReportEntity> adminResolveReport(
      String reportId,
      ) async {
    final report =
    await remoteDataSource.adminResolveReport(reportId);

    return report.toEntity();
  }
}