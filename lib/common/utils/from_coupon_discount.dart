
String formatCouponDiscount({
  required String discountType,
  required double discountValue,
}) {
  return discountType == 'percentage'
      ? '${discountValue.toStringAsFixed(0)}% off'
      : '৳${discountValue.toStringAsFixed(2)} off';
}