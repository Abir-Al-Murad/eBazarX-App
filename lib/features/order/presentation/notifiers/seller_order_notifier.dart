// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../states/seller_order_state.dart';
//
// class SellerOrderNotifier extends StateNotifier<SellerOrderState> {
//   final GetSellerOrderItemsUseCase _getItems;
//   final UpdateOrderItemStatusUseCase _updateStatus;
//
//   SellerOrderNotifier(
//       this._getItems,
//       this._updateStatus,
//       ) : super(const SellerOrderState());
//
//   Future<void> loadItems() async {
//     state = state.copyWith(
//       isLoading: true,
//       clearError: true,
//     );
//
//     try {
//       final items = await _getItems();
//
//       state = state.copyWith(
//         isLoading: false,
//         items: items,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }
//
//   Future<void> updateStatus({
//     required String itemId,
//     required String status,
//   }) async {
//     state = state.copyWith(
//       isLoading: true,
//       clearError: true,
//     );
//
//     try {
//       await _updateStatus(
//         itemId: itemId,
//         status: status,
//       );
//
//       await loadItems();
//
//       state = state.copyWith(
//         isSuccess: true,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }
// }