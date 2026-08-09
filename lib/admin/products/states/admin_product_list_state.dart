import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class AdminProductListState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<Product> products;
  final bool hasMore;
  final Failure? failure;

  const AdminProductListState({
     this.isLoading = false,
     this.isLoadingMore = false,
     this.products = const [],
     this.hasMore = true,
     this.failure,
  });

  AdminProductListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<Product>? products,
    bool? hasMore,
    Failure? failure,
    bool? clearError
}){
    return AdminProductListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      failure: clearError == true ? null : failure ?? this.failure,);
  }
}