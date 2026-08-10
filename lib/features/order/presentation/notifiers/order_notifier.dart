import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_place_response_entity.dart';
import 'package:ebazarx/features/order/domain/entities/payment_method.dart';
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

  OrderNotifier({
    required PlaceOrderUseCase placeOrderUseCase,
    required GetOrderUseCase getOrderUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
  })  : _placeOrderUseCase = placeOrderUseCase,
        _getOrderUseCase = getOrderUseCase,
        _cancelOrderUseCase = cancelOrderUseCase,
        super(const OrderState());

  // ============================================================
  // New unified checkout: handles COD and SSLCommerz
  // ============================================================

  Future<void> initiateCheckout({
    required String addressId,
    required List<CheckoutItemEntity> items,
    required PaymentMethod paymentMethod,
    String? couponCode,
    String? notes,
    String? successUrl,
    String? cancelUrl,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      clearError: true,
      paymentMethod: paymentMethod,
      isProcessingPayment: false,
      isConfirmingPayment: false,
      paymentRedirectUrl: null,
      paymentId: null,
    );

    try {
      // 1. Create order / initialize payment
      final result = await _placeOrderUseCase(
        addressId: addressId,
        items: items,
        paymentMethod: paymentMethod.value,
        couponCode: couponCode,
        notes: notes,
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      );

      // 2. Result is OrderPlaceResponseEntity
      if (result is! OrderPlaceResponseEntity) {
        state = state.copyWith(
          isLoading: false,
          failure: UnknownFailure(
            'Invalid response received while creating order',
          ),
        );
        return;
      }

      final order = result.order;
      final redirectUrl = result.redirectUrl;
      final paymentId = result.paymentId;

      // 3. Store order + payment information
      state = state.copyWith(
        isLoading: false,
        order: order,
        paymentStatus: PaymentStatus.pending,
        paymentId: paymentId,
        paymentRedirectUrl: redirectUrl,
      );

      // 4. COD
      if (paymentMethod == PaymentMethod.cod) {
        state = state.copyWith(
          isSuccess: true,
          paymentStatus: PaymentStatus.pending,
        );
        return;
      }

      // 5. SSLCommerz - check redirect URL
      if (redirectUrl == null || redirectUrl.isEmpty) {
        state = state.copyWith(
          failure: UnknownFailure(
            'Payment initialization failed: missing redirect URL',
          ),
        );
        return;
      }

      // 6. Set state for WebView navigation
      state = state.copyWith(
        isProcessingPayment: true,
        paymentStatus: PaymentStatus.processing,
      );

      // The CheckoutScreen will listen to state changes and navigate to WebView
      // We keep the state as-is; the UI will handle navigation
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        isProcessingPayment: false,
        isConfirmingPayment: false,
        isSuccess: false,
        paymentStatus: PaymentStatus.failed,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isProcessingPayment: false,
        isConfirmingPayment: false,
        isSuccess: false,
        paymentStatus: PaymentStatus.failed,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  // ============================================================
  // COD only (legacy)
  // ============================================================

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
      final result = await _placeOrderUseCase(
        addressId: addressId,
        items: items,
        paymentMethod: PaymentMethod.cod.value,
        couponCode: couponCode,
        notes: notes,
      );

      if (result is! OrderPlaceResponseEntity) {
        state = state.copyWith(
          isLoading: false,
          failure: UnknownFailure('Invalid response'),
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        order: result.order,
      );
      return true;
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
      return false;
    }
  }

  // ============================================================
  // Confirm payment (called after SSLCommerz redirect)
  // ============================================================

  Future<bool> confirmPayment({
    required String paymentId,
    required String orderId,
    required String status, // 'success' or 'fail'
  }) async {
    state = state.copyWith(
      isConfirmingPayment: true,
      clearError: true,
    );

    try {
      // Call backend to confirm/verify payment
      // This would be a new endpoint: POST /payments/confirm
      // Or we can fetch order status
      final order = await _getOrderUseCase(orderId: orderId);

      state = state.copyWith(
        isConfirmingPayment: false,
        order: order,
      );

      if (order.paymentStatus == PaymentStatus.paid) {
        state = state.copyWith(
          isSuccess: true,
          paymentStatus: PaymentStatus.paid,
        );
        return true;
      } else {
        state = state.copyWith(
          failure: UnknownFailure('Payment verification failed'),
          paymentStatus: PaymentStatus.failed,
        );
        return false;
      }
    } on Failure catch (e) {
      state = state.copyWith(
        isConfirmingPayment: false,
        failure: e,
        paymentStatus: PaymentStatus.failed,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isConfirmingPayment: false,
        failure: UnknownFailure(e.toString()),
        paymentStatus: PaymentStatus.failed,
      );
      return false;
    }
  }

  // ============================================================
  // Clear redirect URL after WebView opens
  // ============================================================

  void clearRedirectUrl() {
    state = state.copyWith(paymentRedirectUrl: null);
  }

  // ============================================================
  // Other methods
  // ============================================================

  Future<bool> getOrder(String orderId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final order = await _getOrderUseCase(orderId: orderId);
      state = state.copyWith(isLoading: false, order: order);
      return true;
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
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
    state = state.copyWith(isLoading: true, isSuccess: false, clearError: true);
    try {
      final order = await _cancelOrderUseCase(orderId: orderId);
      state = state.copyWith(isLoading: false, isSuccess: true, order: order);
      return true;
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
      return false;
    } catch (e) {
      debugPrint(e.toString());
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