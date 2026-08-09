

import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class GetOrderTrackingUseCase {
  final OrderRepository _repository;

  const GetOrderTrackingUseCase(this._repository);

  Future<OrderEntity> call({
    required String orderId,
  }) {
    return _repository.getOrder(orderId: orderId);
  }
}