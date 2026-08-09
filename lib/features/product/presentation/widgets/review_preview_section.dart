import 'package:ebazarx/features/product/presentation/widgets/rating_distribution.dart';
import 'package:ebazarx/features/product/presentation/widgets/rating_summary.dart';
import 'package:ebazarx/features/product/presentation/widgets/review_card.dart';
import 'package:ebazarx/features/reviews/presentation/providers/review_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReviewPreviewSection extends ConsumerStatefulWidget {
  final String productId;

  const ReviewPreviewSection({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ReviewPreviewSection> createState() =>
      _ReviewPreviewSectionState();
}

class _ReviewPreviewSectionState
    extends ConsumerState<ReviewPreviewSection> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref
          .read(customerReviewNotifierProvider.notifier)
          .getReviewStatistics(productId: widget.productId);

      await ref
          .read(customerReviewNotifierProvider.notifier)
          .loadReviews(productId: widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customerReviewNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (state.statistics != null &&
                state.statistics!.totalReviews > 3)
              TextButton(
                onPressed: () {
                  context.push('/reviews/${widget.productId}');
                },
                child: const Text('See All'),
              ),
          ],
        ),

        const SizedBox(height: 12),

        /// Statistics
        if (state.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (state.statistics != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RatingSummary(
                  averageRating: state.statistics!.averageRating,
                  totalReviews: state.statistics!.totalReviews,
                ),
              ),
              Expanded(
                flex: 2,
                child: RatingDistribution(
                  distribution: state.statistics!.ratingDistribution,
                ),
              ),
            ],
          ),

        const SizedBox(height: 16),

        /// Reviews
        if (state.isLoading)
          ...List.generate(
            3,
                (_) => _buildShimmerReview(context),
          )
        else if (state.failure != null)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  state.failure!.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(customerReviewNotifierProvider.notifier)
                        .getReviewStatistics(
                      productId: widget.productId,
                    );

                    await ref
                        .read(customerReviewNotifierProvider.notifier)
                        .loadReviews(
                      productId: widget.productId,
                    );
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          )
        else if (state.reviews.isEmpty)
            Center(
              child: Text(
                "No reviews yet",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            )
          else
            ...state.reviews.take(3).map(
                  (review) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ReviewCard(
                  review: review,
                  onVote: (voteType) {
                    ref
                        .read(customerReviewNotifierProvider.notifier)
                        .voteReview(
                      reviewId: review.id,
                      voteType: voteType,
                    );
                  },
                  onReport: () {},
                ),
              ),
            ),

        if (state.statistics != null &&
            state.statistics!.totalReviews > 3)
          Center(
            child: TextButton(
              onPressed: () {
                context.push('/reviews/${widget.productId}');
              },
              child: Text(
                "See All ${state.statistics!.totalReviews} Reviews",
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShimmerReview(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}