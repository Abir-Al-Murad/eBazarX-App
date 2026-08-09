import 'package:equatable/equatable.dart';

class ProductImage extends Equatable {
  final String id;
  final String productId;

  final String url;
  final bool isPrimary;
  final int sortOrder;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductImage({
    required this.id,
    required this.productId,
    required this.url,
    required this.isPrimary,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    url,
    isPrimary,
    sortOrder,
    createdAt,
    updatedAt,
  ];
}