import 'package:flutter/material.dart';

class UploadAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const UploadAddButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade400,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 36),
            SizedBox(height: 8),
            Text("Add Images"),
          ],
        ),
      ),
    );
  }
}