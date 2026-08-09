import 'dart:async';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:ebazarx/features/order/presentation/states/order_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderListNotifier extends StateNotifier<OrderListState> {
  final GetOrdersUseCase _getOrdersUseCase;

  OrderListNotifier(this._getOrdersUseCase)
      : super(const OrderListState());

  void reset(){
    state = const OrderListState();
  }

  Future<void> loadOrders({
    int skip = 0,
    int limit = 20,
  }) async {
    if(!AuthStorage.instance.isLoggedIn){
      state = state.copyWith(
        isLoading: false,
        clearError: true,
      );
      return;
    }
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final orders = await _getOrdersUseCase(
        skip: skip,
        limit: limit,
      );

      state = state.copyWith(
        orders: orders,
        isLoading: false,
        skip: skip,
        limit: limit,
        hasMore: orders.length == limit,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e
      );
    } catch(e){
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString())
      );
    }
  }

  Future<void> refresh() async {
    await loadOrders();
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextSkip = state.skip + state.limit;

      final newOrders = await _getOrdersUseCase(
        skip: nextSkip,
        limit: state.limit,
      );

      state = state.copyWith(
        orders: [...state.orders, ...newOrders],
        skip: nextSkip,
        hasMore: newOrders.length == state.limit,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }
}