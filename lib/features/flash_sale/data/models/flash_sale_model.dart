import '../../domain/entities/flash_sale_entity.dart';
import 'flash_sale_product_model.dart';

class FlashSaleModel {
  final String id;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FlashSaleProductModel> products;

  const FlashSaleModel({
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

  factory FlashSaleModel.fromJson(Map<String, dynamic> json) {
    return FlashSaleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      products: (json['products'] as List<dynamic>? ?? [])
          .map(
            (e) => FlashSaleProductModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'products': products.map((e) => e.toJson()).toList(),
    };
  }

  FlashSale toEntity() {
    return FlashSale(
      id: id,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      products: products.map((e) => e.toEntity()).toList(),
    );
  }

  factory FlashSaleModel.fromEntity(
      FlashSale entity,
      ) {
    return FlashSaleModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      products: entity.products
          .map(FlashSaleProductModel.fromEntity)
          .toList(),
    );
  }
}