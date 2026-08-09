import '../../domain/entities/flash_sale_product_entity.dart';

class FlashSaleProductModel {
  final String id;
  final String productId;
  final double discountPrice;
  final int stockLimit;
  final int sold;
  final String flashSaleId;

  const FlashSaleProductModel({
    required this.id,
    required this.productId,
    required this.discountPrice,
    required this.stockLimit,
    required this.sold,
    required this.flashSaleId,
  });

  factory FlashSaleProductModel.fromJson(Map<String, dynamic> json) {
    return FlashSaleProductModel(
      id: json['id'],
      productId: json['product_id'],
      discountPrice: (json['discount_price'] as num).toDouble(),
      stockLimit: json['stock_limit'],
      sold: json['sold'],
      flashSaleId: json['flash_sale_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'discount_price': discountPrice,
      'stock_limit': stockLimit,
      'sold': sold,
      'flash_sale_id': flashSaleId,
    };
  }

  FlashSaleProduct toEntity() {
    return FlashSaleProduct(
      id: id,
      productId: productId,
      discountPrice: discountPrice,
      stockLimit: stockLimit,
      sold: sold,
      flashSaleId: flashSaleId,
    );
  }

  factory FlashSaleProductModel.fromEntity(
      FlashSaleProduct entity,
      ) {
    return FlashSaleProductModel(
      id: entity.id,
      productId: entity.productId,
      discountPrice: entity.discountPrice,
      stockLimit: entity.stockLimit,
      sold: entity.sold,
      flashSaleId: entity.flashSaleId,
    );
  }
}