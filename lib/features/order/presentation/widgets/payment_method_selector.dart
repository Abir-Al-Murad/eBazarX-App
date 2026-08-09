import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const methods = [
      "Cash on Delivery",
      "bKash",
      "Nagad",
      "Rocket",
      "SSLCommerz",
      "Stripe",
    ];

    return Card(
      child: Column(
        children: methods
            .map(
              (e) => RadioListTile<String>(
            title: Text(e),
            value: e,
            groupValue: selected,
            onChanged: (value) => onChanged(value!),
          ),
        )
            .toList(),
      ),
    );
  }
}