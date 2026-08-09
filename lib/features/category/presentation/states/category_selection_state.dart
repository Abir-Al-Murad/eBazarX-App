import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';

class CategorySelectionState {
  final bool isLoadingRoot;

  final List<Category> rootCategories;

  /// parentId -> children
  final Map<String, List<Category>> childrenMap;

  /// parentId -> loading
  final Map<String, bool> loadingMap;

  /// parentId -> failure
  final Map<String, Failure> errorMap;

  /// Selected category ids by level
  ///
  /// Example:
  /// [
  ///   electronicsId,
  ///   mobileId,
  ///   androidId
  /// ]
  final List<String> selectedPath;

  final Failure? rootFailure;

  const CategorySelectionState({
    this.isLoadingRoot = false,
    this.rootCategories = const [],
    this.childrenMap = const {},
    this.loadingMap = const {},
    this.errorMap = const {},
    this.selectedPath = const [],
    this.rootFailure,
  });

  CategorySelectionState copyWith({
    bool? isLoadingRoot,
    List<Category>? rootCategories,
    Map<String, List<Category>>? childrenMap,
    Map<String, bool>? loadingMap,
    Map<String, Failure>? errorMap,
    List<String>? selectedPath,
    Failure? rootFailure,
    bool clearRootFailure = false,
  }) {
    return CategorySelectionState(
      isLoadingRoot: isLoadingRoot ?? this.isLoadingRoot,
      rootCategories: rootCategories ?? this.rootCategories,
      childrenMap: childrenMap ?? this.childrenMap,
      loadingMap: loadingMap ?? this.loadingMap,
      errorMap: errorMap ?? this.errorMap,
      selectedPath: selectedPath ?? this.selectedPath,
      rootFailure:
      clearRootFailure ? null : (rootFailure ?? this.rootFailure),
    );
  }

  List<Category> childrenOf(String parentId) {
    return childrenMap[parentId] ?? const [];
  }

  bool isLoading(String parentId) {
    return loadingMap[parentId] ?? false;
  }

  Failure? errorOf(String parentId) {
    return errorMap[parentId];
  }

  String? get selectedLeaf =>
      selectedPath.isEmpty ? null : selectedPath.last;
}