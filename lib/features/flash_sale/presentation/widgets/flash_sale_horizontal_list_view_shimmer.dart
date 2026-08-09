import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FlashSaleHorizontalListShimmer extends StatelessWidget {
  const FlashSaleHorizontalListShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.dividerColor.withOpacity(0.3);
    final highlightColor = theme.dividerColor.withOpacity(0.1);

    Widget bone({double? width, double height = 12, double radius = 4}) {
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header placeholder ("Flash Sales" + "See All")
        Row(
          children: [
            bone(width: 24, height: 24, radius: 6),
            const SizedBox(width: 8),
            bone(width: 110, height: 18),
            const Spacer(),
            bone(width: 50, height: 14),
          ],
        ),
        const SizedBox(height: 16),

        // Card row
        SizedBox(
          height: 185,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return Container(
                width: 260,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          bone(width: 46, height: 20, radius: 30),
                          const Spacer(),
                          bone(width: 18, height: 18, radius: 4),
                        ],
                      ),
                      const SizedBox(height: 16),
                      bone(width: double.infinity, height: 16),
                      const SizedBox(height: 6),
                      bone(width: 160, height: 16),
                      const SizedBox(height: 10),
                      bone(width: double.infinity, height: 12),
                      const SizedBox(height: 6),
                      bone(width: 180, height: 12),
                      const Spacer(),
                      bone(width: 90, height: 12),
                      const SizedBox(height: 8),
                      bone(width: double.infinity, height: 8, radius: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}