import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_status.dart';
import 'package:ebazarx/features/order/domain/entities/payment_method.dart';
import 'order_item_model.dart';

class OrderModel {
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
  final List<OrderItemModel> items;

  // Stripe specific fields
  final String? clientSecret;
  final String? paymentIntentId;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.discountAmount,
    required this.grandTotal,
    this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      addressId: json['address_id'],
      subtotal: double.parse(json['subtotal'].toString()),
      shippingFee: double.parse(json['shipping_fee'].toString()),
      tax: double.parse(json['tax'].toString()),
      discountAmount: double.parse(json['discount_amount'].toString()),
      grandTotal: double.parse(json['grand_total'].toString()),
      paymentMethod: json['payment_method'],
      paymentStatus: PaymentStatus.values.byName(
        json['payment_status'].toString().toLowerCase(),
      ),
      orderStatus: OrderStatus.values.byName(
        json['order_status'].toString().toLowerCase(),
      ),
      trackingNumber: json['tracking_number'],
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'])
          : null,
      notes: json['notes'],
      couponId: json['coupon_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      clientSecret: json['client_secret'],
      paymentIntentId: json['payment_intent_id'],
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      addressId: entity.addressId,
      subtotal: entity.subtotal,
      shippingFee: entity.shippingFee,
      tax: entity.tax,
      discountAmount: entity.discountAmount,
      grandTotal: entity.grandTotal,
      paymentMethod: entity.paymentMethod,
      paymentStatus: entity.paymentStatus,
      orderStatus: entity.orderStatus,
      trackingNumber: entity.trackingNumber,
      estimatedDelivery: entity.estimatedDelivery,
      notes: entity.notes,
      couponId: entity.couponId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      items: entity.items.map((e) => OrderItemModel.fromEntity(e)).toList(),
      clientSecret: entity.clientSecret,
      paymentIntentId: entity.paymentIntentId,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      addressId: addressId,
      subtotal: subtotal,
      shippingFee: shippingFee,
      tax: tax,
      discountAmount: discountAmount,
      grandTotal: grandTotal,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      orderStatus: orderStatus,
      trackingNumber: trackingNumber,
      estimatedDelivery: estimatedDelivery,
      notes: notes,
      couponId: couponId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      items: items.map((e) => e.toEntity()).toList(),
      clientSecret: clientSecret,
      paymentIntentId: paymentIntentId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'address_id': addressId,
    'subtotal': subtotal,
    'shipping_fee': shippingFee,
    'tax': tax,
    'discount_amount': discountAmount,
    'grand_total': grandTotal,
    'payment_method': paymentMethod,
    'payment_status': paymentStatus.name,
    'order_status': orderStatus.name,
    'tracking_number': trackingNumber,
    'estimated_delivery': estimatedDelivery?.toIso8601String(),
    'notes': notes,
    'coupon_id': couponId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
    'client_secret': clientSecret,
    'payment_intent_id': paymentIntentId,
  };
}