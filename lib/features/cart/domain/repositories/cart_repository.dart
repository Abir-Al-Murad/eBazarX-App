import 'package:ebazarx/features/cart/domain/entities/cart_entity.dart';

abstract class CartRepository {
  Future<CartEntity> getCart();
  Future<void> addToCart({required String variantId, required int quantity});
  Future<void> updateCartItem({required String itemId, required int quantity});
  Future<void> removeCartItem(String itemId);
  Future<void> clearCart();
}