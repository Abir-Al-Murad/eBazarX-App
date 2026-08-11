import 'package:ebazarx/features/wish/data/datasources/wish_remote_data_source.dart';
import 'package:ebazarx/features/wish/domain/entities/wishlist_entity.dart';
import 'package:ebazarx/features/wish/domain/repositories/wish_repository.dart';

class WishRepositoryImpl implements WishRepository {
  final WishRemoteDataSource _remoteDataSource;

  WishRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> addToWishList(String variantId) {
    return _remoteDataSource.addToWishList(variantId);
  }

  @override
  Future<void> removeFromWishList(String itemId) {
    return _remoteDataSource.removeFromWishList(itemId);
  }

  @override
  Future<WishlistEntity> getWishList() async {
    final wishlist = await _remoteDataSource.getWishList();
    return wishlist.toEntity();
  }

  @override
  Future<void> removeFromWishListByVariant(String variantId) {
    return _remoteDataSource.removeFromWishListByVariant(variantId);
  }
}