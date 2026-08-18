import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/usecases/fetch_seller_product_usecase.dart';
import 'package:ebazarx/seller/products/states/seller_product_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerProductListNotifier  extends StateNotifier<SellerProductListState>{
  final FetchSellerProductsUseCase _fetchSellerProductsUseCase;
  SellerProductListNotifier(this._fetchSellerProductsUseCase) : super(SellerProductListState(isLoading: false, isLoadingMore: false, hasMore: true, products: [], failure: null));

  Future<bool> fetchSellerProducts()async{
    state = state.copyWith(isLoading: true,clearError: true);
    try{
      final products = await  _fetchSellerProductsUseCase();
      state = state.copyWith(isLoading: false, products: products,clearError: true);
      return true;
    }on Failure catch(e){
      state = state.copyWith(isLoading: false, failure: e);
      return false;
    } catch (e){
      state = state.copyWith(isLoading: false, failure: UnknownFailure(e.toString()));
      return false;
    }
  }

  Future<bool> loadMoreSellerProducts()async{
    state = state.copyWith(isLoadingMore: true,clearError: true);
    try{
      int skip = state.products.length;
      final products = await  _fetchSellerProductsUseCase(skip: skip);
      state = state.copyWith(isLoadingMore: false, hasMore: products.isNotEmpty, products: [...state.products, ...products],clearError: true);
      return true;
    }on Failure catch(e){
      state = state.copyWith(isLoadingMore: false,failure: e);
      return false;
    }catch (e){
      state = state.copyWith(isLoadingMore: false, failure: UnknownFailure(e.toString()));
      return false;
    }
  }

  void reset(){
    state = SellerProductListState(isLoading: false, isLoadingMore: false, hasMore: true, products: [], failure: null);
  }
}