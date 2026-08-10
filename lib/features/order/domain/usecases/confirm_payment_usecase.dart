import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class ConfirmPaymentUseCase {
  final OrderRepository _repository;

  ConfirmPaymentUseCase(this._repository);

  Future<OrderEntity> call({
    required String orderId,
    required String paymentIntentId,
  }) async {
    return await _repository.confirmPayment(orderId, paymentIntentId);
  }
}