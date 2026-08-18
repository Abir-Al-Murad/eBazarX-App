import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/usecases/create_product_use_case.dart';
import 'package:ebazarx/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/get_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/update_product_usecase.dart';
import 'package:ebazarx/seller/products/states/seller_product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SellerProductNotifier
    extends StateNotifier<SellerProductState> {

  final CreateProductUseCase _createProduct;
  final UpdateProductUseCase _updateProduct;
  final DeleteProductUseCase _deleteProduct;
  final GetProductUseCase _getProduct;
  // final GetProductsUseCase _getProducts;

  SellerProductNotifier(
      this._createProduct,
      this._updateProduct,
      this._deleteProduct,
      this._getProduct,
      // this._getProducts,
      ) : super(const SellerProductState());

  //----------------------------------------------------
  // Load Products
  //----------------------------------------------------

  // Future<void> loadProducts() async {
  //   state = state.copyWith(
  //     isLoading: true,
  //     clearFailure: true,
  //   );
  //
  //   try {
  //     final products = await _getProducts();
  //
  //     state = state.copyWith(
  //       isLoading: false,
  //       products: products,
  //     );
  //   } on Failure catch (e) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       failure: e,
  //     );
  //   }
  // }

  //----------------------------------------------------
  // Load Product
  //----------------------------------------------------

  // Future<void> loadProduct(String id) async {
  //   state = state.copyWith(
  //     isLoading: true,
  //     clearFailure: true,
  //   );
  //
  //   try {
  //     final product = await _getProduct(id);
  //
  //     state = state.copyWith(
  //       isLoading: false,
  //       product: product,
  //     );
  //   } on Failure catch (e) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       failure: e,
  //     );
  //   }
  // }

  //----------------------------------------------------
  // Create
  //----------------------------------------------------

  Future<void> create(Map<String,dynamic> data) async {
    state = state.copyWith(
      isSaving: true,
      clearFailure: true,
    );

    try {
      final created = await _createProduct(data);

      state = state.copyWith(
        isSaving: false,
        products: [
          created,
          ...state.products,
        ],
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isSaving: false,
        failure: e,
      );
    }
  }

  //----------------------------------------------------
  // Update
  //----------------------------------------------------

  Future<void> update(String productId, Map<String, dynamic> data) async {
    state = state.copyWith(
      isSaving: true,
      clearFailure: true,
    );

    try {
      final updated = await _updateProduct(productId:productId,data: data);

      final list = [...state.products];

      final index =
      list.indexWhere((e) => e.id == updated.id);

      if (index != -1) {
        list[index] = updated;
      }

      state = state.copyWith(
        isSaving: false,
        products: list,
        product: updated,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isSaving: false,
        failure: e,
      );
    }catch (e){
      state = state.copyWith(
        isSaving: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  //----------------------------------------------------
  // Delete
  //----------------------------------------------------

  Future<void> delete(String id) async {
    state = state.copyWith(
      isDeleting: true,
      clearFailure: true,
    );

    try {
      await _deleteProduct(id);

      state = state.copyWith(
        isDeleting: false,
        products: state.products
            .where((e) => e.id != id)
            .toList(),
        clearProduct: state.product?.id == id,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isDeleting: false,
        failure: e,
      );
    }
  }

  //----------------------------------------------------
  // Helpers
  //----------------------------------------------------

  void clearError() {
    state = state.copyWith(clearFailure: true);
  }

  void clearSelectedProduct() {
    state = state.copyWith(clearProduct: true);
  }

  // Future<void> refresh() async {
  //   await loadProducts();
  // }
}