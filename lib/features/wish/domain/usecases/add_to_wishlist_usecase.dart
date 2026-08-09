import 'package:ebazarx/features/wish/domain/repositories/wish_repository.dart';

class AddToWishListUseCase {
  final WishRepository _repository;

  AddToWishListUseCase(this._repository);

  Future<void> call(String variantId) {
    return _repository.addToWishList(variantId);
  }
}