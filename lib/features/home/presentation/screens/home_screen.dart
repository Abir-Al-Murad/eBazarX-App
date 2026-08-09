import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/banner/presentation/providers/banner_providers.dart';
import 'package:ebazarx/features/banner/presentation/widgets/banner_carousel.dart';
import 'package:ebazarx/features/banner/presentation/widgets/banner_carousel_shimmer.dart';
import 'package:ebazarx/features/category/presentation/providers/category_providers.dart';
import 'package:ebazarx/features/category/presentation/widgets/category_horizontal_list_view.dart';
import 'package:ebazarx/features/flash_sale/data/dummy/dummy_data.dart';
import 'package:ebazarx/features/flash_sale/presentation/providers/flash_sale_providers.dart';
import 'package:ebazarx/features/flash_sale/presentation/widgets/flash_sale_horizontal_list_view.dart';
import 'package:ebazarx/features/product/presentation/providers/product_providers.dart';
import 'package:ebazarx/features/product/presentation/widgets/recomended_products_section.dart';
import 'package:ebazarx/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Future.microtask(_refreshAll);
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      ref.read(publicBannerListNotifierProvider.notifier).fetchBanners(),
      ref
          .read(categoryListNotifierProvider.notifier)
          .fetchCategories(refresh: true),
      ref.read(flashSaleListNotifierProvider.notifier).fetchFlashSales(),
      ref
          .read(userProductListNotifierProvider.notifier)
          .fetchProducts(refresh: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bannerState = ref.watch(publicBannerListNotifierProvider);

    final maxContentWidth = context.responsive<double>(
      mobile: double.infinity,
      tablet: 900,
      desktop: 1240,
    );
    final double radius = context.responsive(mobile: 22, tablet: 30, desktop: 35);

    final horizontalPadding = context.responsive(
      mobile: context.paddingSizeDefault,
      tablet: context.paddingSizeExtraLarge,
      desktop: context.paddingSizeOverLarge,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAll,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: context.paddingSizeDefault,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeHeader(context, theme,radius),
                    SizedBox(height: context.paddingSizeLarge),

                    _buildSearchBar(context, theme),
                    SizedBox(height: context.paddingSizeExtraLarge),

                    /// Banner
                    _buildBannerSection(bannerState, theme),
                    SizedBox(height: context.paddingSizeExtraLarge),

                    /// Categories
                    const CategoryHorizontalListView(),

                    /// Flash Sale
                    FlashSaleHorizontalListView(
                      flashSales: FlashSaleDummy.flashSales,
                    ),
                    SizedBox(height: context.paddingSizeExtraLarge),

                    /// Recommended Products
                    const RecommendedProductsSection(),
                    SizedBox(height: context.paddingSizeDefault),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(
      BuildContext context,
      ThemeData theme,
      double radius,
      ) {
    final profile = ref.watch(profileNotifierProvider).profile;
    final profileImage = profile?.profileImage;
    final name = profile?.fullName;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
            backgroundImage: profileImage != null
                ? CachedNetworkImageProvider(profileImage)
                : null,
            child: profileImage == null
                ? Icon(
              Icons.person_rounded,
              size: radius,
              color: theme.colorScheme.primary,
            )
                : null,
          ),
        ),
        SizedBox(width: context.paddingSizeDefault),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greetingForNow(),
                style: TextStyle(
                  fontSize: context.fontSizeSmall,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name ?? 'Welcome to eBazar',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: context.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              // TODO: navigate to notifications screen
            },
            icon: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.onSurface,
            ),
          ),
        if (context.isDesktop)
          IconButton(
            tooltip: 'Cart',
            onPressed: () => context.push('/cart'),
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: theme.colorScheme.onSurface,
            ),
          ),
      ],
    );
  }

  String _greetingForNow() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Tappable search "container" — navigates to the dedicated search
  /// screen instead of hosting a live TextField here. Wrapped in a Hero
  /// so it can morph into the real search field on SearchProductScreen.
  /// Make sure SearchProductScreen wraps its TextField in a Hero with
  /// the same tag ('search-bar-hero').
  Widget _buildSearchBar(BuildContext context, ThemeData theme) {
    return Hero(
      tag: 'search-bar-hero',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.radiusLarge),
          onTap: () => context.push('/search'),
          child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(
              horizontal: context.paddingSizeDefault,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(context.radiusLarge),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Search products...',
                    style: TextStyle(
                      fontSize: context.fontSizeDefault,
                      color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection(dynamic bannerState, ThemeData theme) {
    final height = context.responsive<double>(
      mobile: 160,
      tablet: 200,
      desktop: 260,
    );

    if (bannerState.isLoading) {
      return const BannerCarouselShimmer();
    }

    if (bannerState.failure != null) {
      return SizedBox(
        height: height,
        child: Center(
          child: TextButton.icon(
            onPressed: () {
              ref
                  .read(publicBannerListNotifierProvider.notifier)
                  .fetchBanners();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry loading banners'),
          ),
        ),
      );
    }

    return BannerCarousel(
      banners: bannerState.banners,
      height: height,
    );
  }
}