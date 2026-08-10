import 'package:ebazarx/features/order/domain/entities/payment_method.dart';
import 'package:equatable/equatable.dart';
import 'order_status.dart';
import 'order_item_entity.dart';

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

  // Stripe specific fields
  final String? clientSecret;
  final String? paymentIntentId;

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
    this.clientSecret,
    this.paymentIntentId,
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
    clientSecret,
    paymentIntentId,
  ];

  bool get isCancellable =>
      orderStatus == OrderStatus.pending || orderStatus == OrderStatus.processing;

  bool get isDelivered => orderStatus == OrderStatus.delivered;
  bool get isCancelled => orderStatus == OrderStatus.cancelled;

  // CopyWith method
  OrderEntity copyWith({
    String? id,
    String? userId,
    String? addressId,
    double? subtotal,
    double? shippingFee,
    double? tax,
    double? discountAmount,
    double? grandTotal,
    String? paymentMethod,
    PaymentStatus? paymentStatus,
    OrderStatus? orderStatus,
    String? trackingNumber,
    DateTime? estimatedDelivery,
    String? notes,
    String? couponId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItemEntity>? items,
    String? clientSecret,
    String? paymentIntentId,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressId: addressId ?? this.addressId,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      tax: tax ?? this.tax,
      discountAmount: discountAmount ?? this.discountAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      notes: notes ?? this.notes,
      couponId: couponId ?? this.couponId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
      clientSecret: clientSecret ?? this.clientSecret,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
    );
  }
}