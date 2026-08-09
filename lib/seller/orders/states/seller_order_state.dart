import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}


class SellerOrderState {
  final bool isLoading;
  final bool isLoadingMore;
  final Set<String> updatingIds;
  final List<OrderItemEntity> items;
  final bool hasMore;
  final Failure? failure;

  const SellerOrderState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.updatingIds = const {},
    this.items = const [],
    this.hasMore = true,
    this.failure,
  });

  SellerOrderState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    Set<String>? updatingIds,
    List<OrderItemEntity>? items,
    bool? hasMore,
    Failure? failure,
    bool clearError = false,
  }) {
    return SellerOrderState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      updatingIds: updatingIds ?? this.updatingIds,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
        failure: clearError ? null : failure ?? this.failure,
    );
  }


  bool isUpdating(String orderId) {
    return updatingIds.contains(orderId);
  }
}