import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/features/cart/presentation/providers/cart_providers.dart';
import 'package:ebazarx/features/product/presentation/providers/product_providers.dart';
import 'package:ebazarx/features/product/presentation/widgets/product_details_shimmer.dart';
import 'package:ebazarx/features/product/presentation/widgets/quantity_section.dart';
import 'package:ebazarx/features/product/presentation/widgets/variant_section.dart';
import 'package:ebazarx/features/reviews/presentation/providers/review_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_action_bar.dart';
import '../widgets/description_section.dart';
import '../widgets/price_section.dart';
import '../widgets/product_header.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/review_preview_section.dart';
import '../widgets/specification_section.dart';
import '../widgets/stock_status.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  static const double _expandedHeight = 320;
  static const double _fadeRange = 60;

  final ScrollController _scrollController = ScrollController();
  double _titleOpacity = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_handleScroll);

    Future.microtask(() async {
      await ref
          .read(productDetailsNotifierProvider.notifier)
          .fetchProductDetails(widget.productId);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Fades the app bar title + background in over the last [_fadeRange]
  // pixels before the SliverAppBar fully collapses, instead of an abrupt
  // on/off switch.
  void _handleScroll() {
    final collapsedAt = _expandedHeight - kToolbarHeight - _fadeRange;
    final opacity =
    ((_scrollController.offset - collapsedAt) / _fadeRange).clamp(0.0, 1.0);

    if (opacity != _titleOpacity) {
      setState(() => _titleOpacity = opacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productDetailsNotifierProvider);
    final theme = Theme.of(context);

    if (productState.isLoading) {
      return ProductDetailsShimmer();
    }

    if (productState.failure != null) {
      return Scaffold(
        body: Center(child: Text(productState.failure.toString())),
      );
    }

    final product = productState.product;

    if (product == null) {
      return const Scaffold(body: Center(child: Text("Product not found")));
    }

    final totalStock = product.variants.fold<int>(
      0,
          (sum, item) => sum + item.stock,
    );

    final activeVariantId = productState.selectedVariant?.id ??
        (product.variants.isNotEmpty ? product.variants.first.id : null);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: _expandedHeight,
            elevation: _titleOpacity > 0.05 ? 1 : 0,
            backgroundColor:
            Color.lerp(Colors.transparent, theme.colorScheme.surface, _titleOpacity),
            surfaceTintColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Color.lerp(
                Colors.white,
                theme.colorScheme.onSurface,
                _titleOpacity,
              ),
            ),
            title: Opacity(
              opacity: _titleOpacity,
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ProductImageCarousel(
                images: product.images,
                variantId: activeVariantId,
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              ProductHeader(
                name: product.name,
                brand: product.brandId ?? "Unknown Brand",
              ),

              const SizedBox(height: 12),

              PriceSection(
                currentPrice: product.effectivePrice,
                oldPrice: product.price,
                discountPercent: product.discountPercent,
              ),

              const SizedBox(height: 16),

              StockStatus(stock: totalStock),
              const SizedBox(height: 16),

              QuantitySection(
                quantity: productState.quantity,
                onIncrease: () {
                  ref.read(productDetailsNotifierProvider.notifier).increaseQuantity();
                },
                onDecrease: () {
                  ref.read(productDetailsNotifierProvider.notifier).decreaseQuantity();
                },
              ),
              if (product.variants.isNotEmpty) ...[
                const SizedBox(height: 20),

                VariantSection(
                  variants: product.variants,
                  onVariantChanged: (variant) {
                    ref
                        .read(productDetailsNotifierProvider.notifier)
                        .selectVariant(variant);
                  },
                ),
              ],
              const SizedBox(height: 20),

              if (product.description != null &&
                  product.description!.isNotEmpty)
                DescriptionSection(description: product.description!),

              const SizedBox(height: 20),

              if (product.dimensions != null)
                SpecificationSection(
                  dimensions: product.dimensions!,
                  weight: product.weight,
                  sku: product.sku,
                  tags: product.tags,
                ),
              const SizedBox(height: 20),

              ReviewPreviewSection(productId: widget.productId),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomActionBar(
        productId: widget.productId,
        variantId: activeVariantId!,
        onAddToCart: () async{
          print(AuthStorage.accessToken);
          if(AuthStorage.accessToken == null){
            AppSnackBar.info(context: context,"Please login to add to cart");
            return;
          }
          await ref.read(cartNotifierProvider.notifier).addToCart(
            variantId: ref.read(productDetailsNotifierProvider)
                .selectedVariant?.id ??
                product.variants.first.id,
            quantity: ref.read(productDetailsNotifierProvider).quantity,
          );
          if(ref.watch(cartNotifierProvider).failure != null){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(ref.watch(cartNotifierProvider).failure.toString())),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Added to cart")),
            );
          }
        },
        onBuyNow: () {
          if(AuthStorage.accessToken == null){
            AppSnackBar.info(context: context,"Please login to buy now");
            return;
          }
          context.pushNamed(AppRoutesName.checkout);
        },
      ),
    );
  }
}