import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';

class ChildrenCategoryListState {
  final Map<String, List<Category>> childrenMap;

  final Map<String, bool> loadingMap;

  final Map<String, Failure> errorMap;

  const ChildrenCategoryListState({
    this.childrenMap = const {},
    this.loadingMap = const {},
    this.errorMap = const {},
  });

  List<Category> childrenOf(String parentId) {
    return childrenMap[parentId] ?? [];
  }

  bool isLoading(String parentId) {
    return loadingMap[parentId] ?? false;
  }

  Failure? errorOf(String parentId) {
    return errorMap[parentId];
  }

  ChildrenCategoryListState copyWith({
    Map<String,List<Category>>? childrenMap,
    Map<String,bool>? loadingMap,
    Map<String,Failure>? errorMap,
  }) {
    return ChildrenCategoryListState(
      childrenMap: childrenMap ?? this.childrenMap,
      loadingMap: loadingMap ?? this.loadingMap,
      errorMap: errorMap ?? this.errorMap,
    );
  }
}