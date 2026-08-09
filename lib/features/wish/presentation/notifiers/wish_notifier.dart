import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/features/auth/presentation/states/auth_state.dart';
import 'package:ebazarx/features/wish/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:ebazarx/features/wish/domain/usecases/get_wishlist_usecase.dart';
import 'package:ebazarx/features/wish/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:ebazarx/features/wish/presentation/states/wish_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishNotifier extends StateNotifier<WishState> {
  final GetWishListUseCase _getWishListUseCase;
  final AddToWishListUseCase _addToWishListUseCase;
  final RemoveFromWishListUseCase _removeFromWishListUseCase;

  WishNotifier(
      this._getWishListUseCase,
      this._addToWishListUseCase,
      this._removeFromWishListUseCase,
      ) : super(const WishState());

  Future<void> fetchWishList({
    bool refresh = false,
  }) async {
    print("From WishNotifier : ${AuthStorage.accessToken}");
    if(!AuthStorage.instance.isLoggedIn) return;
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
      skip: refresh ? 0 : state.skip,
      hasMore: refresh ? true : state.hasMore,
    );

    try {
      final wishlist = await _getWishListUseCase();

      state = state.copyWith(
        isLoading: false,
        wishlist: wishlist,
        skip: wishlist.items.length,
        hasMore: wishlist.items.length >= state.limit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    } catch (e,s) {
      debugPrint(s.toString());
      debugPrint(e.toString());

      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> refresh() => fetchWishList(refresh: true);

  // Future<void> loadMore() async {
  //   if (state.isLoading ||
  //       state.isLoadingMore ||
  //       !state.hasMore) {
  //     return;
  //   }
  //
  //   state = state.copyWith(
  //     isLoadingMore: true,
  //     clearFailure: true,
  //   );
  //
  //   try {
  //     final wishlist = await _getWishListUseCase();
  //
  //     final current = state.wishlist;
  //
  //     if (current == null) {
  //       state = state.copyWith(
  //         wishlist: wishlist,
  //         isLoadingMore: false,
  //       );
  //       return;
  //     }
  //
  //     final updated = current.copyWith(
  //       items: [
  //         ...current.items,
  //         ...wishlist.items,
  //       ],
  //       totalItems: wishlist.totalItems,
  //     );
  //
  //     state = state.copyWith(
  //       wishlist: updated,
  //       skip: state.skip + wishlist.items.length,
  //       hasMore: wishlist.items.length == state.limit,
  //       isLoadingMore: false,
  //     );
  //   } on Failure catch (e) {
  //     state = state.copyWith(
  //       isLoadingMore: false,
  //       failure: e,
  //     );
  //   } catch (e) {
  //     state = state.copyWith(
  //       isLoadingMore: false,
  //       failure: UnknownFailure(e.toString()),
  //     );
  //   }
  // }

  Future<void> addToWishList(String variantId) async {
    if (state.addingVariantIds.contains(variantId)) return;

    final loadingSet = {...state.addingVariantIds};
    loadingSet.add(variantId);

    state = state.copyWith(
      addingVariantIds: loadingSet,
      clearFailure: true,
    );

    try {
      await _addToWishListUseCase(variantId);

      loadingSet.remove(variantId);

      state = state.copyWith(
        addingVariantIds: loadingSet,
      );

      // Sync with server
      await fetchWishList(refresh: true);
    } on Failure catch (e) {
      loadingSet.remove(variantId);

      state = state.copyWith(
        addingVariantIds: loadingSet,
        failure: e,
      );
    } catch (e) {
      loadingSet.remove(variantId);

      state = state.copyWith(
        addingVariantIds: loadingSet,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> removeFromWishList(String itemId) async {
    if (state.removingItemIds.contains(itemId)) return;

    final loadingSet = {...state.removingItemIds};
    loadingSet.add(itemId);

    state = state.copyWith(
      removingItemIds: loadingSet,
      clearFailure: true,
    );

    try {
      await _removeFromWishListUseCase(itemId);

      loadingSet.remove(itemId);

      final wishlist = state.wishlist;

      if (wishlist != null) {
        final updated = wishlist.copyWith(
          items: wishlist.items
              .where((e) => e.id != itemId)
              .toList(),
          totalItems: wishlist.totalItems - 1,
        );

        state = state.copyWith(
          wishlist: updated,
          removingItemIds: loadingSet,
        );
      } else {
        state = state.copyWith(
          removingItemIds: loadingSet,
        );
      }
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

  Future<void> toggleWishlist({
    required String variantId,
    String? itemId,
  }) async {
    if (state.isInWishlist(variantId)) {
      await removeFromWishList(itemId!);
    } else {
      await addToWishList(variantId);
    }
  }

  void clearWishList() {
    state = const WishState();
  }
}