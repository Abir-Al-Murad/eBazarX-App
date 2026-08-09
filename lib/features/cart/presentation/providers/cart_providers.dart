import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:ebazarx/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:ebazarx/features/cart/domain/repositories/cart_repository.dart';
import 'package:ebazarx/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ebazarx/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ebazarx/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:ebazarx/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:ebazarx/features/cart/domain/usecases/update_cart_usecase.dart';
import 'package:ebazarx/features/cart/presentation/states/cart_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/cart_notifier.dart';


// Remote data source
final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CartRemoteDataSource(apiClient);
});

// Repository
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final remoteDataSource = ref.watch(cartRemoteDataSourceProvider);
  return CartRepositoryImpl(remoteDataSource);
});

// Use cases
final getCartUseCaseProvider = Provider<GetCartUseCase>((ref) {
  return GetCartUseCase(ref.watch(cartRepositoryProvider));
});

final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  return AddToCartUseCase(ref.watch(cartRepositoryProvider));
});

final updateCartItemUseCaseProvider = Provider<UpdateCartItemUseCase>((ref) {
  return UpdateCartItemUseCase(ref.watch(cartRepositoryProvider));
});

final removeCartItemUseCaseProvider = Provider<RemoveCartItemUseCase>((ref) {
  return RemoveCartItemUseCase(ref.watch(cartRepositoryProvider));
});

final clearCartUseCaseProvider = Provider<ClearCartUseCase>((ref) {
  return ClearCartUseCase(ref.watch(cartRepositoryProvider));
});

// Notifier
final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(
    getCartUseCase: ref.watch(getCartUseCaseProvider),
    addToCartUseCase: ref.watch(addToCartUseCaseProvider),
    updateCartItemUseCase: ref.watch(updateCartItemUseCaseProvider),
    removeCartItemUseCase: ref.watch(removeCartItemUseCaseProvider),
    clearCartUseCase: ref.watch(clearCartUseCaseProvider),
  );
});