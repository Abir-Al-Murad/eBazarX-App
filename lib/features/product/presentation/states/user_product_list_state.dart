import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class UserProductListState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<Product> products;
  final Failure? failure;
  final bool hasMore;
  final int skip;
  final int limit;

  const UserProductListState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.products = const [],
    this.failure,
    this.hasMore = true,
    this.skip = 0,
    this.limit = 20,
  });

  UserProductListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<Product>? products,
    Failure? failure,
    bool clearFailure = false,
    bool? hasMore,
    int? skip,
    int? limit,
  }) {
    return UserProductListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      products: products ?? this.products,
      failure: clearFailure ? null : (failure ?? this.failure),
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }
}