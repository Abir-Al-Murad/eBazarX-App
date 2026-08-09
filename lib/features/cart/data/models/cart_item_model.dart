import 'package:ebazarx/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel {
  final String id;
  final String variantId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final double total;
  final Map<String, String>? variantAttributes;
  final String? productImage;

  const CartItemModel({
    required this.id,
    required this.variantId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.total,
    this.variantAttributes,
    this.productImage,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      variantId: json['variant_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      total: double.parse(json['total'].toString()),
      variantAttributes: json['variant_attributes'] != null
          ? Map<String, String>.from(json['variant_attributes'])
          : null,
      productImage: json['product_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_id': variantId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'total': total,
      'variant_attributes': variantAttributes,
      'product_image': productImage,
    };
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      variantId: variantId,
      productId: productId,
      productName: productName,
      price: price,
      quantity: quantity,
      total: total,
      variantAttributes: variantAttributes,
      productImage: productImage,
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      variantId: entity.variantId,
      productId: entity.productId,
      productName: entity.productName,
      price: entity.price,
      quantity: entity.quantity,
      total: entity.total,
      variantAttributes: entity.variantAttributes,
      productImage: entity.productImage,
    );
  }

  CartItemModel copyWith({
    String? id,
    String? variantId,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    double? total,
    Map<String, String>? variantAttributes,
    String? productImage,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      variantAttributes: variantAttributes ?? this.variantAttributes,
      productImage: productImage ?? this.productImage,
    );
  }
}