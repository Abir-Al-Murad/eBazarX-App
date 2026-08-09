import 'package:ebazarx/features/cart/domain/entities/cart_entity.dart';

import 'cart_item_model.dart';


class CartModel {
  final String? id;
  final List<CartItemModel> items;
  final double subtotal;
  final int totalItems;

  const CartModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.totalItems,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      subtotal: double.parse(json['subtotal'].toString()),
      totalItems: json['total_items'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'total_items': totalItems,
    };
  }

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      items: items.map((e) => e.toEntity()).toList(),
      subtotal: subtotal,
      totalItems: totalItems,
    );
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      id: entity.id,
      items: entity.items.map(CartItemModel.fromEntity).toList(),
      subtotal: entity.subtotal,
      totalItems: entity.totalItems,
    );
  }

  CartModel copyWith({
    String? id,
    List<CartItemModel>? items,
    double? subtotal,
    int? totalItems,
  }) {
    return CartModel(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}