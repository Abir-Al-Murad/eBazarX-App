

import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';

class OrderState {
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final OrderEntity? order;

  const OrderState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.order,
  });

  OrderState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearError = false,
    OrderEntity? order,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearError ? null : failure ?? this.failure,
      order: order ?? this.order,
    );
  }
}