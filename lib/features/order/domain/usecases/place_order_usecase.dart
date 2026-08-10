import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_place_response_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class PlaceOrderUseCase {
  final OrderRepository _repository;

  const PlaceOrderUseCase(this._repository);

  Future<OrderPlaceResponseEntity> call({
    required String addressId,
    required List<CheckoutItemEntity> items,
    required String paymentMethod, // 'cod' or 'sslcommerz'
    String? couponCode,
    String? notes,
    String? successUrl,  // For SSLCommerz redirect
    String? cancelUrl,   // For SSLCommerz redirect
  }) {
    return _repository.placeOrder(
      addressId: addressId,
      items: items,
      paymentMethod: paymentMethod,
      couponCode: couponCode,
      notes: notes,
      successUrl: successUrl,
      cancelUrl: cancelUrl,
    );
  }
}