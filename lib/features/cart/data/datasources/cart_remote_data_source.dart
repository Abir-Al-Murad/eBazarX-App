import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/cart/data/models/cart_model.dart';

class CartRemoteDataSource {
  final ApiClient _apiClient;

  const CartRemoteDataSource(this._apiClient);

  Future<CartModel> getCart() async {
    final response = await _apiClient.get('/customer/cart/');
    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to fetch cart');
    }
    return CartModel.fromJson(response.body);
  }

  Future<void> addToCart({
    required String variantId,
    required int quantity,
  }) async {
    final response = await _apiClient.post(
      '/customer/cart/items',
      data: {
        'variant_id': variantId,
        'quantity': quantity,
      },
    );
    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to add to cart');
    }
  }

  Future<void> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    final response = await _apiClient.put(
      '/customer/cart/items/$itemId',
      data: {'quantity': quantity},
    );
    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to update cart item');
    }
  }

  Future<void> removeCartItem(String itemId) async {
    final response = await _apiClient.delete('/customer/cart/items/$itemId');
    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to remove cart item');
    }
  }

  Future<void> clearCart() async {
    final response = await _apiClient.delete('/customer/cart/clear');
    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to clear cart');
    }
  }
}