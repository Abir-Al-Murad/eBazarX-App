import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ebazarx/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:ebazarx/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:ebazarx/features/cart/domain/usecases/update_cart_usecase.dart';
import 'package:ebazarx/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ebazarx/features/cart/presentation/states/cart_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CartNotifier extends StateNotifier<CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartNotifier({
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
    required UpdateCartItemUseCase updateCartItemUseCase,
    required RemoveCartItemUseCase removeCartItemUseCase,
    required ClearCartUseCase clearCartUseCase,
  })  : _getCartUseCase = getCartUseCase,
        _addToCartUseCase = addToCartUseCase,
        _updateCartItemUseCase = updateCartItemUseCase,
        _removeCartItemUseCase = removeCartItemUseCase,
        _clearCartUseCase = clearCartUseCase,
        super(const CartState());


  void reset(){
    state = const CartState();
  }
  Future<void> fetchCart({bool refresh = false}) async {
    if (AuthStorage.accessToken == null) {
      state = state.copyWith(
        isLoading: false,
        cart: null,
        clearFailure: true,
      );
      return;
    }

    if (state.isLoading && !refresh) return;

    if (!refresh) {
      state = state.copyWith(
        isLoading: true,
        clearFailure: true,
      );
    } else {
      state = state.copyWith(
        clearFailure: true,
      );
    }

    try {
      final cart = await _getCartUseCase();

      state = state.copyWith(
        isLoading: false,
        cart: cart,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        cartListFailure: e,
      );
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);

      state = state.copyWith(
        isLoading: false,
        cartListFailure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> refresh() => fetchCart(refresh: true);

  Future<void> addToCart({
    required String variantId,
    required int quantity,
  }) async {
    state = state.copyWith(
      isUpdating: true,
      clearFailure: true,
    );

    try {
      await _addToCartUseCase(variantId: variantId, quantity: quantity);
      // Refresh cart after adding
      await fetchCart(refresh: true);
      state = state.copyWith(isUpdating: false);
    } on Failure catch (e) {
      state = state.copyWith(
        isUpdating: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    if (state.updatingItemIds.contains(itemId)) return;

    // final loadingSet = {...state.updatingItemIds};
    // loadingSet.add(itemId);

    state = state.copyWith(
      // updatingItemIds: loadingSet,
      clearFailure: true,
    );

    try {
      await _updateCartItemUseCase(itemId: itemId, quantity: quantity);
      await fetchCart(refresh: true);
      // loadingSet.remove(itemId);
      // state = state.copyWith(updatingItemIds: loadingSet);
    } on Failure catch (e) {
      // loadingSet.remove(itemId);
      state = state.copyWith(
        // updatingItemIds: loadingSet,
        failure: e,
      );
    } catch (e) {
      // loadingSet.remove(itemId);
      state = state.copyWith(
        // updatingItemIds: loadingSet,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> removeCartItem(String itemId) async {
    if (state.removingItemIds.contains(itemId)) return;

    final loadingSet = {...state.removingItemIds};
    loadingSet.add(itemId);

    state = state.copyWith(
      removingItemIds: loadingSet,
      clearFailure: true,
    );

    try {
      await _removeCartItemUseCase(itemId);
      await fetchCart(refresh: true);
      loadingSet.remove(itemId);
      state = state.copyWith(removingItemIds: loadingSet);
    } on Failure catch (e) {
      loadingSet.remove(itemId);
      state = state.copyWith(
        removingItemIds: loadingSet,
        failure: e,
      );
    } catch (e) {
      loadingSet.remove(itemId);
      state = state.copyWith(
        removingItemIds: loadingSet,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> clearCart() async {
    state = state.copyWith(
      isClearing: true,
      clearFailure: true,
    );

    try {
      await _clearCartUseCase();
      await fetchCart(refresh: true);
      state = state.copyWith(isClearing: false);
    } on Failure catch (e) {
      state = state.copyWith(
        isClearing: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isClearing: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }
}