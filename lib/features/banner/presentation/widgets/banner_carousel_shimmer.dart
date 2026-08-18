import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerCarouselShimmer extends StatelessWidget {
  const BannerCarouselShimmer({super.key, this.height = 180});

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.dividerColor.withValues(alpha: 0.3);
    final highlightColor = theme.dividerColor.withValues(alpha: 0.1);

    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
                (index) => Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 0 ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}