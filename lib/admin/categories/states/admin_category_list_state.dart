import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';

class AdminCategoryListState {
  final bool isLoading;
  final bool isLoadingMore;

  final List<Category> categories;

  final Failure? failure;

  final int skip;
  final int limit;
  final bool hasMore;

  final String? name;
  final String? slug;
  final String? parentId;
  final bool? isActive;
  final bool includeDeleted;

  const AdminCategoryListState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.categories = const [],
    this.failure,
    this.skip = 0,
    this.limit = 20,
    this.hasMore = true,
    this.name,
    this.slug,
    this.parentId,
    this.isActive,
    this.includeDeleted = false,
  });

  AdminCategoryListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<Category>? categories,
    Failure? failure,
    int? skip,
    int? limit,
    bool? hasMore,
    String? name,
    String? slug,
    String? parentId,
    bool? isActive,
    bool? includeDeleted,
    bool clearFailure = false,
  }) {
    return AdminCategoryListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,

      categories: categories ?? this.categories,

      failure: clearFailure
          ? null
          : failure ?? this.failure,

      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,

      name: name ?? this.name,
      slug: slug ?? this.slug,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      includeDeleted: includeDeleted ?? this.includeDeleted,
    );
  }
}