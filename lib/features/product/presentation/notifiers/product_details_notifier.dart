import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_variant_entity.dart';
import 'package:ebazarx/features/product/domain/usecases/get_product_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebazarx/features/product/presentation/states/product_details_state.dart';

class ProductDetailsNotifier extends StateNotifier<ProductDetailsState> {
  final GetProductUseCase _getProductUseCase;
  ProductDetailsNotifier(this._getProductUseCase) : super(ProductDetailsState());

  void selectVariant(ProductVariant variant) {
    state = state.copyWith(selectedVariant: variant);
  }

  Future<bool> fetchProductDetails(String productId) async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    try {
      final product = await _getProductUseCase(productId);

      state = state.copyWith(
        isLoading: false,
        product: product,
        clearFailure: true,
        // Default to the first variant the moment the product arrives —
        // don't wait for VariantSection's post-frame callback to set it.
        // That's what was leaving selectedVariant null during the first
        // build and crashing ProductImageCarousel's `!.id`.
        selectedVariant:
        product.variants.isNotEmpty ? product.variants.first : null,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
      return false;
    } catch (e, s) {
      debugPrint(s.toString());
      state = state.copyWith(isLoading: false, failure: UnknownFailure(e.toString()));
      return false;
    }
  }


  void increaseQuantity() {
    state = state.copyWith(
      quantity: state.quantity + 1,
    );
  }

  void decreaseQuantity() {
    if (state.quantity == 1) return;

    state = state.copyWith(
      quantity: state.quantity - 1,
    );
  }

  void clearProductDetails(){
    state = ProductDetailsState();

  }
}