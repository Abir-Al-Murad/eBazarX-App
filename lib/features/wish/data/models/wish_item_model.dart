import 'package:ebazarx/features/wish/domain/entities/wish_item_entity.dart';

class WishlistItemModel {
  final String id;
  final String variantId;
  final String productId;
  final String productName;
  final double price;
  final Map<String, String>? variantAttributes;
  final String? productImage;
  final DateTime addedAt;

  const WishlistItemModel({
    required this.id,
    required this.variantId,
    required this.productId,
    required this.productName,
    required this.price,
    this.variantAttributes,
    this.productImage,
    required this.addedAt,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'],
      variantId: json['variant_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      price: double.parse(json['price'].toString()),
      variantAttributes: json['variant_attributes'] != null
          ? Map<String, String>.from(json['variant_attributes'])
          : null,
      productImage: json['product_image'],
      addedAt: DateTime.parse(json['added_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_id': variantId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'variant_attributes': variantAttributes,
      'product_image': productImage,
      'added_at': addedAt.toIso8601String(),
    };
  }

  WishlistItem toEntity() {
    return WishlistItem(
      id: id,
      variantId: variantId,
      productId: productId,
      productName: productName,
      price: price,
      variantAttributes: variantAttributes,
      productImage: productImage,
      addedAt: addedAt,
    );
  }

  factory WishlistItemModel.fromEntity(WishlistItem entity) {
    return WishlistItemModel(
      id: entity.id,
      variantId: entity.variantId,
      productId: entity.productId,
      productName: entity.productName,
      price: entity.price,
      variantAttributes: entity.variantAttributes,
      productImage: entity.productImage,
      addedAt: entity.addedAt,
    );
  }

  WishlistItemModel copyWith({
    String? id,
    String? variantId,
    String? productId,
    String? productName,
    double? price,
    Map<String, String>? variantAttributes,
    String? productImage,
    DateTime? addedAt,
  }) {
    return WishlistItemModel(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      variantAttributes: variantAttributes ?? this.variantAttributes,
      productImage: productImage ?? this.productImage,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}