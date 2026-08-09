import 'package:ebazarx/features/wish/domain/entities/wishlist_entity.dart';
import 'package:ebazarx/features/wish/domain/repositories/wish_repository.dart';

class GetWishListUseCase {
  final WishRepository _repository;

  GetWishListUseCase(this._repository);

  Future<WishlistEntity> call() {
    return _repository.getWishList();
  }
}