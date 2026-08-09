import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/usecases/fetch_categories_usecase.dart';
import 'package:ebazarx/features/category/presentation/states/fetch_category_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FetchCategoryListNotifier extends StateNotifier<FetchCategoryListState> {
  final FetchCategoriesUseCase _fetchCategoriesUseCase;

  FetchCategoryListNotifier(this._fetchCategoriesUseCase)
    : super(const FetchCategoryListState());

  /// First load / Pull to refresh
  Future<void> fetchCategories({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      clearFailure: true,
      clearLoadMoreFailure: true,
      categories: refresh ? [] : state.categories,
      skip: refresh ? 0 : state.skip,
      hasMore: refresh ? true : state.hasMore,
    );

    try {
      final categories = await _fetchCategoriesUseCase(
        skip: refresh ? 0 : state.skip,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoading: false,
        categories: categories,
        skip: categories.length,
        hasMore: categories.length >= state.limit,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  /// Infinite Scroll
  Future<void> loadMoreCategories() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true);

    try {
      final categories = await _fetchCategoriesUseCase(
        skip: state.skip,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoadingMore: false,
        categories: [...state.categories, ...categories],
        skip: state.skip + categories.length,
        hasMore: categories.length >= state.limit,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoadingMore: false, loadMoreFailure: e);
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreFailure: UnknownFailure(e.toString()),
      );
    }
  }

  /// Retry after error
  Future<void> retry() => fetchCategories(refresh: true);

  /// Reset state
  void reset() {
    state = const FetchCategoryListState();
  }
}
