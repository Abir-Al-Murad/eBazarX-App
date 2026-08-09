import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/usecases/get_child_categories.dart';
import 'package:ebazarx/features/category/presentation/states/children_category_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChildrenCategoryListNotifier
    extends StateNotifier<ChildrenCategoryListState> {
  final GetChildCategoriesUseCase _getChildrenCategoryUseCase;

  ChildrenCategoryListNotifier(this._getChildrenCategoryUseCase)
      : super(const ChildrenCategoryListState());

  Future<void> fetchChildrenCategories(String parentId) async {
    // Already loaded? Don't hit API again.
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
      final categories = await _getChildrenCategoryUseCase(parentId);

      state = state.copyWith(
        childrenMap: {
          ...state.childrenMap,
          parentId: categories,
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

  void clear() {
    state = const ChildrenCategoryListState();
  }
}