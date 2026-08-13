import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_place_response_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  const OrderRepositoryImpl(this._remoteDataSource);

  @override
  Future<OrderPlaceResponseEntity> placeOrder({
    required String addressId,
    required List<CheckoutItemEntity> items,
    required String paymentMethod,
    String? couponCode,
    String? notes,
    String? successUrl,
    String? cancelUrl,
  }) async {
    final response = await _remoteDataSource.placeOrder(
      addressId: addressId,
      items: items,
      paymentMethod: paymentMethod,
      couponCode: couponCode,
      notes: notes,
      successUrl: successUrl,
      cancelUrl: cancelUrl,
    );
    return response.toEntity();
  }

  @override
  Future<List<OrderEntity>> getOrders({int skip = 0, int limit = 20}) async {
    final models = await _remoteDataSource.getOrders(skip: skip, limit: limit);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<OrderEntity> getOrder({required String orderId}) async {
    final model = await _remoteDataSource.getOrder(orderId);
    return model.toEntity();
  }

  @override
  Future<OrderEntity> cancelOrder({required String orderId}) async {
    final model = await _remoteDataSource.cancelOrder(orderId);
    return model.toEntity();
  }

  @override
  Future<OrderEntity> confirmPayment(String orderId, String paymentIntentId) async {
    final model = await _remoteDataSource.confirmPayment(orderId, paymentIntentId);
    return model.toEntity();
  }

  @override
  Future<List<OrderItemEntity>> getSellerOrderItems({int skip = 0, int limit = 20}) async {
    final models = await _remoteDataSource.getSellerOrderItems(skip: skip, limit: limit);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<OrderItemEntity> updateOrderItemStatus({
    required String itemId,
    required String status,
  }) async {
    final model = await _remoteDataSource.updateOrderItemStatus(itemId: itemId, status: status);
    return model.toEntity();
  }

  @override
  Future<List<OrderEntity>> getAllOrders({
    int skip = 0,
    int limit = 20,
    String? status,
  }) async {
    final models = await _remoteDataSource.getAllOrders(skip: skip, limit: limit, status: status);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<OrderEntity> getOrderDetails({required String orderId}) async {
    final model = await _remoteDataSource.getOrderDetails(orderId);
    return model.toEntity();
  }

  @override
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final model = await _remoteDataSource.updateOrderStatus(orderId: orderId, status: status);
    return model.toEntity();
  }

  @override
  Future<OrderEntity> updateOrderPaymentStatus({
    required String orderId,
    required String paymentStatus,
  }) async {
    final model = await _remoteDataSource.updateOrderPaymentStatus(
      orderId: orderId,
      paymentStatus: paymentStatus,
    );
    return model.toEntity();
  }
}