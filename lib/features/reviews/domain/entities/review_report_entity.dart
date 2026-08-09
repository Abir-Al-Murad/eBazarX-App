import 'package:equatable/equatable.dart';

class ReviewReportEntity extends Equatable {
  final String id;

  final String reviewId;
  final String userId;

  final String reason;
  final String? description;

  final bool resolved;

  final DateTime createdAt;

  const ReviewReportEntity({
    required this.id,
    required this.reviewId,
    required this.userId,
    required this.reason,
    this.description,
    required this.resolved,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    reviewId,
    userId,
    reason,
    description,
    resolved,
    createdAt,
  ];
}