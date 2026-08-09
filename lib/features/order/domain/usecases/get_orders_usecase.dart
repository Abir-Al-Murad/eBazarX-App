

import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository _repository;

  const GetOrdersUseCase(this._repository);

  Future<List<OrderEntity>> call({
    int skip = 0,
    int limit = 20,
  }) {
    return _repository.getOrders(
      skip: skip,
      limit: limit,
    );
  }
}