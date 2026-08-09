import '../../domain/entities/order_item_entity.dart';
import '../../domain/entities/order_status.dart';

class OrderItemModel {
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

  const OrderItemModel({
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

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productNameAtTime: json['product_name_at_time'],
      productImageAtTime: json['product_image_at_time'],
      priceAtTime: double.parse(json['price_at_time'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      sizeAtTime: json['size_at_time'],
      colorAtTime: json['color_at_time'],
      status: OrderStatus.values.byName(json['status'].toString().toLowerCase()),
      productId: json['product_id'],
      variantId: json['variant_id'],
      sellerId: json['seller_id'],
    );
  }

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      id: entity.id,
      productNameAtTime: entity.productNameAtTime,
      productImageAtTime: entity.productImageAtTime,
      priceAtTime: entity.priceAtTime,
      quantity: entity.quantity,
      sizeAtTime: entity.sizeAtTime,
      colorAtTime: entity.colorAtTime,
      status: entity.status,
      productId: entity.productId,
      variantId: entity.variantId,
      sellerId: entity.sellerId,
    );
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id,
      productNameAtTime: productNameAtTime,
      productImageAtTime: productImageAtTime,
      priceAtTime: priceAtTime,
      quantity: quantity,
      sizeAtTime: sizeAtTime,
      colorAtTime: colorAtTime,
      status: status,
      productId: productId,
      variantId: variantId,
      sellerId: sellerId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_name_at_time': productNameAtTime,
    'price_at_time': priceAtTime,
    'product_image_at_time': productImageAtTime,
    'quantity': quantity,
    'size_at_time': sizeAtTime,
    'color_at_time': colorAtTime,
    'status': status.name,
    'product_id': productId,
    'variant_id': variantId,
    'seller_id': sellerId,
  };
}