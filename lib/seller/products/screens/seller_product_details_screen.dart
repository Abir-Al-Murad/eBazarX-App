import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/seller/products/notifiers/seller_product_details_notifier.dart';
import 'package:ebazarx/seller/products/providers/seller_product_providers.dart';
import 'package:ebazarx/seller/products/states/seller_product_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_header.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_image_gallery.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_basic_info.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_price_card.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_statistics.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_description.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_specifications.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_variants.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_images_grid.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_activity_card.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_actions.dart';
import 'package:ebazarx/seller/products/widgets/seller_loading_skeleton.dart';
import 'package:ebazarx/seller/products/widgets/seller_error_widget.dart';

class SellerProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const SellerProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<SellerProductDetailsScreen> createState() => _SellerProductDetailsScreenState();
}

class _SellerProductDetailsScreenState extends ConsumerState<SellerProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sellerProductDetailsNotifierProvider.notifier).fetchSellerProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerProductDetailsNotifierProvider);
    final notifier = ref.read(sellerProductDetailsNotifierProvider.notifier);

    return Scaffold(
      appBar: SellerProductHeader(
        product: state.product,
        isLoading: state.isLoading,
        onBack: () => Navigator.pop(context),
        onEdit: () {
          // Navigate to edit product screen
        },
        onDelete: () {
          // Show delete confirmation
        },
        onShare: () {
          // Share product link
        },
        onMore: () {
          // Show more options
        },
      ),
      body: _buildBody(state, notifier),
    );
  }

  Widget _buildBody(SellerProductDetailsState state, SellerProductDetailsNotifier notifier) {
    if (state.isLoading) {
      return const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SellerLoadingSkeleton(),
      );
    }

    if (state.failure != null) {
      return SellerErrorWidget(
        error: state.failure!.message,
        onRetry: () => notifier.fetchSellerProduct(widget.productId),
      );
    }

    final product = state.product;
    if (product == null) {
      return const Center(child: Text('No product data'));
    }

    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: isDesktop ? _buildDesktopLayout(product) : _buildMobileLayout(product),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: Image Gallery + Info + Price
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: SellerProductImageGallery(images: product.images),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SellerProductBasicInfo(product: product),
                  const SizedBox(height: 16),
                  SellerProductPriceCard(product: product),
                  const SizedBox(height: 16),
                  SellerProductActions(product: product),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Statistics row
        SellerProductStatistics(product: product),
        const SizedBox(height: 24),
        // Two-column details
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SellerProductDescription(product: product),
                  const SizedBox(height: 16),
                  SellerProductSpecifications(product: product),
                  const SizedBox(height: 16),
                  SellerProductImagesGrid(images: product.images),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  SellerProductVariants(variants: product.variants),
                  const SizedBox(height: 16),
                  SellerProductActivityCard(product: product),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SellerProductImageGallery(images: product.images),
        const SizedBox(height: 16),
        SellerProductBasicInfo(product: product),
        const SizedBox(height: 16),
        SellerProductPriceCard(product: product),
        const SizedBox(height: 16),
        SellerProductStatistics(product: product),
        const SizedBox(height: 16),
        SellerProductDescription(product: product),
        const SizedBox(height: 16),
        SellerProductSpecifications(product: product),
        const SizedBox(height: 16),
        SellerProductVariants(variants: product.variants),
        const SizedBox(height: 16),
        SellerProductImagesGrid(images: product.images),
        const SizedBox(height: 16),
        SellerProductActivityCard(product: product),
        const SizedBox(height: 16),
        SellerProductActions(product: product),
      ],
    );
  }
}