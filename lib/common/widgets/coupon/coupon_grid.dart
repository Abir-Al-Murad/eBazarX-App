// common/widgets/coupon/coupon_grid.dart
import 'package:ebazarx/common/widgets/coupon/coupon_card.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';

/// Mobile/tablet coupon grid — shared by admin + seller coupon screens.
class CouponGrid extends StatelessWidget {
  const CouponGrid({
    super.key,
    required this.items,
    required this.hasMore,
    required this.crossAxisCount,
    this.scrollController,
  });

  final List<CouponCard> items;
  final bool hasMore;
  final int crossAxisCount;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
          sliver: crossAxisCount == 1
              ? SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(height: context.paddingSizeSmall),
            itemBuilder: (context, index) => items[index],
          )
              : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.5,
              crossAxisSpacing: context.paddingSizeDefault,
              mainAxisSpacing: context.paddingSizeDefault,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => items[index],
              childCount: items.length,
            ),
          ),
        ),
        if (hasMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
              child: const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}