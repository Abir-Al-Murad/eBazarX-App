

import 'package:drift/drift.dart';
import 'package:ebazarx/core/database/app_database.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';

class BannerModel {
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

  const BannerModel({
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

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      linkUrl: json['link_url'],
      productId: json['product_id'],
      categoryId: json['category_id'],
      position: json['position'] ?? 0,
      isActive: json['is_active'] ?? false,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  factory BannerModel.fromEntity(BannerEntity banner) {
    return BannerModel(
      id: banner.id,
      title: banner.title,
      description: banner.description,
      imageUrl: banner.imageUrl,
      linkUrl: banner.linkUrl,
      productId: banner.productId,
      categoryId: banner.categoryId,
      position: banner.position,
      isActive: banner.isActive,
      startDate: banner.startDate,
      endDate: banner.endDate,
      createdAt: banner.createdAt,
      updatedAt: banner.updatedAt,
    );
  }

  BannerEntity toEntity() {
    return BannerEntity(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      linkUrl: linkUrl,
      productId: productId,
      categoryId: categoryId,
      position: position,
      isActive: isActive,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'link_url': linkUrl,
      'product_id': productId,
      'category_id': categoryId,
      'position': position,
      'is_active': isActive,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }


  factory BannerModel.fromTable(
      BannerTableData data,
      ) {
    return BannerModel(
      id: data.id,
      title: data.title,
      description: data.description,
      imageUrl: data.imageUrl,

      linkUrl: data.linkUrl,
      productId: data.productId,
      categoryId: data.categoryId,

      position: data.position,
      isActive: data.isActive,

      startDate: data.startDate,
      endDate: data.endDate,

      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  BannerTableCompanion toCompanion() {

    return BannerTableCompanion(

      id: Value(id),

      title: Value(title),

      description: Value(description),

      imageUrl: Value(imageUrl),


      linkUrl: Value(linkUrl),

      productId: Value(productId),

      categoryId: Value(categoryId),


      position: Value(position),

      isActive: Value(isActive),


      startDate: Value(startDate),

      endDate: Value(endDate),


      createdAt: Value(createdAt),

      updatedAt: Value(updatedAt),

    );

  }
}