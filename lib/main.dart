import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize Stripe
  // Stripe.publishableKey = "pk_test_51U2Yq5CFPMQq8ybY4iKmH9TUQcFuswvEVdFVfWiHaOcErQylrvkZxfqzXVwxJMoeZmkOj7ychYPFsgAQX6QCPQSC00GCmlwqpC";
  // await Stripe.instance.applySettings();

  runApp(const ProviderScope(child: MyApp()));
}
