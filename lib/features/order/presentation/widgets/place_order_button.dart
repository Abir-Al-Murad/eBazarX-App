import 'package:flutter/material.dart';

class PlaceOrderButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const PlaceOrderButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      )
          : const Text("Place Order"),
    );
  }
}