

import 'package:ebazarx/features/order/domain/entities/order_entity.dart';

class AdminOrderState {
  final List<OrderEntity> orders;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const AdminOrderState({
    this.orders = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  AdminOrderState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    bool clearError = false,
  }) {
    return AdminOrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : error ?? this.error,
    );
  }
}