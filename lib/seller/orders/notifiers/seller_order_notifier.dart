import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/features/order/domain/usecases/get_seller_order_items.dart';
import 'package:ebazarx/features/order/domain/usecases/update_order_item_status_seller.dart';
import 'package:ebazarx/seller/orders/states/seller_order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerOrderNotifier extends StateNotifier<SellerOrderState> {
  final GetSellerOrderItems _getSellerOrderItems;
  final UpdateOrderStatusSeller _updateOrderStatusSeller;

  SellerOrderNotifier(
      this._getSellerOrderItems,
      this._updateOrderStatusSeller,
      ) : super(const SellerOrderState());

  static const int _pageSize = 20;

  //-------------------------------------------------------
  // First Load
  //-------------------------------------------------------

  Future<void> getSellerOrders() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final orders = await _getSellerOrderItems(
        0,
        _pageSize,
      );

      state = state.copyWith(
        isLoading: false,
        items: orders,
        hasMore: orders.length == _pageSize,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  //-------------------------------------------------------
  // Refresh
  //-------------------------------------------------------

  Future<void> refresh() async {
    await getSellerOrders();
  }

  //-------------------------------------------------------
  // Pagination
  //-------------------------------------------------------

  Future<void> loadMoreOrders() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(
      isLoadingMore: true,
      clearError: true,
    );

    try {
      final orders = await _getSellerOrderItems(
        state.items.length,
        _pageSize,
      );

      state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...orders],
        hasMore: orders.length == _pageSize,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  //-------------------------------------------------------
  // Update One Order
  //-------------------------------------------------------

  Future<void> updateSellerOrderStatus({
    required String orderId,
    required String status,
  }) async {
    /// prevent duplicate request
    if (state.updatingIds.contains(orderId)) {
      return;
    }

    final updating = {...state.updatingIds};

    updating.add(orderId);

    state = state.copyWith(
      updatingIds: updating,
      clearError: true,
    );

    try {
      final updatedOrder = await _updateOrderStatusSeller(
        orderId: orderId,
        status: status,
      );

      final updatedItems = state.items.map((item) {
        if (item.id == orderId) {
          return updatedOrder;
        }
        return item;
      }).toList();

      updating.remove(orderId);

      state = state.copyWith(
        updatingIds: updating,
        items: updatedItems,
      );
    } on Failure catch (e) {
      updating.remove(orderId);

      state = state.copyWith(
        updatingIds: updating,
        failure: e,
      );
    } catch (e) {
      updating.remove(orderId);

      state = state.copyWith(
        updatingIds: updating,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  //-------------------------------------------------------
  // Batch Update (optional)
  //-------------------------------------------------------

  Future<void> updateMultipleOrders({
    required List<String> orderIds,
    required String status,
  }) async {
    await Future.wait(
      orderIds.map(
            (id) => updateSellerOrderStatus(
          orderId: id,
          status: status,
        ),
      ),
    );
  }
}