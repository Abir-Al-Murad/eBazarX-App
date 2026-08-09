import 'package:flutter/material.dart';

class CheckoutAddressCard extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final VoidCallback onChange;

  const CheckoutAddressCard({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phone),
            const SizedBox(height: 4),
            Text(address),
          ],
        ),
        trailing: TextButton(
          onPressed: onChange,
          child: const Text("Change"),
        ),
      ),
    );
  }
}