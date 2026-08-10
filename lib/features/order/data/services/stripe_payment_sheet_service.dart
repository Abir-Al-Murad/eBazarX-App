// import 'package:ebazarx/features/order/domain/services/payment_sheet_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
// class StripePaymentSheetService implements PaymentSheetService {
//   @override
//   Future<String?> openPaymentSheet({required String clientSecret, required double amount, required String currency}) async {
//     try {
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: clientSecret,
//           merchantDisplayName: 'eBazar',
//           style: ThemeMode.system,
//         ),
//       );

//       await Stripe.instance.presentPaymentSheet();
//       return null; // Success
//     } on StripeException catch (e, stackTrace) {
//       debugPrint('========== STRIPE ERROR ==========');
//       debugPrint('Code: ${e.error.code}');
//       debugPrint('Message: ${e.error.message}');
//       debugPrint('Localized Message: ${e.error.localizedMessage}');
//       debugPrint('Stripe Exception: $e');
//       debugPrintStack(stackTrace: stackTrace);
//
//       return e.error.message ?? 'Stripe payment failed';
//     }catch (e) {
//       debugPrint('========== UNEXPECTED ERROR ==========');
//       debugPrint('Error: $e');
//       return e.toString();
//     }
//   }
// }