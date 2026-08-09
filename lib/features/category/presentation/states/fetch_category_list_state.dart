import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';

class FetchCategoryListState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<Category> categories;
  final Failure? failure;
  final Failure? loadMoreFailure;
  final bool hasMore;
  final int skip;
  final int limit;

  const FetchCategoryListState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.categories = const [],
    this.failure,
    this.loadMoreFailure,
    this.hasMore = true,
    this.skip = 0,
    this.limit = 20,
  });

  FetchCategoryListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<Category>? categories,
    Failure? failure,
    bool clearFailure = false,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
    bool? hasMore,
    int? skip,
    int? limit,
  }) {
    return FetchCategoryListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      categories: categories ?? this.categories,
      failure: clearFailure ? null : (failure ?? this.failure),
      loadMoreFailure: clearLoadMoreFailure
          ? null
          : (loadMoreFailure ?? this.loadMoreFailure),
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }
}