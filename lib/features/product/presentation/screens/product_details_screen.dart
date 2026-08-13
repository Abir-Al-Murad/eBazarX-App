import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/cart/presentation/providers/cart_providers.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
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
  // on/off switch. Mobile/tablet only — desktop uses a static header.
  void _handleScroll() {
    final collapsedAt = _expandedHeight - kToolbarHeight - _fadeRange;
    final opacity =
    ((_scrollController.offset - collapsedAt) / _fadeRange).clamp(0.0, 1.0);

    if (opacity != _titleOpacity) {
      setState(() => _titleOpacity = opacity);
    }
  }

  Future<void> _onAddToCart(BuildContext context, dynamic product) async {
    if (AuthStorage.accessToken == null) {
      AppSnackBar.info(context: context, "Please login to add to cart");
      return;
    }
    await ref.read(cartNotifierProvider.notifier).addToCart(
      variantId: ref.read(productDetailsNotifierProvider).selectedVariant?.id ??
          product.variants.first.id,
      quantity: ref.read(productDetailsNotifierProvider).quantity,
    );
    if (!context.mounted) return;
    final cartState = ref.read(cartNotifierProvider);
    if (cartState.failure != null) {
      AppSnackBar.error(context: context, cartState.failure!.message);
    } else {
      AppSnackBar.success(context: context, "Added to cart");
    }
  }

  void _onBuyNow(BuildContext context) {
    if (AuthStorage.accessToken == null) {
      AppSnackBar.info(context: context, "Please login to buy now");
      return;
    }
    context.pushNamed(AppRoutesName.checkout,extra: {"fromCart":false,"items":[CheckoutItemEntity(variant_id: ref.read(productDetailsNotifierProvider).selectedVariant!.id, quantity: ref.read(productDetailsNotifierProvider).quantity)],"subTotal":ref.read(productDetailsNotifierProvider).product!.discountPrice??ref.read(productDetailsNotifierProvider).product!.price });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productDetailsNotifierProvider);

    if (productState.isLoading) {
      return const ProductDetailsShimmer();
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

    if (context.isDesktop) {
      return _DesktopProductDetails(
        product: product,
        productState: productState,
        activeVariantId: activeVariantId!,
        totalStock: totalStock,
        productId: widget.productId,
        onAddToCart: () => _onAddToCart(context, product),
        onBuyNow: () => _onBuyNow(context),
      );
    }

    return _CompactProductDetails(
      product: product,
      productState: productState,
      activeVariantId: activeVariantId!,
      totalStock: totalStock,
      productId: widget.productId,
      scrollController: _scrollController,
      titleOpacity: _titleOpacity,
      expandedHeight: _expandedHeight,
      isTablet: context.isTablet,
      onAddToCart: () => _onAddToCart(context, product),
      onBuyNow: () => _onBuyNow(context),
    );
  }
}

// ============================================================
// MOBILE / TABLET — collapsing image header, single column scroll
// ============================================================

class _CompactProductDetails extends ConsumerWidget {
  const _CompactProductDetails({
    required this.product,
    required this.productState,
    required this.activeVariantId,
    required this.totalStock,
    required this.productId,
    required this.scrollController,
    required this.titleOpacity,
    required this.expandedHeight,
    required this.isTablet,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  final dynamic product;
  final dynamic productState;
  final String activeVariantId;
  final int totalStock;
  final String productId;
  final ScrollController scrollController;
  final double titleOpacity;
  final double expandedHeight;
  final bool isTablet;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Tablet gets a wider, centered content column instead of edge-to-edge.
    final maxContentWidth = isTablet ? 640.0 : double.infinity;

    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: expandedHeight,
            elevation: titleOpacity > 0.05 ? 1 : 0,
            backgroundColor: Color.lerp(
              Colors.transparent,
              theme.colorScheme.surface,
              titleOpacity,
            ),
            surfaceTintColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Color.lerp(
                Colors.white,
                theme.colorScheme.onSurface,
                titleOpacity,
              ),
            ),
            title: Opacity(
              opacity: titleOpacity,
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
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.paddingSizeDefault,
                ),
                child: _DetailsBody(
                  product: product,
                  productState: productState,
                  totalStock: totalStock,
                  productId: productId,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        productId: productId,
        variantId: activeVariantId,
        onAddToCart: onAddToCart,
        onBuyNow: onBuyNow,
      ),
    );
  }
}

// ============================================================
// DESKTOP — two-pane layout: sticky image left, scrollable info right
// ============================================================

class _DesktopProductDetails extends ConsumerWidget {
  const _DesktopProductDetails({
    required this.product,
    required this.productState,
    required this.activeVariantId,
    required this.totalStock,
    required this.productId,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  final dynamic product;
  final dynamic productState;
  final String activeVariantId;
  final int totalStock;
  final String productId;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0.5,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.all(context.paddingSizeExtraLarge),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sticky image column — stays put while the right side scrolls.
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(context.radiusLarge),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ProductImageCarousel(
                        images: product.images,
                        variantId: activeVariantId,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.paddingSizeExtraLarge),
                // Scrollable info + sticky action bar.
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: _DetailsBody(
                            product: product,
                            productState: productState,
                            totalStock: totalStock,
                            productId: productId,
                            showTitle: true,
                          ),
                        ),
                      ),
                      SizedBox(height: context.paddingSizeDefault),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(context.radiusLarge),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: BottomActionBar(
                          productId: productId,
                          variantId: activeVariantId,
                          onAddToCart: onAddToCart,
                          onBuyNow: onBuyNow,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SHARED — details column content, used by all three breakpoints
// ============================================================

class _DetailsBody extends ConsumerWidget {
  const _DetailsBody({
    required this.product,
    required this.productState,
    required this.totalStock,
    required this.productId,
    this.showTitle = false,
  });

  final dynamic product;
  final dynamic productState;
  final int totalStock;
  final String productId;
  // Desktop has no collapsing header, so the product name needs to show
  // up top instead of only in the (absent) app bar title.
  final bool showTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.paddingSizeSmall),

        ProductHeader(
          name: product.name,
          brand: product.brandId ?? "Unknown Brand",
        ),

        SizedBox(height: context.paddingSizeSmall),

        PriceSection(
          currentPrice: product.effectivePrice,
          oldPrice: product.price,
          discountPercent: product.discountPercent,
        ),

        SizedBox(height: context.paddingSizeDefault),

        StockStatus(stock: totalStock),
        SizedBox(height: context.paddingSizeDefault),

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
          SizedBox(height: context.paddingSizeExtraLarge),
          VariantSection(
            variants: product.variants,
            onVariantChanged: (variant) {
              ref.read(productDetailsNotifierProvider.notifier).selectVariant(variant);
            },
          ),
        ],
        SizedBox(height: context.paddingSizeExtraLarge),

        if (product.description != null && product.description!.isNotEmpty)
          DescriptionSection(description: product.description!),

        SizedBox(height: context.paddingSizeExtraLarge),

        if (product.dimensions != null)
          SpecificationSection(
            dimensions: product.dimensions!,
            weight: product.weight,
            sku: product.sku,
            tags: product.tags,
          ),
        SizedBox(height: context.paddingSizeExtraLarge),

        ReviewPreviewSection(productId: productId),

        // Extra bottom space only needed on mobile/tablet where the action
        // bar floats over content; desktop's action bar sits in normal flow.
        if (!showTitle) SizedBox(height: context.paddingSizeExtraLarge * 3),
      ],
    );
  }
}