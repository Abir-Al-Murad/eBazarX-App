import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/payment_method.dart';

class OrderState {
  // Loading states
  final bool isLoading;
  final bool isSuccess;

  // Payment processing states
  final bool isProcessingPayment;
  final bool isConfirmingPayment;

  // Data
  final Failure? failure;
  final OrderEntity? order;

  // Payment info from backend
  final PaymentMethod? paymentMethod;
  final String? paymentRedirectUrl;  // SSLCommerz redirect URL
  final String? paymentId;           // Payment record ID
  final PaymentStatus? paymentStatus;

  const OrderState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isProcessingPayment = false,
    this.isConfirmingPayment = false,
    this.failure,
    this.order,
    this.paymentMethod,
    this.paymentRedirectUrl,
    this.paymentId,
    this.paymentStatus,
  });

  OrderState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isProcessingPayment,
    bool? isConfirmingPayment,
    Failure? failure,
    bool clearError = false,
    OrderEntity? order,
    PaymentMethod? paymentMethod,
    String? paymentRedirectUrl,
    String? paymentId,
    PaymentStatus? paymentStatus,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      isConfirmingPayment: isConfirmingPayment ?? this.isConfirmingPayment,
      failure: clearError ? null : failure ?? this.failure,
      order: order ?? this.order,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentRedirectUrl: paymentRedirectUrl ?? this.paymentRedirectUrl,
      paymentId: paymentId ?? this.paymentId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}