import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    Widget box({
      double? width,
      required double height,
      BorderRadius? radius,
    }) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      );
    }

    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 320,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: box(
                  height: 320,
                  radius: BorderRadius.zero,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    /// Product Name
                    box(width: 220, height: 24),

                    const SizedBox(height: 8),

                    /// Brand
                    box(width: 100, height: 16),

                    const SizedBox(height: 20),

                    /// Price
                    Row(
                      children: [
                        box(width: 90, height: 28),
                        const SizedBox(width: 12),
                        box(width: 60, height: 18),
                        const SizedBox(width: 12),
                        box(width: 45, height: 22),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// Stock
                    box(width: 120, height: 20),

                    const SizedBox(height: 24),

                    /// Quantity
                    Row(
                      children: [
                        box(width: 40, height: 40),
                        const SizedBox(width: 16),
                        box(width: 40, height: 20),
                        const SizedBox(width: 16),
                        box(width: 40, height: 40),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// Variants
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(
                        4,
                            (_) => box(
                          width: 80,
                          height: 36,
                          radius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// Description Title
                    box(width: 140, height: 22),

                    const SizedBox(height: 12),

                    ...List.generate(
                      4,
                          (_) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: box(
                          width: double.infinity,
                          height: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// Specification Title
                    box(width: 130, height: 22),

                    const SizedBox(height: 12),

                    ...List.generate(
                      5,
                          (_) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            box(width: 90, height: 14),
                            const SizedBox(width: 16),
                            Expanded(
                              child: box(height: 14),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Review title
                    box(width: 150, height: 22),

                    const SizedBox(height: 16),

                    ...List.generate(
                      2,
                          (_) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(radius: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  box(width: 120, height: 16),
                                  const SizedBox(height: 8),
                                  box(
                                    width: double.infinity,
                                    height: 14,
                                  ),
                                  const SizedBox(height: 6),
                                  box(width: 180, height: 14),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: box(height: 52)),
              const SizedBox(width: 12),
              Expanded(child: box(height: 52)),
            ],
          ),
        ),
      ),
    );
  }
}