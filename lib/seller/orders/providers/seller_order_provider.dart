import 'package:ebazarx/features/order/domain/usecases/get_seller_order_items.dart';
import 'package:ebazarx/features/order/domain/usecases/update_order_item_status_seller.dart';
import 'package:ebazarx/features/order/presentation/providers/order_providers.dart';
import 'package:ebazarx/seller/orders/notifiers/seller_order_notifier.dart';
import 'package:ebazarx/seller/orders/states/seller_order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getSellerOrderItemUseCaseProvider = Provider((ref) => GetSellerOrderItems(ref.read(orderRepositoryProvider)));
final updateOrderItemStatusUseCaseProvider = Provider((ref) => UpdateOrderStatusSeller(ref.read(orderRepositoryProvider)));

final sellerOrderNotifierProvider = StateNotifierProvider<SellerOrderNotifier, SellerOrderState>((ref){
  return SellerOrderNotifier(ref.read(getSellerOrderItemUseCaseProvider), ref.read(updateOrderItemStatusUseCaseProvider));
});
