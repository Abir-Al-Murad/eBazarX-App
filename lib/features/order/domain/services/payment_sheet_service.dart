abstract class PaymentSheetService {
  Future<String?> openPaymentSheet({
    required String clientSecret,
    required double amount,
    required String currency,
  });
}