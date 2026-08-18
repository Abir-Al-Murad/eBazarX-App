import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

class SellerProductDetailsState {
  final bool isLoading;
  final Product? product;
  final Failure? failure;

  const SellerProductDetailsState({
     this.isLoading = false,
     this.product,
    this.failure,
  });

  SellerProductDetailsState copyWith({
    bool? isLoading,
    Product? product,
    Failure? failure,
    bool clearError = false,
  }){
    return SellerProductDetailsState(
      isLoading: isLoading ?? this.isLoading,
      product: product ?? this.product,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}