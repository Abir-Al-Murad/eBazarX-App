import 'package:ebazarx/features/wish/domain/repositories/wish_repository.dart';

class RemoveFromWishlistByVariantUseCase {
  final WishRepository _wishRepository;
  RemoveFromWishlistByVariantUseCase(this._wishRepository);
  Future<void> call(String variantId) async {
    await _wishRepository.removeFromWishListByVariant(variantId);
  }
}