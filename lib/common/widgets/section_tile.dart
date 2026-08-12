import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        if (subtitle != null)
          Text(subtitle!, style: const TextStyle(color: Colors.grey)),

      ],
    );
  }
}