import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  final String id;
  final String variantId;
  final String productId;
  final String productName;
  final double price;
  final Map<String, String>? variantAttributes;
  final String? productImage;
  final DateTime addedAt;

  const WishlistItem({
    required this.id,
    required this.variantId,
    required this.productId,
    required this.productName,
    required this.price,
    this.variantAttributes,
    this.productImage,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
    id,
    variantId,
    productId,
    productName,
    price,
    variantAttributes,
    productImage,
    addedAt,
  ];
}

