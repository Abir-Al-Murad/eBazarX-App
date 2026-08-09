import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryHorizontalListShimmer extends StatelessWidget {
  const CategoryHorizontalListShimmer({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.dividerColor.withOpacity(0.3);
    final highlightColor = theme.dividerColor.withOpacity(0.1);

    final avatarRadius = context.isDesktop
        ? 60.0
        : context.isTablet
        ? 45.0
        : 30.0;

    final itemWidth = context.isDesktop
        ? 130.0
        : context.isTablet
        ? 100.0
        : 80.0;

    final height = context.isDesktop
        ? 200.0
        : context.isTablet
        ? 150.0
        : 100.0;

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: itemWidth,
              child: Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: baseColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      width: itemWidth * 0.7,
                      height: 12,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}