import 'package:ebazarx/features/reviews/data/models/review_model.dart';

class ReviewPageModel {
  final List<ReviewModel> data;
  final int total;
  final int page;
  final int size;
  final int pages;

  const ReviewPageModel({
    required this.data,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  factory ReviewPageModel.fromJson(Map<String, dynamic> json) {
    return ReviewPageModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      size: json['size'] ?? 20,
      pages: json['pages'] ?? 0,
    );
  }
}