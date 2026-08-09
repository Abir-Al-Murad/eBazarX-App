import 'package:ebazarx/admin/orders/states/admin_all_list_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/usecases/get_all_order_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminOrderListNotifier extends StateNotifier<AdminAllListState> {
  final GetAllOrderUseCase _getAllOrderUseCase;
  AdminOrderListNotifier(this._getAllOrderUseCase) : super(AdminAllListState());

  Future<void> getAllOrders({
    int skip = 0,
    int limit = 20,
    String? status,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, items: []);
    try {
      final orders = await _getAllOrderUseCase.call(
        skip: skip,
        limit: limit,
        status: status,
      );
      state = state.copyWith(
        isLoading: false,
        items: skip == 0 ? orders : state.items + orders,
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  Future<void> loadMoreOrders()async{
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final orders = await _getAllOrderUseCase.call(
        skip: state.items.length,
        limit: 20,
      );
      state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...orders],
      );
    } on Failure catch (e) {
      state = state.copyWith(isLoadingMore: false, failure: e);
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

}
