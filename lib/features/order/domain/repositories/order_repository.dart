import 'package:ebazarx/features/order/data/models/order_item_model.dart';
import 'package:ebazarx/features/order/data/models/order_model.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_place_response_entity.dart';

abstract class OrderRepository {
  /// Customer

  Future<OrderPlaceResponseEntity> placeOrder({
    required String addressId,
    required List<CheckoutItemEntity> items,
    required String paymentMethod,
    String? couponCode,
    String? notes,
    String? successUrl,
    String? cancelUrl,
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

  Future<OrderEntity> confirmPayment(String orderId, String paymentIntentId);

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


  Future<OrderEntity> updateOrderPaymentStatus({
    required String orderId,
    required String paymentStatus,
  });
}