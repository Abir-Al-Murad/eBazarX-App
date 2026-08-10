enum PaymentMethod {
  cod('cod'),
  sslcommerz('sslcommerz');

  final String value;
  const PaymentMethod(this.value);

  static PaymentMethod fromString(String value) {
    return values.firstWhere((e) => e.value == value);
  }
}

enum PaymentStatus {
  pending, paid, failed, refunded,processing;
}