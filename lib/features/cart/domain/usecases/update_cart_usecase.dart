import '../repositories/cart_repository.dart';

class UpdateCartItemUseCase {
  final CartRepository _repository;

  UpdateCartItemUseCase(this._repository);

  Future<void> call({
    required String itemId,
    required int quantity,
  }) {
    return _repository.updateCartItem(itemId: itemId, quantity: quantity);
  }
}