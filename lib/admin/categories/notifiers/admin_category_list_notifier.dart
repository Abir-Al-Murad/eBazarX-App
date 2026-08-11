import 'package:ebazarx/admin/categories/providers/admin_category_providers.dart';
import 'package:ebazarx/admin/categories/states/admin_category_list_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/usecases/fetch_all_categories_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminCategoryListNotifier extends StateNotifier<AdminCategoryListState> {
  final Ref ref;

  late final FetchAllCategories _fetchAllCategories;

  AdminCategoryListNotifier(this.ref) : super(const AdminCategoryListState()) {
    _fetchAllCategories = ref.read(fetchAllCategoriesUseCaseProvider);
  }

  // ============================================================
  // LOAD CATEGORIES
  // ============================================================

  Future<void> loadCategories({
    int skip = 0,
    int limit = 20,
    String? name,
    String? slug,
    String? parentId,
    bool? isActive,
    bool includeDeleted = false,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearFailure: true,

      skip: skip,
      limit: limit,

      name: name,
      slug: slug,
      parentId: parentId,
      isActive: isActive,
      includeDeleted: includeDeleted,
    );

    try {
      final categories = await _fetchAllCategories(
        skip: skip,
        limit: limit,
        name: name,
        slug: slug,
        parentId: parentId,
        isActive: isActive,
        includeDeleted: includeDeleted,
      );

      state = state.copyWith(
        isLoading: false,
        categories: categories,
        hasMore: categories.length >= limit,
        clearFailure: true,
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

  // ============================================================
  // LOAD MORE
  // ============================================================

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }

    final nextSkip = state.categories.length;

    state = state.copyWith(isLoadingMore: true, clearFailure: true);

    try {
      final categories = await _fetchAllCategories(
        skip: nextSkip,
        limit: state.limit,
        name: state.name,
        slug: state.slug,
        parentId: state.parentId,
        isActive: state.isActive,
        includeDeleted: state.includeDeleted,
      );

      state = state.copyWith(
        isLoadingMore: false,

        categories: [...state.categories, ...categories],

        skip: nextSkip,

        hasMore: categories.length >= state.limit,

        clearFailure: true,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoadingMore: false, failure: e);
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refresh() async {
    await loadCategories(
      skip: 0,
      limit: state.limit,

      name: state.name,
      slug: state.slug,
      parentId: state.parentId,
      isActive: state.isActive,
      includeDeleted: state.includeDeleted,
    );
  }

  // ============================================================
  // APPLY FILTERS
  // ============================================================

  Future<void> applyFilters({
    String? name,
    String? slug,
    String? parentId,
    bool? isActive,
    bool includeDeleted = false,
  }) async {
    await loadCategories(
      skip: 0,
      limit: state.limit,

      name: name,
      slug: slug,
      parentId: parentId,
      isActive: isActive,
      includeDeleted: includeDeleted,
    );
  }

  // ============================================================
  // CLEAR FILTERS
  // ============================================================

  Future<void> clearFilters() async {
    await loadCategories(skip: 0, limit: state.limit, includeDeleted: false);
  }

  // ============================================================
  // CLEAR FAILURE
  // ============================================================

  void clearFailure() {
    state = state.copyWith(clearFailure: true);
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clear() {
    state = const AdminCategoryListState();
  }
}
