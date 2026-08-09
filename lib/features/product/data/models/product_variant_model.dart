import 'package:ebazarx/features/product/domain/entities/product_variant_entity.dart';

class ProductVariantModel {
  final String id;
  final String productId;
  final String sku;
  final double? priceOverride;
  final int reservedStock;
  final int stock;
  final Map<String, String> attributes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductVariantModel({
    required this.id,
    required this.productId,
    required this.sku,
    this.priceOverride,
    required this.stock,
    this.attributes = const {},
    this.createdAt,
    this.updatedAt,
    this.reservedStock = 0,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'],
      productId: json['product_id'],
      sku: json['sku'],
      reservedStock: json['reserved_stock'] ?? 0,
      priceOverride: json['price_override'] != null
          ? double.parse(json['price_override'].toString())
          : null,
      stock: json['stock'],
      attributes:
      Map<String, String>.from(json['attributes'] ?? {}),
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
    "sku": sku,
    "price_override": priceOverride,
    "stock": stock,
    "attributes": attributes,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  ProductVariant toEntity() => ProductVariant(
    id: id,
    productId: productId,
    sku: sku,
    priceOverride: priceOverride,
    stock: stock,
    attributes: attributes,
    createdAt: createdAt,
    updatedAt: updatedAt,
    reservedStock: reservedStock,
  );

  factory ProductVariantModel.fromEntity(ProductVariant entity) {
    return ProductVariantModel(
      id: entity.id,
      productId: entity.productId,
      sku: entity.sku,
      priceOverride: entity.priceOverride,
      stock: entity.stock,
      reservedStock: entity.reservedStock,
      attributes: entity.attributes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
