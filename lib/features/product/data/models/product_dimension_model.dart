import 'package:ebazarx/features/product/domain/entities/dimension_entity.dart';

class ProductDimensionModel {
  final double length;
  final double width;
  final double height;
  final String unit;

  const ProductDimensionModel({
    required this.length,
    required this.width,
    required this.height,
    required this.unit,
  });

  factory ProductDimensionModel.fromJson(Map<String, dynamic> json) {
    return ProductDimensionModel(
      length: (json['length'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() => {
    "length": length,
    "width": width,
    "height": height,
    "unit": unit,
  };

  ProductDimension toEntity() => ProductDimension(
    length: length,
    width: width,
    height: height,
    unit: unit,
  );

  factory ProductDimensionModel.fromEntity(ProductDimension entity) {
    return ProductDimensionModel(
      length: entity.length,
      width: entity.width,
      height: entity.height,
      unit: entity.unit,
    );
  }
}