import 'package:equatable/equatable.dart';

class ReviewImageEntity extends Equatable {
  final String id;
  final String reviewId;

  final String url;
  final int sortOrder;

  final DateTime createdAt;

  const ReviewImageEntity({
    required this.id,
    required this.reviewId,
    required this.url,
    required this.sortOrder,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    reviewId,
    url,
    sortOrder,
    createdAt,
  ];
}