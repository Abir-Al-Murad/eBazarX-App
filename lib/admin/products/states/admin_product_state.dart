import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class AdminProductState {
  final bool isUpdating;
  final List<Product> pendingProduct;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? failure;

  const AdminProductState({
    this.isUpdating = false,
    this.pendingProduct = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.failure,
  });

  AdminProductState copyWith({
    bool? isUpdating,
    List<Product>? pendingProduct,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Failure? failure,
    bool clearError = false,
  }) {
    return AdminProductState(
      isUpdating: isUpdating ?? this.isUpdating,
      pendingProduct: pendingProduct ?? this.pendingProduct,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      failure: clearError ? null : (failure ?? this.failure),
    );
  }
}