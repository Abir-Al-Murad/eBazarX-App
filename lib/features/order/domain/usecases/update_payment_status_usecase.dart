import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class UpdateOrderPaymentStatus {
  final OrderRepository _repository;

  UpdateOrderPaymentStatus(this._repository);

  Future<OrderEntity> call({
    required String orderId,
    required String paymentStatus,
  }) {
    return _repository.updateOrderPaymentStatus(
      orderId: orderId,
      paymentStatus: paymentStatus,
    );
  }
}