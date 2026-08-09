import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? linkUrl;
  final String? productId;
  final String? categoryId;
  final int position;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.linkUrl,
    this.productId,
    this.categoryId,
    required this.position,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    linkUrl,
    productId,
    categoryId,
    position,
    isActive,
    startDate,
    endDate,
    createdAt,
    updatedAt,
  ];
}