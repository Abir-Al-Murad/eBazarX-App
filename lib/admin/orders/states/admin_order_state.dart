import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';

class AdminOrderState {
  final bool isLoading;
  final OrderEntity? order;
  final bool isUpdating;
  final Failure? failure;

  AdminOrderState({
    required this.isUpdating,
    required this.failure,
    this.order,
    this.isLoading = false
  });

  AdminOrderState copyWith({
    OrderEntity? order,
    bool? isLoading,
    bool? isUpdating,
    bool clearError = false,
    Failure? failure,
  }) {
    return AdminOrderState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}