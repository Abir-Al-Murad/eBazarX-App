import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/reviews/data/models/review_page_model.dart';

import '../models/review_model.dart';
import '../models/review_reply_model.dart';
import '../models/review_report_model.dart';
import '../models/review_statistics_model.dart';

class ReviewRemoteDataSource {
  final ApiClient _apiClient;

  const ReviewRemoteDataSource(this._apiClient);

  // ==========================================================
  // CUSTOMER
  // ==========================================================

  Future<ReviewModel> createReview({
    required String productId,
    required String orderId,
    required int rating,
    String? comment,
    List<String>? images,
  }) async {
    final response = await _apiClient.post(
      '/customer/reviews',
      data: {
        'product_id': productId,
        'order_id': orderId,
        'rating': rating,
        'comment': comment,
        'images': images,
      },
    );

    if (response.isSuccess) {
      return ReviewModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to create review');
  }

  Future<ReviewModel> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
    List<String>? images,
  }) async {
    final response = await _apiClient.put(
      '/customer/reviews/$reviewId',
      data: {
        if (rating != null) 'rating': rating,
        if (comment != null) 'comment': comment,
        if (images != null) 'images': images,
      },
    );

    if (response.isSuccess) {
      return ReviewModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to update review');
  }

  Future<void> deleteReview(String reviewId) async {
    final response =
    await _apiClient.delete('/customer/reviews/$reviewId');

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to delete review');
    }
  }

  Future<Map<String, dynamic>> voteReview({
    required String reviewId,
    required String voteType,
  }) async {
    final response = await _apiClient.post(
      '/customer/reviews/$reviewId/vote',
      data: {
        'vote_type': voteType,
      },
    );

    if (response.isSuccess) {
      return Map<String, dynamic>.from(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to vote review');
  }

  Future<ReviewReportModel> reportReview({
    required String reviewId,
    required String reason,
    String? description,
  }) async {
    final response = await _apiClient.post(
      '/customer/reviews/$reviewId/report',
      data: {
        'reason': reason,
        'description': description,
      },
    );

    if (response.isSuccess) {
      return ReviewReportModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to report review');
  }

  // ==========================================================
  // PUBLIC
  // ==========================================================

  Future<List<ReviewModel>> getProductReviews({
    required String productId,
    int skip = 0,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final response = await _apiClient.get(
      '/products/$productId/reviews',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      },
    );

    if (response.isSuccess) {
      return response.body['data'].map<ReviewModel>((e) => ReviewModel.fromJson(e)).toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch reviews');
  }

  Future<ReviewModel> getReviewDetails({
    required String productId,
    required String reviewId,
  }) async {
    final response = await _apiClient.get(
      '/products/$productId/reviews/$reviewId',
    );

    if (response.isSuccess) {
      return ReviewModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch review');
  }

  Future<ReviewStatisticsModel> getReviewStatistics(
      String productId) async {
    final response = await _apiClient.get(
      '/products/$productId/reviews/statistics',
    );

    if (response.isSuccess) {
      return ReviewStatisticsModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch statistics');
  }

  // ==========================================================
  // SELLER
  // ==========================================================

  Future<ReviewReplyModel> replyToReview({
    required String reviewId,
    required String reply,
  }) async {
    final response = await _apiClient.post(
      '/seller/reviews/$reviewId/reply',
      data: {
        'reply': reply,
      },
    );

    if (response.isSuccess) {
      return ReviewReplyModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to reply');
  }

  // ==========================================================
  // ADMIN
  // ==========================================================

  Future<List<ReviewModel>> adminListReviews({
    int skip = 0,
    int limit = 20,
    String? productId,
    String? userId,
    bool? isHidden,
    bool? includeDeleted,
  }) async {
    final response = await _apiClient.get(
      '/admin/reviews',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (productId != null) 'product_id': productId,
        if (userId != null) 'user_id': userId,
        if (isHidden != null) 'is_hidden': isHidden,
        if (includeDeleted != null) 'include_deleted': includeDeleted,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch admin reviews');
  }

  Future<ReviewModel> adminToggleHide(String reviewId) async {
    final response = await _apiClient.put(
      '/admin/reviews/$reviewId/hide',
    );

    if (response.isSuccess) {
      return ReviewModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to hide review');
  }

  Future<void> adminDeleteReview(String reviewId) async {
    final response = await _apiClient.delete(
      '/admin/reviews/$reviewId',
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to delete review');
    }
  }

  Future<List<ReviewReportModel>> adminListPendingReports({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/admin/reviews/reports',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => ReviewReportModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch reports');
  }

  Future<ReviewReportModel> adminResolveReport(
      String reportId) async {
    final response = await _apiClient.put(
      '/admin/reviews/reports/$reportId/resolve',
    );

    if (response.isSuccess) {
      return ReviewReportModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to resolve report');
  }
}