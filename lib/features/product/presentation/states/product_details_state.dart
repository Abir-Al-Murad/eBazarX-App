import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/entities/product_variant_entity.dart';

class ProductDetailsState {
  final bool isLoading;
  final Product? product;
  final int quantity;
  final Failure? failure;
  final ProductVariant? selectedVariant;

  ProductDetailsState({
    this.isLoading = false,
    this.quantity = 1,
    this.product,
    this.failure,
    this.selectedVariant,
  });

  ProductDetailsState copyWith({
    bool? isLoading,
    Product? product,
    Failure? failure,
    int? quantity,
    ProductVariant? selectedVariant,
    bool? clearFailure,
  }){
    return ProductDetailsState(
      isLoading: isLoading ?? this.isLoading,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      failure: clearFailure == true ? null : failure ?? this.failure,
    );
  }
}