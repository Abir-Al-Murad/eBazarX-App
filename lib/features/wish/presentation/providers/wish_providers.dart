import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/wish/data/datasources/wish_remote_data_source.dart';
import 'package:ebazarx/features/wish/data/repositories/wish_repository_impl.dart';
import 'package:ebazarx/features/wish/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:ebazarx/features/wish/domain/usecases/get_wishlist_usecase.dart';
import 'package:ebazarx/features/wish/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:ebazarx/features/wish/presentation/notifiers/wish_notifier.dart';
import 'package:ebazarx/features/wish/presentation/states/wish_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishRemoteDataSourceProvider = Provider((ref)=>WishRemoteDataSource(ref.read(apiClientProvider)));
final wishRepositoryProvider = Provider((ref)=>WishRepositoryImpl(ref.read(wishRemoteDataSourceProvider)));
final getWishListProvider = Provider((ref)=>GetWishListUseCase(ref.read(wishRepositoryProvider)));
final addToWishListProvider = Provider((ref)=>AddToWishListUseCase(ref.read(wishRepositoryProvider)));
final removeFromWishListProvider = Provider((ref)=>RemoveFromWishListUseCase(ref.read(wishRepositoryProvider)));

final wishNotifierProvider = StateNotifierProvider<WishNotifier, WishState>((ref){
  return WishNotifier(
    ref.read(getWishListProvider),
    ref.read(addToWishListProvider),
    ref.read(removeFromWishListProvider),
  );
});
