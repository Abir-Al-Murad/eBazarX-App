import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';

class AdminAllListState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final List<OrderEntity> items;
  final Failure? failure;

  AdminAllListState({
     this.isLoading = false,
     this.isLoadingMore = false,
     this.hasMore = true,
     this.items = const [],
     this.failure,
  });

  AdminAllListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    List<OrderEntity>? items,
    bool clearError = false,
    Failure? failure,
  }) {
    return AdminAllListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      items: items ?? this.items,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}
