

import 'package:ebazarx/features/order/data/models/order_item_model.dart';
import 'package:ebazarx/features/order/data/models/order_model.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class PlaceOrderUseCase {
  final OrderRepository _repository;

  const PlaceOrderUseCase(this._repository);

  Future<OrderEntity> call({
    required String addressId,
    required List<CheckoutItemEntity> items,
    String? couponCode,
    String? notes,
  }) {
    return _repository.placeOrder(
      addressId: addressId,
      items: items,
      couponCode: couponCode,
      notes: notes,
    );
  }
}