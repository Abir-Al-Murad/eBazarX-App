import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<void> call({
    required String variantId,
    required int quantity,
  }) {
    return _repository.addToCart(variantId: variantId, quantity: quantity);
  }
}