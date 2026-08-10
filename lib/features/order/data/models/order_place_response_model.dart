import 'package:ebazarx/features/order/domain/entities/order_place_response_entity.dart';
import 'order_model.dart';

class OrderPlaceResponseModel {
  final OrderModel order;
  final String? redirectUrl;   // SSLCommerz redirect URL
  final String? paymentId;     // Payment record ID

  const OrderPlaceResponseModel({
    required this.order,
    this.redirectUrl,
    this.paymentId,
  });

  factory OrderPlaceResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderPlaceResponseModel(
      order: OrderModel.fromJson(json['order']),
      redirectUrl: json['redirect_url'],
      paymentId: json['payment_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'order': order.toJson(),
    'redirect_url': redirectUrl,
    'payment_id': paymentId,
  };

  OrderPlaceResponseEntity toEntity() {
    return OrderPlaceResponseEntity(
      order: order.toEntity(),
      redirectUrl: redirectUrl,
      paymentId: paymentId,
    );
  }
}