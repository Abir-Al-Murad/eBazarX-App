import '../repositories/cart_repository.dart';

class RemoveCartItemUseCase {
  final CartRepository _repository;

  RemoveCartItemUseCase(this._repository);

  Future<void> call(String itemId) => _repository.removeCartItem(itemId);
}