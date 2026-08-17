import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/core/notification/notification_service.dart';
import 'package:ebazarx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ebazarx/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize Stripe
  // Stripe.publishableKey = "pk_test_51U2Yq5CFPMQq8ybY4iKmH9TUQcFuswvEVdFVfWiHaOcErQylrvkZxfqzXVwxJMoeZmkOj7ychYPFsgAQX6QCPQSC00GCmlwqpC";
  // await Stripe.instance.applySettings();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform
  // );
  // final NotificationService notificationService = NotificationService();
  // await notificationService.initialize();
  runApp(const ProviderScope(child: MyApp()));
}


