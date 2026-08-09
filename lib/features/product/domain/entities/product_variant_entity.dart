import 'package:equatable/equatable.dart';

class ProductVariant extends Equatable {
  final String id;
  final String productId;

  final String sku;
  final double? priceOverride;

  final int stock;
  final int reservedStock;

  final Map<String, String> attributes;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.sku,
    this.priceOverride,
    required this.stock,
    this.reservedStock = 0,
    this.attributes = const {},
    this.createdAt,
    this.updatedAt,
  });

  ProductVariant copyWith({
    String? id,
    String? productId,
    String? sku,
    double? priceOverride,
    bool clearPriceOverride = false,
    int? stock,
    int? reservedStock,
    Map<String, String>? attributes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      priceOverride:
      clearPriceOverride ? null : (priceOverride ?? this.priceOverride),
      stock: stock ?? this.stock,
      reservedStock: reservedStock ?? this.reservedStock,
      attributes: attributes ?? this.attributes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    sku,
    priceOverride,
    stock,
    reservedStock,
    attributes,
    createdAt,
    updatedAt,
  ];
}