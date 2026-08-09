import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';

class CheckoutItemModel {
  final String variantId;
  final int quantity;

  const CheckoutItemModel({
    required this.variantId,
    required this.quantity,
  });

  factory CheckoutItemModel.fromJson(Map<String, dynamic> json) {
    return CheckoutItemModel(
      variantId: json['variant_id'].toString(),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variant_id': variantId,
      'quantity': quantity,
    };
  }

  factory CheckoutItemModel.fromEntity(CheckoutItemEntity entity) {
    return CheckoutItemModel(
      variantId: entity.variant_id,
      quantity: entity.quantity,
    );
  }

  CheckoutItemEntity toEntity() {
    return CheckoutItemEntity(
      variant_id: variantId,
      quantity: quantity,
    );
  }
}