import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class SellerProductState {
  final bool isLoading;
  final bool isSaving;
  final bool isDeleting;

  final List<Product> products;
  final Product? product;

  final Failure? failure;

  const SellerProductState({
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleting = false,
    this.products = const [],
    this.product,
    this.failure,
  });

  SellerProductState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isDeleting,
    List<Product>? products,
    Product? product,
    Failure? failure,
    bool clearFailure = false,
    bool clearProduct = false,
  }) {
    return SellerProductState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      products: products ?? this.products,
      product: clearProduct ? null : (product ?? this.product),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}