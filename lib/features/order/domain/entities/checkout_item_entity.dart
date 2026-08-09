import 'package:equatable/equatable.dart';

class CheckoutItemEntity extends Equatable{
  final String variant_id;
  final int quantity;
  const CheckoutItemEntity({
    required this.variant_id,
    required this.quantity,
  });
  @override
  List<Object?> get props => [variant_id,quantity];
}