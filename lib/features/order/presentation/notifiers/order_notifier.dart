import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/get_order_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/place_order_usecase.dart';
import 'package:ebazarx/features/order/presentation/states/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderNotifier extends StateNotifier<OrderState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetOrderUseCase _getOrderUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  OrderNotifier(
      this._placeOrderUseCase,
      this._getOrderUseCase,
      this._cancelOrderUseCase,
      ) : super(const OrderState());

  Future<bool> placeOrder({
    required String addressId,
    required List<CheckoutItemEntity> items,
    String? couponCode,
    String? notes,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      clearError: true,
    );

    try {
      final order = await _placeOrderUseCase(
        addressId: addressId,
        items: items,
        couponCode: couponCode,
        notes: notes,
      );

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        order: order,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  Future<bool> getOrder(String orderId) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final order = await _getOrderUseCase(
        orderId: orderId,
      );

      state = state.copyWith(
        isLoading: false,
        order: order,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      clearError: true,
    );

    try {
      final order = await _cancelOrderUseCase(
        orderId: orderId,
      );

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        order: order,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );

      return false;
    } catch (e,s) {
      debugPrint(s.toString());
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  void reset() {
    state = const OrderState();
  }
}