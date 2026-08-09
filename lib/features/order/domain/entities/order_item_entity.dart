import 'package:equatable/equatable.dart';

import 'order_status.dart';

class OrderItemEntity extends Equatable {
  final String id;
  final String productNameAtTime;
  final String? productImageAtTime;
  final double priceAtTime;
  final int quantity;
  final String? sizeAtTime;
  final String? colorAtTime;
  final OrderStatus status;
  final String productId;
  final String variantId;
  final String sellerId;

  const OrderItemEntity({
    required this.id,
    required this.productNameAtTime,
    required this.priceAtTime,
    required this.quantity,
    this.sizeAtTime,
    this.colorAtTime,
    this.productImageAtTime,
    required this.status,
    required this.productId,
    required this.variantId,
    required this.sellerId,
  });

  @override
  List<Object?> get props => [
    id,
    productNameAtTime,
    productImageAtTime,
    priceAtTime,
    quantity,
    sizeAtTime,
    colorAtTime,
    status,
    productId,
    variantId,
    sellerId,
  ];
}