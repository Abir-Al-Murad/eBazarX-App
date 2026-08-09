import 'package:ebazarx/admin/products/states/admin_product_list_state.dart';
import 'package:ebazarx/admin/products/states/admin_product_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/product/domain/usecases/fetch_pending_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/update_product_approval_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminProductActionNotifier extends StateNotifier<AdminProductState>{
  final UpdateProductApprovalUseCase _updateProductApprovalUseCase;
  final FetchPendingProductsUseCase _fetchPendingProductsUseCase;

  AdminProductActionNotifier(
    this._updateProductApprovalUseCase,
    this._fetchPendingProductsUseCase,
  ) : super(AdminProductState());


  Future<void> fetchPendingProducts()async{
    if(state.isLoading) return;
    state = state.copyWith(isLoading: true,pendingProduct: [],clearError: true,hasMore: true);
    try{
      final result = await _fetchPendingProductsUseCase();
      state = state.copyWith(isLoading: false,pendingProduct: result);
    }on Failure catch(e){
      state = state.copyWith(isLoading: false,failure: e);
    }catch(e){
      state = state.copyWith(isLoading: false,failure: UnknownFailure(e.toString()));
    }

  }

  Future<void> loadMorePendingProduct()async{
    if(state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true,clearError: true);
    try{
      final result = await _fetchPendingProductsUseCase(skip: state.pendingProduct.length,limit: 20);
      state = state.copyWith(
        isLoadingMore: false,
        pendingProduct: [...state.pendingProduct,...result],
        hasMore: result.length == 20,
      );
    }on Failure catch(e){
      state = state.copyWith(isLoadingMore: false,failure: e);
    }catch(e){
      state = state.copyWith(isLoadingMore: false,failure: UnknownFailure(e.toString()));
    }
  }

  Future<bool> updateApprovalStatus(String productId,String approvalStatus,String? notes)async{
    state = state.copyWith(isUpdating: true);
    try{
      await _updateProductApprovalUseCase(productId: productId,approvalStatus: approvalStatus,notes: notes);
      state = state.copyWith(isUpdating: false);
      return true;
    }on Failure catch(e){
      state = state.copyWith(isUpdating: false,failure: e);
      return false;
    }catch (e){
      state = state.copyWith(isUpdating: false,failure: UnknownFailure(e.toString()));
      return false;
    }
  }

}