//
//
// import 'package:ebazarx/core/failures/failure.dart';
// import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
//
// class SellerOrderState {
//   final List<OrderItemEntity> items;
//   final bool isLoading;
//   final bool isSuccess;
//   final Failure? failure;
//
//   const SellerOrderState({
//     this.items = const [],
//     this.isLoading = false,
//     this.isSuccess = false,
//     this.failure,
//   });
//
//   SellerOrderState copyWith({
//     List<OrderItemEntity>? items,
//     bool? isLoading,
//     bool? isSuccess,
//     Failure? failure,
//     bool clearError = false,
//   }) {
//     return SellerOrderState(
//       items: items ?? this.items,
//       isLoading: isLoading ?? this.isLoading,
//       isSuccess: isSuccess ?? this.isSuccess,
//       failure: clearError ? null : failure ?? this.failure,
//     );
//   }
// }