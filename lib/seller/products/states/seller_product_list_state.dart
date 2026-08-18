import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class SellerProductListState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final List<Product> products;
  final Failure? failure;

  SellerProductListState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.products,
    required this.failure,
  });

  SellerProductListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    List<Product>? products,
    Failure? failure,
    bool? clearError,
}){
    return SellerProductListState(isLoading: isLoading ?? this.isLoading, isLoadingMore: isLoadingMore ?? this.isLoadingMore, hasMore: hasMore ?? this.hasMore, products: products ?? this.products, failure: clearError == true ? null : (failure ?? this.failure),);
  }
}