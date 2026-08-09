import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class GetAllOrderUseCase {
  final OrderRepository _repository;
  const GetAllOrderUseCase(this._repository);

  Future<List<OrderEntity>> call({
    int skip = 0,
    int limit = 20,
    String? status,
  }){
    return _repository.getAllOrders(
      skip: skip,
      limit: limit,
      status: status,
    );
  }
}