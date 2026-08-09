import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class UpdateOrderStatusSeller {
  OrderRepository _repository;
  UpdateOrderStatusSeller(this._repository);

  Future<OrderItemEntity> call({
    required String orderId,
    required String status,
  }) {
    return _repository.updateOrderItemStatus(itemId: orderId, status: status);
  }
}