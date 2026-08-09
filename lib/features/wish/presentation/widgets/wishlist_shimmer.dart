import 'package:flutter/material.dart';

class WishlistShimmer extends StatelessWidget {
  const WishlistShimmer({super.key});

  Widget box({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            box(width: 90, height: 90),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  box(width: 170, height: 18),
                  const SizedBox(height: 8),
                  box(width: 120, height: 14),
                  const SizedBox(height: 12),
                  box(width: 80, height: 18),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: box(width: 0, height: 38)),
                      const SizedBox(width: 8),
                      box(width: 42, height: 38),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}