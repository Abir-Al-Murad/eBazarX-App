import 'package:ebazarx/features/product/domain/entities/product_image_entity.dart';

class ProductImageModel {
  final String id;
  final String productId;
  final String url;
  final bool isPrimary;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductImageModel({
    required this.id,
    required this.productId,
    required this.url,
    required this.isPrimary,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'],
      productId: json['product_id'],
      url: json['url'],
      isPrimary: json['is_primary'],
      sortOrder: json['sort_order'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "url": url,
    "is_primary": isPrimary,
    "sort_order": sortOrder,
    "created_at": createdAt?.toIso8601String(),
  };

  ProductImage toEntity() => ProductImage(
    id: id,
    productId: productId,
    url: url,
    isPrimary: isPrimary,
    sortOrder: sortOrder,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory ProductImageModel.fromEntity(ProductImage entity) {
    return ProductImageModel(
      id: entity.id,
      productId: entity.productId,
      url: entity.url,
      isPrimary: entity.isPrimary,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}