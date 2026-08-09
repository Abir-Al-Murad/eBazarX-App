import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/order/data/datasources/order_remote_data_source.dart';
import 'package:ebazarx/features/order/data/repositories/order_repository_impl.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';
import 'package:ebazarx/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/get_order_tracking_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/get_order_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:ebazarx/features/order/domain/usecases/place_order_usecase.dart';
import 'package:ebazarx/features/order/presentation/notifiers/order_list_notifier.dart';
import 'package:ebazarx/features/order/presentation/notifiers/order_notifier.dart';
import 'package:ebazarx/features/order/presentation/states/order_list_state.dart';
import 'package:ebazarx/features/order/presentation/states/order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data Source

final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  return OrderRemoteDataSource(ref.read(apiClientProvider));
});

/// Repository

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(ref.read(orderRemoteDataSourceProvider));
});

/// Use Cases

final placeOrderUseCaseProvider = Provider<PlaceOrderUseCase>((ref) {
  return PlaceOrderUseCase(ref.read(orderRepositoryProvider));
});

final getOrdersUseCaseProvider = Provider<GetOrdersUseCase>((ref) {
  return GetOrdersUseCase(ref.read(orderRepositoryProvider));
});

final getOrderUseCaseProvider = Provider<GetOrderUseCase>((ref) {
  return GetOrderUseCase(ref.read(orderRepositoryProvider));
});

final cancelOrderUseCaseProvider = Provider<CancelOrderUseCase>((ref) {
  return CancelOrderUseCase(ref.read(orderRepositoryProvider));
});

final getOrderTrackingUseCaseProvider = Provider<GetOrderTrackingUseCase>((
  ref,
) {
  return GetOrderTrackingUseCase(ref.read(orderRepositoryProvider));
});


/// Notifiers

final orderListNotifierProvider =
    StateNotifierProvider<OrderListNotifier, OrderListState>((ref) {
      return OrderListNotifier(ref.read(getOrdersUseCaseProvider));
    });

final orderNotifierProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref){
  return OrderNotifier(
    ref.read(placeOrderUseCaseProvider),
    ref.read(getOrderUseCaseProvider),
    ref.read(cancelOrderUseCaseProvider),
  );
});