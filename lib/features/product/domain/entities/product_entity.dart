import 'package:ebazarx/features/product/domain/entities/product_image_entity.dart';
import 'package:ebazarx/features/product/domain/entities/product_variant_entity.dart';
import 'package:ebazarx/features/product/domain/entities/dimension_entity.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
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
  final ProductDimension? dimensions;

  final bool isActive;
  final String approvalStatus;

  final double averageRating;
  final int totalReviews;
  final int totalSales;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<ProductVariant> variants;
  final List<ProductImage> images;

  const Product({
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

  /// True if a valid discount price is set and lower than the base price
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  /// The price to actually charge — discount price if valid, otherwise base price
  double get effectivePrice => hasDiscount ? discountPrice! : price;

  /// Discount percentage rounded to nearest whole number (e.g. 20 for 20%)
  int get discountPercent {
    if (!hasDiscount || price == 0) return 0;
    return (((price - discountPrice!) / price) * 100).round();
  }

  /// Primary image if flagged, otherwise the lowest sortOrder image, otherwise null
  ProductImage? get primaryImage {
    if (images.isEmpty) return null;
    final primary = images.where((img) => img.isPrimary);
    if (primary.isNotEmpty) return primary.first;
    final sorted = [...images]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sorted.first;
  }

  @override
  List<Object?> get props => [
    id,
    sellerId,
    categoryId,
    brandId,
    name,
    slug,
    description,
    price,
    discountPrice,
    sku,
    seoTitle,
    seoDescription,
    metaKeywords,
    tags,
    weight,
    dimensions,
    isActive,
    approvalStatus,
    averageRating,
    totalReviews,
    totalSales,
    createdAt,
    updatedAt,
    variants,
    images,
  ];
}