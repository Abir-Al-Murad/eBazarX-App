import '../../domain/entities/review_report_entity.dart';

class ReviewReportModel {
  final String id;
  final String reviewId;
  final String userId;
  final String reason;
  final String? description;
  final bool resolved;
  final DateTime createdAt;

  const ReviewReportModel({
    required this.id,
    required this.reviewId,
    required this.userId,
    required this.reason,
    this.description,
    required this.resolved,
    required this.createdAt,
  });

  factory ReviewReportModel.fromJson(Map<String, dynamic> json) {
    return ReviewReportModel(
      id: json['id'],
      reviewId: json['review_id'],
      userId: json['user_id'],
      reason: json['reason'],
      description: json['description'],
      resolved: json['resolved'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review_id': reviewId,
      'user_id': userId,
      'reason': reason,
      'description': description,
      'resolved': resolved,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ReviewReportEntity toEntity() {
    return ReviewReportEntity(
      id: id,
      reviewId: reviewId,
      userId: userId,
      reason: reason,
      description: description,
      resolved: resolved,
      createdAt: createdAt,
    );
  }

  factory ReviewReportModel.fromEntity(ReviewReportEntity entity) {
    return ReviewReportModel(
      id: entity.id,
      reviewId: entity.reviewId,
      userId: entity.userId,
      reason: entity.reason,
      description: entity.description,
      resolved: entity.resolved,
      createdAt: entity.createdAt,
    );
  }
}