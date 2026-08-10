import 'package:equatable/equatable.dart';
import 'order_entity.dart';

class OrderPlaceResponseEntity extends Equatable {
  final OrderEntity order;
  final String? redirectUrl;
  final String? paymentId;

  const OrderPlaceResponseEntity({
    required this.order,
    this.redirectUrl,
    this.paymentId,
  });

  @override
  List<Object?> get props => [
    order,
    redirectUrl,
    paymentId,
  ];
}