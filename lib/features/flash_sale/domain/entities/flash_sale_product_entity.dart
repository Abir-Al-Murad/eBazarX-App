import 'package:equatable/equatable.dart';

class FlashSaleProduct extends Equatable {
  final String id;
  final String productId;
  final double discountPrice;
  final int stockLimit;
  final int sold;
  final String flashSaleId;

  const FlashSaleProduct({
    required this.id,
    required this.productId,
    required this.discountPrice,
    required this.stockLimit,
    required this.sold,
    required this.flashSaleId,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    discountPrice,
    stockLimit,
    sold,
    flashSaleId,
  ];
}