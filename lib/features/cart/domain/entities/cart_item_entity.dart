import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final String variantId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final double total;
  final Map<String, String>? variantAttributes;
  final String? productImage;

  const CartItemEntity({
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

  @override
  List<Object?> get props => [
    id,
    variantId,
    productId,
    productName,
    price,
    quantity,
    total,
    variantAttributes,
    productImage,
  ];
}