import 'package:flutter/material.dart';

class CheckoutLoading extends StatelessWidget {
  const CheckoutLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}