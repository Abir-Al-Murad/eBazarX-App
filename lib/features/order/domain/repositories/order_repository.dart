import 'package:ebazarx/features/order/data/models/order_item_model.dart';
import 'package:ebazarx/features/order/data/models/order_model.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';

abstract class OrderRepository {
  /// Customer

  Future<OrderEntity> placeOrder({
    required String addressId,
    required List<CheckoutItemEntity> items,
    String? couponCode,
    String? notes,
  });

  Future<List<OrderEntity>> getOrders({
    int skip = 0,
    int limit = 20,
  });

  Future<OrderEntity> getOrder({
    required String orderId,
  });

  Future<OrderEntity> cancelOrder({
    required String orderId,
  });

  /// Seller

  Future<List<OrderItemEntity>> getSellerOrderItems({
    int skip = 0,
    int limit = 20,
  });

  Future<OrderItemEntity> updateOrderItemStatus({
    required String itemId,
    required String status,
  });

  /// Admin

  Future<List<OrderEntity>> getAllOrders({
    int skip = 0,
    int limit = 20,
    String? status,
  });

  Future<OrderEntity> getOrderDetails({
    required String orderId,
  });

  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required String status,
  });
}