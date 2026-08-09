import 'package:ebazarx/admin/orders/states/admin_order_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/usecases/get_order_details_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/update_order_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminOrderNotifier extends StateNotifier<AdminOrderState> {
  final UpdateOrderStatus _updateOrderStatusUseCase;
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  AdminOrderNotifier(this._updateOrderStatusUseCase,this._getOrderDetailsUseCase) : super(AdminOrderState(isUpdating: false, failure: null));

  Future<void> updateOrderStatus(String orderId, String status) async {
    state = state.copyWith(isUpdating: true, clearError: true);
    try {
      // Call your update order status use case here
      await _updateOrderStatusUseCase.call(orderId: orderId, status: status);
      state = state.copyWith(isUpdating: false,clearError: true);
    } on Failure catch (e) {
      state = state.copyWith(isUpdating: false, failure: e);
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> getOrderDetails(String orderId)async{
    if(state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try{
      final result = await _getOrderDetailsUseCase.call(orderId);
      state = state.copyWith(order: result, isLoading: false, clearError: true);
    }on Failure catch(e){
      state = state.copyWith(isLoading: false, failure: e);
    }catch(e){
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

}