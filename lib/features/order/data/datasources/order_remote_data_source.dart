import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/order/data/models/order_item_model.dart';
import 'package:ebazarx/features/order/data/models/check_out_item_model.dart';
import 'package:ebazarx/features/order/data/models/order_model.dart';
import 'package:ebazarx/features/order/data/models/order_place_response_model.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';


class OrderRemoteDataSource {
  final ApiClient _apiClient;

  const OrderRemoteDataSource(this._apiClient);

  /// Customer

  Future<OrderPlaceResponseModel> placeOrder({
    required String addressId,
    required List<CheckoutItemEntity> items,
    required String paymentMethod,
    String? couponCode,
    String? notes,
    String? successUrl,
    String? cancelUrl,
  }) async {
    final response = await _apiClient.post(
      '/customer/orders/',
      data: {
        'address_id': addressId,
        'items': items.map((e) => {'variant_id': e.variant_id, 'quantity': e.quantity}).toList(),
        'payment_method': paymentMethod,
        'coupon_code': couponCode,
        'notes': notes,
        'success_url': successUrl,   // for SSLCommerz
        'cancel_url': cancelUrl,     // for SSLCommerz
      },
    );

    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to place order');
    }

    return OrderPlaceResponseModel.fromJson(response.body);
  }

  Future<List<OrderModel>> getOrders({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/customer/orders/?skip=$skip&limit=$limit',
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to fetch orders');
    }

    return (response.body as List)
        .map((e) => OrderModel.fromJson(e))
        .toList();
  }

  Future<OrderModel> getOrder(String orderId) async {
    final response = await _apiClient.get('/customer/orders/$orderId');

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to fetch order');
    }

    return OrderModel.fromJson(response.body);
  }

  Future<OrderModel> cancelOrder(String orderId) async {
    final response = await _apiClient.put('/customer/orders/$orderId/cancel');

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to cancel order');
    }

    return OrderModel.fromJson(response.body);
  }

  Future<OrderModel> confirmPayment(String orderId, String paymentIntentId) async {
    final response = await _apiClient.post(
      '/payments/confirm',
      data: {
        'order_id': orderId,
        'payment_intent_id': paymentIntentId,
      },
    );
    if (!response.isSuccess) {
      throw response.failure ?? Exception('Payment confirmation failed');
    }
    return OrderModel.fromJson(response.body);
  }



  /// Seller

  Future<List<OrderItemModel>> getSellerOrderItems({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/seller/orders/items?skip=$skip&limit=$limit',
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to fetch seller orders');
    }

    return (response.body as List)
        .map((e) => OrderItemModel.fromJson(e))
        .toList();
  }

  Future<OrderItemModel> updateOrderItemStatus({
    required String itemId,
    required String status,
  }) async {
    final response = await _apiClient.put(
      '/seller/orders/items/$itemId/status',
      data: {'status': status},
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ??
              'Failed to update order item status');
    }

    return OrderItemModel.fromJson(response.body);
  }

  /// Admin

  Future<List<OrderModel>> getAllOrders({
    int skip = 0,
    int limit = 20,
    String? status,
  }) async {
    var endpoint = '/admin/orders?skip=$skip&limit=$limit';

    if (status != null) {
      endpoint += '&status=$status';
    }

    final response = await _apiClient.get(endpoint);

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to fetch all orders');
    }

    return (response.body as List)
        .map((e) => OrderModel.fromJson(e))
        .toList();
  }

  Future<OrderModel> getOrderDetails(String orderId) async {
    final response = await _apiClient.get('/admin/orders/$orderId');

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to fetch order details');
    }

    return OrderModel.fromJson(response.body);
  }

  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final response = await _apiClient.put(
      '/admin/orders/$orderId/status',
      data: {'status': status},
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to update order status');
    }

    return OrderModel.fromJson(response.body);
  }
}