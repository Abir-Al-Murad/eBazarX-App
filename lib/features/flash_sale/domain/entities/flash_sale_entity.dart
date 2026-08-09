import 'package:equatable/equatable.dart';
import 'flash_sale_product_entity.dart';

class FlashSale extends Equatable {
  final String id;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FlashSaleProduct> products;

  const FlashSale({
    required this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.products = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    startDate,
    endDate,
    isActive,
    createdAt,
    updatedAt,
    products,
  ];
}