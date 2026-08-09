import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class UpdateOrderStatus {
  final OrderRepository _repository;

  UpdateOrderStatus(this._repository);

  Future<OrderEntity> call({
    required String orderId,
    required String status,
  }) {
    return _repository.updateOrderStatus(
      orderId: orderId,
      status: status,
    );
  }
}