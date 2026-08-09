import 'package:equatable/equatable.dart';

class ProductDimension extends Equatable {
  final double length;
  final double width;
  final double height;
  final String unit;

  const ProductDimension({
    required this.length,
    required this.width,
    required this.height,
    required this.unit,
  });

  @override
  List<Object?> get props => [
    length,
    width,
    height,
    unit,
  ];
}