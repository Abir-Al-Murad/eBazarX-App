import 'package:ebazarx/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:ebazarx/features/cart/domain/entities/cart_entity.dart';
import 'package:ebazarx/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  const CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<CartEntity> getCart() async {
    final cart = await _remoteDataSource.getCart();
    return cart.toEntity();
  }

  @override
  Future<void> addToCart({required String variantId, required int quantity}) {
    return _remoteDataSource.addToCart(variantId: variantId, quantity: quantity);
  }

  @override
  Future<void> updateCartItem({required String itemId, required int quantity}) {
    return _remoteDataSource.updateCartItem(itemId: itemId, quantity: quantity);
  }

  @override
  Future<void> removeCartItem(String itemId) {
    return _remoteDataSource.removeCartItem(itemId);
  }

  @override
  Future<void> clearCart() {
    return _remoteDataSource.clearCart();
  }
}