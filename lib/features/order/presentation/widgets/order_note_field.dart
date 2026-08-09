import 'package:flutter/material.dart';

class OrderNoteField extends StatelessWidget {
  final TextEditingController controller;

  const OrderNoteField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: "Note to seller",
        hintText: "Any delivery instructions...",
        border: OutlineInputBorder(),
      ),
    );
  }
}