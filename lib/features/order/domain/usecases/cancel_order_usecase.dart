

import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class CancelOrderUseCase {
  final OrderRepository _repository;

  const CancelOrderUseCase(this._repository);

  Future<OrderEntity> call({
    required String orderId,
  }) {
    return _repository.cancelOrder(orderId: orderId);
  }
}