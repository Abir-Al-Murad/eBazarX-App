import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/presentation/providers/product_providers.dart';
import 'package:ebazarx/features/product/presentation/widgets/product_card.dart';
import 'package:ebazarx/features/product/presentation/widgets/recommended_products_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecommendedProductsSection extends ConsumerStatefulWidget {
  const RecommendedProductsSection({
    super.key,
    this.products,
    this.crossAxisCount,
  });

  final List<Product>? products;

  /// Override the grid column count. If null, falls back to a
  /// responsive default (2 / 3 / 4 for mobile / tablet / desktop).
  final int? crossAxisCount;

  @override
  ConsumerState<RecommendedProductsSection> createState() =>
      _RecommendedProductsSectionState();
}

class _RecommendedProductsSectionState
    extends ConsumerState<RecommendedProductsSection> {
  @override
  void initState() {
    super.initState();

    // if (widget.products == null) {
    //   Future.microtask(() {
    //     ref
    //         .read(userProductListNotifierProvider.notifier)
    //         .fetchProducts(refresh: true);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(userProductListNotifierProvider);

    /// Use injected data if available
    final products = widget.products ?? state.products;

    /// Loading
    if (widget.products == null && state.isLoading) {
      return const RecommendedProductsShimmer();
    }

    /// Error
    if (widget.products == null && state.failure != null) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: theme.colorScheme.error,
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                'Failed to load recommended products',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              TextButton(
                onPressed: () => ref
                    .read(userProductListNotifierProvider.notifier)
                    .fetchProducts(refresh: true),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    /// Empty
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    final crossAxisCount = widget.crossAxisCount ??
        context.responsive(mobile: 2, tablet: 3, desktop: 4);
    final gridSpacing = context.responsive<double>(
      mobile: 14,
      tablet: 16,
      desktop: 18,
    );
    final aspectRatio = context.responsive<double>(
      mobile: 0.62,
      tablet: 0.68,
      desktop: 0.72,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recommended Products',
              style: theme.textTheme.titleLarge,
            ),
            // const Spacer(),
            // TextButton(
            //   onPressed: () {
            //     // TODO: navigate to full recommended products list
            //   },
            //   child: const Text('See All'),
            // ),
          ],
        ),
        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount??2,
            crossAxisSpacing: gridSpacing,
            mainAxisSpacing: gridSpacing,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (_, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () {
                context.push('/product/${product.id}');
              },
            );
          },
        ),

        /// Pagination loader
        if (widget.products == null && state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}