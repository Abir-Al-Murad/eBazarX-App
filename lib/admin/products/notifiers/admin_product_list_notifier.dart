import 'package:ebazarx/admin/products/states/admin_product_list_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/usecases/fetch_all_product_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminProductListNotifier extends StateNotifier<AdminProductListState> {
  final FetchAllProductsUseCase _fetchAllProductsUseCase;
  static const int _pageSize = 20;
  AdminProductListNotifier(this._fetchAllProductsUseCase)
    : super(AdminProductListState());

  // ============================================================
  // Initial Fetch
  // ============================================================

  Future<void> fetchProducts() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true,products: [],hasMore: true);

    try {
      final result = await _fetchAllProductsUseCase();
      state = state.copyWith(
        isLoading: false,
        products: result,
      );
    }on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    }catch (e){
      state = state.copyWith(isLoading: false, failure: UnknownFailure(e.toString()));
    }
  }

  // ============================================================
  // Load More / Pagination
  // ============================================================

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      // Add your pagination parameters here
      //
      // Example:
      // final result = await _fetchAllProductsUseCase(
      //   page: currentPage + 1,
      //   limit: 20,
      // );
      final result = await _fetchAllProductsUseCase(skip: state.products.length,limit: 20);
      state = state.copyWith(
        isLoadingMore: false,
        products: [...state.products, ...result],
        hasMore: result.length == _pageSize,
      );

    } on Failure catch(e) {
      state = state.copyWith(isLoadingMore: false, failure: e);
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, failure: UnknownFailure(e.toString()));
    }
  }

  // ============================================================
  // Refresh
  // ============================================================

  Future<void> refresh() async {
    state = AdminProductListState();

    await fetchProducts();
  }

}
