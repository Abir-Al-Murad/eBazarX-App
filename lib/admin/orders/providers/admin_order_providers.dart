import 'package:ebazarx/admin/orders/notifiers/admin_order_list_notifier.dart';
import 'package:ebazarx/admin/orders/notifiers/admin_order_notifier.dart';
import 'package:ebazarx/admin/orders/states/admin_all_list_state.dart';
import 'package:ebazarx/admin/orders/states/admin_order_state.dart';
import 'package:ebazarx/features/order/domain/usecases/get_all_order_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/get_order_details_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/get_order_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/update_order_status.dart';
import 'package:ebazarx/features/order/domain/usecases/update_payment_status_usecase.dart';
import 'package:ebazarx/features/order/presentation/providers/order_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllOrderUseCaseProvider = Provider<GetAllOrderUseCase>((ref) {
  return GetAllOrderUseCase(ref.read(orderRepositoryProvider));
});

final getOrderDetailsUseCaseProvider = Provider<GetOrderDetailsUseCase>((ref) {
  return GetOrderDetailsUseCase(ref.read(orderRepositoryProvider));
});

final getOrderUseCaseProvider = Provider<GetOrderUseCase>((ref) {
  return GetOrderUseCase(ref.read(orderRepositoryProvider));
});

final updateOrderUseCaseProvider = Provider<UpdateOrderStatus>((ref) {
  return UpdateOrderStatus(ref.read(orderRepositoryProvider));
});

final updatePaymentStatusUseCaseProvider = Provider<UpdateOrderPaymentStatus>((ref) {
  return UpdateOrderPaymentStatus(ref.read(orderRepositoryProvider));
});

final adminOrdersListProvider = StateNotifierProvider<AdminOrderListNotifier, AdminAllListState>((ref) {
  final getAllOrderUseCase = ref.watch(getAllOrderUseCaseProvider);
  return AdminOrderListNotifier(getAllOrderUseCase);
});

final adminOrderProvider = StateNotifierProvider<AdminOrderNotifier, AdminOrderState>((ref) {
  return AdminOrderNotifier(ref.watch(updateOrderUseCaseProvider),ref.watch(getOrderDetailsUseCaseProvider));
});
