import 'package:ebazarx/features/reviews/domain/entities/review_statistics_entity.dart';

class ReviewStatisticsModel {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  const ReviewStatisticsModel({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ReviewStatisticsModel.fromJson(Map<String, dynamic> json) {
    final Map<int, int> distribution = {};

    final rawDistribution =
        json['rating_distribution'] as Map<String, dynamic>? ?? {};

    rawDistribution.forEach((key, value) {
      distribution[int.parse(key)] = value as int;
    });

    return ReviewStatisticsModel(
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: json['total_reviews'] as int,
      ratingDistribution: distribution,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'rating_distribution':
      ratingDistribution.map((key, value) => MapEntry(key.toString(), value)),
    };
  }

  ReviewStatisticsEntity toEntity() {
    return ReviewStatisticsEntity(
      averageRating: averageRating,
      totalReviews: totalReviews,
      ratingDistribution: ratingDistribution,
    );
  }

  factory ReviewStatisticsModel.fromEntity(
      ReviewStatisticsEntity entity) {
    return ReviewStatisticsModel(
      averageRating: entity.averageRating,
      totalReviews: entity.totalReviews,
      ratingDistribution: entity.ratingDistribution,
    );
  }

  ReviewStatisticsModel copyWith({
    double? averageRating,
    int? totalReviews,
    Map<int, int>? ratingDistribution,
  }) {
    return ReviewStatisticsModel(
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      ratingDistribution:
      ratingDistribution ?? this.ratingDistribution,
    );
  }
}