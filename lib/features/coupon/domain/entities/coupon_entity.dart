class CouponValidationEntity {
  final String? couponId;
  final double discountAmount;
  final bool valid;
  final String? message;

  const CouponValidationEntity({
    required this.couponId,
    required this.discountAmount,
    required this.valid,
    required this.message,
  });
}
