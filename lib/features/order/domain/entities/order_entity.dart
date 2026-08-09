import 'package:equatable/equatable.dart';
import 'order_status.dart';
import 'order_item_entity.dart';

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String addressId;
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double discountAmount;
  final double grandTotal;
  final String? paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;
  final String? notes;
  final String? couponId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.discountAmount,
    required this.grandTotal,
    this.paymentMethod,
    this.paymentStatus = PaymentStatus.pending,
    this.orderStatus = OrderStatus.pending,
    this.trackingNumber,
    this.estimatedDelivery,
    this.notes,
    this.couponId,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    addressId,
    subtotal,
    shippingFee,
    tax,
    discountAmount,
    grandTotal,
    paymentMethod,
    paymentStatus,
    orderStatus,
    trackingNumber,
    estimatedDelivery,
    notes,
    couponId,
    createdAt,
    updatedAt,
    items,
  ];

  bool get isCancellable =>
      orderStatus == OrderStatus.pending || orderStatus == OrderStatus.processing;

  bool get isDelivered => orderStatus == OrderStatus.delivered;
  bool get isCancelled => orderStatus == OrderStatus.cancelled;
}