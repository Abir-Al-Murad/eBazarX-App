import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.banners,
    this.height = 180,
    this.onBannerTap,
  });

  final List<BannerEntity> banners;
  final double height;
  final void Function(int index)? onBannerTap;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final _controller = CarouselSliderController();
  int _currentIndex = 0;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    /// Mobile: full-bleed, one banner at a time.
    /// Tablet/Desktop: peek preview of neighbouring banners.
    final viewportFraction = context.responsive<double>(
      mobile: 1,
      tablet: 0.86,
      desktop: 0.72,
    );
    final radius = context.responsive<double>(
      mobile: context.radiusLarge,
      tablet: context.radiusLarge,
      desktop: context.radiusExtraLarge,
    );
    final showArrows = !context.isMobile && widget.banners.length > 1;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider.builder(
                carouselController: _controller,
                itemCount: widget.banners.length,
                options: CarouselOptions(
                  height: widget.height,
                  viewportFraction: viewportFraction,
                  autoPlay: widget.banners.length > 1 && !_isHovering,
                  enlargeCenterPage: viewportFraction < 1,
                  onPageChanged: (index, reason) {
                    setState(() => _currentIndex = index);
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final banner = widget.banners[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: viewportFraction < 0.8 ? 6 : 3,
                    ),
                    child: GestureDetector(
                      onTap: widget.onBannerTap == null
                          ? null
                          : () => widget.onBannerTap!(index),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(radius),
                        child: CachedNetworkImage(
                          imageUrl: banner.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: theme.dividerColor.withValues(alpha: 0.15),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: theme.dividerColor.withValues(alpha: 0.15),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              /// Hover-revealed prev/next controls (desktop/tablet only —
              /// mobile relies on swipe).
              if (showArrows) ...[
                Positioned(
                  left: 4,
                  child: _CarouselArrow(
                    icon: Icons.chevron_left_rounded,
                    visible: _isHovering,
                    onTap: () => _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  child: _CarouselArrow(
                    icon: Icons.chevron_right_rounded,
                    visible: _isHovering,
                    onTap: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (widget.banners.length > 1) ...[
            SizedBox(height: context.paddingSizeSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.banners.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({
    required this.icon,
    required this.visible,
    required this.onTap,
  });

  final IconData icon;
  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(
        ignoring: !visible,
        child: Material(
          color: theme.colorScheme.surface.withValues(alpha: 0.85),
          shape: const CircleBorder(),
          elevation: 2,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                icon,
                size: 22,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}