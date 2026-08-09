import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/usecases/fetch_public_products.dart';
import 'package:ebazarx/features/product/presentation/states/user_product_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProductListNotifier extends StateNotifier<UserProductListState> {
  final FetchPublicProductsUseCase _fetchPublicProductsUseCase;

  UserProductListNotifier(this._fetchPublicProductsUseCase)
      : super(const UserProductListState());

  Future<void> fetchProducts({
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
      products: refresh ? [] : state.products,
      skip: refresh ? 0 : state.skip,
      hasMore: refresh ? true : state.hasMore,
    );

    try {
      final products = await _fetchPublicProductsUseCase(
        skip: state.skip,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoading: false,
        products: [
          ...state.products,
          ...products,
        ],
        skip: state.skip + products.length,
        hasMore: products.length == state.limit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    state = state.copyWith(
      isLoadingMore: true,
      clearFailure: true,
    );

    try {
      final products = await _fetchPublicProductsUseCase(
        skip: state.skip,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoadingMore: false,
        products: [
          ...state.products,
          ...products,
        ],
        skip: state.skip + products.length,
        hasMore: products.length == state.limit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> refresh() => fetchProducts(refresh: true);
}