import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class GetOrderDetailsUseCase {
  final OrderRepository _repository;
  const GetOrderDetailsUseCase(this._repository);
  Future<OrderEntity> call(String orderId){
    return _repository.getOrderDetails(orderId: orderId);
  }
}