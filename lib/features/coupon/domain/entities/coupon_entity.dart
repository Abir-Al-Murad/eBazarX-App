import 'package:equatable/equatable.dart';

class CouponEntity  extends Equatable{
  final String? id;
  final bool valid;
  final double discountAmount;
  final String message;

  const CouponEntity({
    required this.id,
    required this.valid,
    required this.discountAmount,
    required this.message,
  });

  @override
  List<Object?> get props => [id, valid, discountAmount, message];

}