import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/usecases/fetch_categories_usecase.dart';
import 'package:ebazarx/features/category/domain/usecases/get_child_categories.dart';
import 'package:ebazarx/features/category/presentation/states/category_selection_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelectionNotifier
    extends StateNotifier<CategorySelectionState> {
  final FetchCategoriesUseCase _fetchCategoriesUseCase;
  final GetChildCategoriesUseCase _getChildCategoriesUseCase;

  CategorySelectionNotifier(
      this._fetchCategoriesUseCase,
      this._getChildCategoriesUseCase,
      ) : super(const CategorySelectionState());

  /// -------------------------------
  /// Load Root Categories
  /// -------------------------------
  Future<void> loadRootCategories() async {
    if (state.rootCategories.isNotEmpty) return;

    state = state.copyWith(
      isLoadingRoot: true,
      clearRootFailure: true,
    );

    try {
      final categories = await _fetchCategoriesUseCase(
        skip: 0,
        limit: 100,
      );

      state = state.copyWith(
        isLoadingRoot: false,
        rootCategories: categories,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoadingRoot: false,
        rootFailure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingRoot: false,
        rootFailure: UnknownFailure(e.toString()),
      );
    }
  }

  /// -------------------------------
  /// Load Children
  /// -------------------------------
  Future<void> loadChildren(String parentId) async {
    if (state.childrenMap.containsKey(parentId)) return;

    state = state.copyWith(
      loadingMap: {
        ...state.loadingMap,
        parentId: true,
      },
      errorMap: {
        ...state.errorMap,
      }..remove(parentId),
    );

    try {
      final children = await _getChildCategoriesUseCase(parentId);

      state = state.copyWith(
        childrenMap: {
          ...state.childrenMap,
          parentId: children,
        },
        loadingMap: {
          ...state.loadingMap,
          parentId: false,
        },
      );
    } on Failure catch (e) {
      state = state.copyWith(
        loadingMap: {
          ...state.loadingMap,
          parentId: false,
        },
        errorMap: {
          ...state.errorMap,
          parentId: e,
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingMap: {
          ...state.loadingMap,
          parentId: false,
        },
        errorMap: {
          ...state.errorMap,
          parentId: UnknownFailure(e.toString()),
        },
      );
    }
  }

  /// -------------------------------
  /// Select Category
  /// -------------------------------
  Future<void> selectCategory(
      int level,
      String categoryId,
      ) async {
    final path = [...state.selectedPath];

    if (path.length > level) {
      path.removeRange(level, path.length);
    }

    path.add(categoryId);

    state = state.copyWith(selectedPath: path);

    await loadChildren(categoryId);
  }

  /// -------------------------------
  /// Retry children
  /// -------------------------------
  Future<void> retry(String parentId) async {
    final children = Map<String, List<dynamic>>.from(state.childrenMap)
      ..remove(parentId);

    state = state.copyWith(
      childrenMap: children.cast(),
    );

    await loadChildren(parentId);
  }

  /// -------------------------------
  /// Reset
  /// -------------------------------
  void reset() {
    state = const CategorySelectionState();
  }
}