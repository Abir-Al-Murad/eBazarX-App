import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/usecases/get_seller_product_usecase.dart';
import 'package:ebazarx/seller/products/states/seller_product_details_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerProductDetailsNotifier extends StateNotifier<SellerProductDetailsState> {
  final GetSellerProductUseCase _getSellerProductUseCase;
  SellerProductDetailsNotifier(this._getSellerProductUseCase) : super(SellerProductDetailsState());

  Future<void> fetchSellerProduct(String productId) async {
    state = state.copyWith(isLoading: true,clearError: true);
    try{
      final product = await _getSellerProductUseCase(productId);
      state = state.copyWith(product: product,clearError: true,isLoading: false);
    }on Failure catch(e){
      state = state.copyWith(failure: e,isLoading: false);
    } catch(e){
      state = state.copyWith(isLoading:false,failure: UnknownFailure(e.toString()));
    }
  }
}