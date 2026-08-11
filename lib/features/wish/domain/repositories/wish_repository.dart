import 'package:ebazarx/features/wish/domain/entities/wishlist_entity.dart';

abstract class WishRepository {
  Future<void> addToWishList(String variantId);

  Future<void> removeFromWishList(String itemId);
  Future<void> removeFromWishListByVariant(String variantId);

  Future<WishlistEntity> getWishList();
}