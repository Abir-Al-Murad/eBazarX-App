import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String? id;
  final List<CartItemEntity> items;
  final double subtotal;
  final int totalItems;

  const CartEntity({
    this.id,
    required this.items,
    required this.subtotal,
    required this.totalItems,
  });

  CartEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    double? subtotal,
    int? totalItems,
  }) {
    return CartEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  @override
  List<Object?> get props => [id, items, subtotal, totalItems];
}