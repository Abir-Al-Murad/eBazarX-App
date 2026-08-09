import 'package:ebazarx/features/product/data/models/product_dimension_model.dart';
import 'package:ebazarx/features/product/data/models/product_variant_model.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/data/models/product_image_model.dart';
import 'package:ebazarx/features/product/data/models/product_variant_model.dart';


class ProductModel {
  final String id;
  final String sellerId;
  final String categoryId;
  final String? brandId;

  final String name;
  final String slug;
  final String? description;

  final double price;
  final double? discountPrice;

  final String sku;

  final String? seoTitle;
  final String? seoDescription;
  final String? metaKeywords;

  final List<String> tags;

  final double? weight;
  final ProductDimensionModel? dimensions;

  final bool isActive;
  final String approvalStatus;

  final double averageRating;
  final int totalReviews;
  final int totalSales;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<ProductVariantModel> variants;
  final List<ProductImageModel> images;

  const ProductModel({
    required this.id,
    required this.sellerId,
    required this.categoryId,
    this.brandId,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.discountPrice,
    required this.sku,
    this.seoTitle,
    this.seoDescription,
    this.metaKeywords,
    this.tags = const [],
    this.weight,
    this.dimensions,
    required this.isActive,
    required this.approvalStatus,
    this.averageRating = 0,
    this.totalReviews = 0,
    this.totalSales = 0,
    this.createdAt,
    this.updatedAt,
    this.variants = const [],
    this.images = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      sellerId: json['seller_id'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      discountPrice: json['discount_price'] != null
          ? double.parse(json['discount_price'].toString())
          : null,
      sku: json['sku'],
      seoTitle: json['seo_title'],
      seoDescription: json['seo_description'],
      metaKeywords: json['meta_keywords'],
      tags: List<String>.from(json['tags'] ?? []),
      weight: json['weight'] != null
          ? double.parse(json['weight'].toString())
          : null,
      dimensions: json['dimensions'] != null
          ? ProductDimensionModel.fromJson(json['dimensions'])
          : null,
      isActive: json['is_active'],
      approvalStatus: json['approval_status'].toString(),
      averageRating:
      double.parse((json['average_rating'] ?? 0).toString()),
      totalReviews: json['total_reviews'] ?? 0,
      totalSales: json['total_sales'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      variants: (json['variants'] as List? ?? [])
          .map((e) => ProductVariantModel.fromJson(e))
          .toList(),
      images: (json['images'] as List? ?? [])
          .map((e) => ProductImageModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "seller_id": sellerId,
      "category_id": categoryId,
      "brand_id": brandId,
      "name": name,
      "slug": slug,
      "description": description,
      "price": price,
      "discount_price": discountPrice,
      "sku": sku,
      "seo_title": seoTitle,
      "seo_description": seoDescription,
      "meta_keywords": metaKeywords,
      "tags": tags,
      "weight": weight,
      "dimensions": dimensions?.toJson(),
      "is_active": isActive,
      "approval_status": approvalStatus,
      "average_rating": averageRating,
      "total_reviews": totalReviews,
      "total_sales": totalSales,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "variants": variants.map((e) => e.toJson()).toList(),
      "images": images.map((e) => e.toJson()).toList(),
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      sellerId: sellerId,
      categoryId: categoryId,
      brandId: brandId,
      name: name,
      slug: slug,
      description: description,
      price: price,
      discountPrice: discountPrice,
      sku: sku,
      seoTitle: seoTitle,
      seoDescription: seoDescription,
      metaKeywords: metaKeywords,
      tags: tags,
      weight: weight,
      dimensions: dimensions?.toEntity(),
      isActive: isActive,
      approvalStatus: approvalStatus,
      averageRating: averageRating,
      totalReviews: totalReviews,
      totalSales: totalSales,
      createdAt: createdAt,
      updatedAt: updatedAt,
      variants: variants.map((e) => e.toEntity()).toList(),
      images: images.map((e) => e.toEntity()).toList(),
    );
  }

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      sellerId: entity.sellerId,
      categoryId: entity.categoryId,
      brandId: entity.brandId,
      name: entity.name,
      slug: entity.slug,
      description: entity.description,
      price: entity.price,
      discountPrice: entity.discountPrice,
      sku: entity.sku,
      seoTitle: entity.seoTitle,
      seoDescription: entity.seoDescription,
      metaKeywords: entity.metaKeywords,
      tags: entity.tags,
      weight: entity.weight,
      dimensions: entity.dimensions == null
          ? null
          : ProductDimensionModel.fromEntity(entity.dimensions!),
      isActive: entity.isActive,
      approvalStatus: entity.approvalStatus,
      averageRating: entity.averageRating,
      totalReviews: entity.totalReviews,
      totalSales: entity.totalSales,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      variants: entity.variants
          .map(ProductVariantModel.fromEntity)
          .toList(),
      images:
      entity.images.map(ProductImageModel.fromEntity).toList(),
    );
  }
}