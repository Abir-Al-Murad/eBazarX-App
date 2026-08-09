import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';

class OrderListState {
  final List<OrderEntity> orders;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? failure;
  final int skip;
  final int limit;

  const OrderListState({
    this.orders = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.failure,
    this.skip = 0,
    this.limit = 20,
  });

  OrderListState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    Failure? failure,
    bool clearError = false,
    int? skip,
    int? limit,
  }) {
    return OrderListState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      failure: clearError ? null : failure ?? this.failure,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }
}