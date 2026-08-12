// admin/reviews/presentation/screens/admin_review_detail_screen.dart

import 'package:ebazarx/admin/reviews/providers/admin_review_providers.dart';
import 'package:ebazarx/admin/reviews/states/admin_review_crud_state.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminReviewDetailScreen extends ConsumerStatefulWidget {
  final String reviewId;

  const AdminReviewDetailScreen({super.key, required this.reviewId});

  @override
  ConsumerState<AdminReviewDetailScreen> createState() =>
      _AdminReviewDetailScreenState();
}

class _AdminReviewDetailScreenState
    extends ConsumerState<AdminReviewDetailScreen> {
  ReviewEntity? _review;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReview();
    });
  }

  Future<void> _loadReview() async {
    // We need to fetch the review by ID. Since the notifier doesn't have
    // a fetch-by-id method, we can either add one or use the list state.
    // For simplicity, we'll rely on the list state and find the review.
    // Alternatively, we could call an API directly, but we'll use the list.
    final state = ref.read(adminReviewListNotifierProvider);
    final review = state.reviews.firstWhere(
          (r) => r.id == widget.reviewId,
      orElse: () => throw Exception('Review not found'),
    );
    setState(() {
      _review = review;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_review == null) {
      return  Scaffold(
        appBar: AppBar(title: Text('Review Detail')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final review = _review!;
    final crudState = ref.watch(adminReviewCrudNotifierProvider);
    final crudNotifier = ref.read(adminReviewCrudNotifierProvider.notifier);

    // Check if this review has a pending report (we can check from list state)
    final reports = ref.watch(adminReviewListNotifierProvider).reports;
    final pendingReport = reports.firstWhere(
          (r) => r.reviewId == review.id && !r.resolved,
      orElse: () => throw Exception('No pending report'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Review #${review.id.substring(0, 8)}'),
        actions: [
          // Hide/Unhide
          IconButton(
            icon: Icon(review.isHidden ? Icons.visibility : Icons.visibility_off),
            onPressed: crudState.isHiding ? null : () => _toggleHide(review.id),
          ),
          // Delete
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: crudState.isDeleting ? null : () => _confirmDelete(context, review.id),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating & metadata
                Row(
                  children: [
                    _buildRatingChip(review.rating),
                    const SizedBox(width: 8),
                    if (review.isVerified)
                      const Chip(
                        label: Text('Verified'),
                        backgroundColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    if (review.isHidden)
                      const Chip(
                        label: Text('Hidden'),
                        backgroundColor: Colors.red,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Comment
                if (review.comment != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(review.comment!),
                    ),
                  ),

                // Images
                if (review.images.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Images',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: review.images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final image = review.images[index];
                        return Image.network(
                          image.url,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ],

                // Reply
                if (review.reply != null) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Seller Reply',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review.reply!.reply),
                          const SizedBox(height: 4),
                          Text(
                            'Replied: ${DateFormat('yyyy-MM-dd HH:mm').format(review.reply!.createdAt)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                _InfoRow('Product ID', review.productId),
                _InfoRow('User ID', review.userId),
                if (review.orderId != null) _InfoRow('Order ID', review.orderId!),
                _InfoRow('Likes / Dislikes', '${review.likes} / ${review.dislikes}'),
                _InfoRow('Created', DateFormat('yyyy-MM-dd HH:mm').format(review.createdAt)),
                _InfoRow('Updated', DateFormat('yyyy-MM-dd HH:mm').format(review.updatedAt)),

                // Resolve Report Button (if pending)
                if (pendingReport != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: crudState.isResolvingReport
                          ? null
                          : () => _resolveReport(context, pendingReport.id),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Resolve Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],

                // Error
                if (crudState.isFailure)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      crudState.failure?.toString() ?? 'Error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          if (crudState.isLoading)
            const Opacity(
              opacity: 0.7,
              child: ModalBarrier(dismissible: false),
            ),
          if (crudState.isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildRatingChip(int rating) {
    Color color;
    if (rating >= 4) color = Colors.green;
    else if (rating >= 3) color = Colors.orange;
    else color = Colors.red;

    return Chip(
      label: Text('$rating ★'),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget _InfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleHide(String reviewId) async {
    final success = await ref
        .read(adminReviewCrudNotifierProvider.notifier)
        .toggleHideReview(reviewId);
    if (success && mounted) {
      setState(() {
        _review = _review?.copyWith(isHidden: !_review!.isHidden);
      });
    }
  }

  void _confirmDelete(BuildContext context, String reviewId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(adminReviewCrudNotifierProvider.notifier)
                  .deleteReview(reviewId);
              if (success && mounted) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _resolveReport(BuildContext context, String reportId) async {
    final success = await ref
        .read(adminReviewCrudNotifierProvider.notifier)
        .resolveReport(reportId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report resolved successfully')),
      );
      // Refresh the review and report list
      ref.read(adminReviewListNotifierProvider.notifier).refreshReports();
      ref.read(adminReviewListNotifierProvider.notifier).refreshReviews();
    }
  }
}