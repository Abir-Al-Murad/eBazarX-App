
import 'package:ebazarx/features/order/data/datasources/order_remote_data_source.dart';
import 'package:ebazarx/features/order/data/models/check_out_item_model.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  const OrderRepositoryImpl(this._remoteDataSource);

  /// Customer

  @override
  Future<OrderEntity> placeOrder({
    required String addressId,
    required List<CheckoutItemEntity> items,
    String? couponCode,
    String? notes,
  }) async {
    final order = await _remoteDataSource.placeOrder(
      addressId: addressId,
      items: items.map((e)=>CheckoutItemModel.fromEntity(e)).toList(),
      couponCode: couponCode,
      notes: notes,
    );

    return order.toEntity();
  }

  @override
  Future<List<OrderEntity>> getOrders({
    int skip = 0,
    int limit = 20,
  }) async {
    final orders = await _remoteDataSource.getOrders(
      skip: skip,
      limit: limit,
    );

    return orders.map((e) => e.toEntity()).toList();
  }

  @override
  Future<OrderEntity> getOrder({
    required String orderId,
  }) async {
    final order = await _remoteDataSource.getOrder(orderId);

    return order.toEntity();
  }

  @override
  Future<OrderEntity> cancelOrder({
    required String orderId,
  }) async {
    final order = await _remoteDataSource.cancelOrder(orderId);

    return order.toEntity();
  }

  /// Seller

  @override
  Future<List<OrderItemEntity>> getSellerOrderItems({
    int skip = 0,
    int limit = 20,
  }) async {
    final items = await _remoteDataSource.getSellerOrderItems(
      skip: skip,
      limit: limit,
    );

    return items.map((e) => e.toEntity()).toList();
  }

  @override
  Future<OrderItemEntity> updateOrderItemStatus({
    required String itemId,
    required String status,
  }) async {
    final item = await _remoteDataSource.updateOrderItemStatus(
      itemId: itemId,
      status: status,
    );

    return item.toEntity();
  }

  /// Admin

  @override
  Future<List<OrderEntity>> getAllOrders({
    int skip = 0,
    int limit = 20,
    String? status,
  }) async {
    final orders = await _remoteDataSource.getAllOrders(
      skip: skip,
      limit: limit,
      status: status,
    );

    return orders.map((e) => e.toEntity()).toList();
  }

  @override
  Future<OrderEntity> getOrderDetails({
    required String orderId,
  }) async {
    final order = await _remoteDataSource.getOrderDetails(orderId);

    return order.toEntity();
  }

  @override
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final order = await _remoteDataSource.updateOrderStatus(
      orderId: orderId,
      status: status,
    );

    return order.toEntity();
  }
}