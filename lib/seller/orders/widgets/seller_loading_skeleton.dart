import 'package:flutter/material.dart';

class SellerLoadingSkeleton extends StatelessWidget {
  const SellerLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(width: 60, height: 60, color: Colors.grey[300]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12, width: double.infinity, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 100, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 150, color: Colors.grey[300]),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}