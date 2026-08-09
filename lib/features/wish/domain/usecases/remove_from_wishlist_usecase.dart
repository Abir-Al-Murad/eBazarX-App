import 'package:ebazarx/features/wish/domain/repositories/wish_repository.dart';

class RemoveFromWishListUseCase {
  final WishRepository _repository;

  RemoveFromWishListUseCase(this._repository);

  Future<void> call(String itemId) {
    return _repository.removeFromWishList(itemId);
  }
}