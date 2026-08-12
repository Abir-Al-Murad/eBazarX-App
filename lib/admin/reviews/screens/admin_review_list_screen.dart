// admin/reviews/presentation/screens/admin_review_list_screen.dart

import 'package:ebazarx/admin/reviews/notifiers/admin_review_list_notifier.dart';
import 'package:ebazarx/admin/reviews/providers/admin_review_providers.dart';
import 'package:ebazarx/admin/reviews/screens/admin_review_details_screen.dart';
import 'package:ebazarx/admin/reviews/states/admin_review_list_state.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_report_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminReviewListScreen extends ConsumerStatefulWidget {
  const AdminReviewListScreen({super.key});

  @override
  ConsumerState<AdminReviewListScreen> createState() =>
      _AdminReviewListScreenState();
}

class _AdminReviewListScreenState
    extends ConsumerState<AdminReviewListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ScrollController _reviewScrollController = ScrollController();
  final ScrollController _reportScrollController = ScrollController();

  // Filter state
  String? _productIdFilter;
  String? _userIdFilter;
  bool? _isHiddenFilter;
  bool? _includeDeletedFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _reviewScrollController.addListener(_onReviewScroll);
    _reportScrollController.addListener(_onReportScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(adminReviewListNotifierProvider.notifier);
      notifier.loadReviews();
      notifier.loadReports();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewScrollController.dispose();
    _reportScrollController.dispose();
    super.dispose();
  }

  void _onReviewScroll() {
    if (_reviewScrollController.position.pixels >=
        _reviewScrollController.position.maxScrollExtent - 200) {
      ref.read(adminReviewListNotifierProvider.notifier).loadMoreReviews();
    }
  }

  void _onReportScroll() {
    if (_reportScrollController.position.pixels >=
        _reportScrollController.position.maxScrollExtent - 200) {
      ref.read(adminReviewListNotifierProvider.notifier).loadMoreReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminReviewListNotifierProvider);
    final notifier = ref.read(adminReviewListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Reviews', icon: Icon(Icons.reviews)),
            Tab(text: 'Reports', icon: Icon(Icons.report)),
          ],
        ),
        actions: [
          if (_tabController.index == 0)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterDialog(context),
            ),
          if (_tabController.index == 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => notifier.refreshReviews(),
            ),
          if (_tabController.index == 1)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => notifier.refreshReports(),
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // REVIEWS TAB
          _buildReviewsTab(state, notifier),
          // REPORTS TAB
          _buildReportsTab(state, notifier),
        ],
      ),
    );
  }

  // ============================================================
  // REVIEWS TAB
  // ============================================================

  Widget _buildReviewsTab(
      AdminReviewListState state,
      AdminReviewListNotifier notifier,
      ) {
    if (state.isLoadingReviews && state.reviews.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.reviews.isEmpty) {
      return const Center(child: Text('No reviews found'));
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refreshReviews(),
      child: ListView.builder(
        controller: _reviewScrollController,
        itemCount: state.reviews.length + (state.hasMoreReviews ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.reviews.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final review = state.reviews[index];
          return _ReviewTile(
            review: review,
            onTap: () => _navigateToDetail(context, review.id),
          );
        },
      ),
    );
  }

  // ============================================================
  // REPORTS TAB
  // ============================================================

  Widget _buildReportsTab(
      AdminReviewListState state,
      AdminReviewListNotifier notifier,
      ) {
    if (state.isLoadingReports && state.reports.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.reports.isEmpty) {
      return const Center(child: Text('No pending reports'));
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refreshReports(),
      child: ListView.builder(
        controller: _reportScrollController,
        itemCount: state.reports.length + (state.hasMoreReports ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.reports.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final report = state.reports[index];
          return _ReportTile(
            report: report,
            onTap: () => _navigateToDetail(context, report.reviewId),
          );
        },
      ),
    );
  }

  // ============================================================
  // FILTER DIALOG
  // ============================================================

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filter Reviews'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Product ID'),
              onChanged: (v) => _productIdFilter = v.isNotEmpty ? v : null,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'User ID'),
              onChanged: (v) => _userIdFilter = v.isNotEmpty ? v : null,
            ),
            SwitchListTile(
              title: const Text('Hidden'),
              value: _isHiddenFilter ?? false,
              onChanged: (v) => _isHiddenFilter = v,
            ),
            SwitchListTile(
              title: const Text('Include Deleted'),
              value: _includeDeletedFilter ?? false,
              onChanged: (v) => _includeDeletedFilter = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              final notifier =
              ref.read(adminReviewListNotifierProvider.notifier);
              notifier.applyFilters(
                productId: _productIdFilter,
                userId: _userIdFilter,
                isHidden: _isHiddenFilter,
                includeDeleted: _includeDeletedFilter,
              );
            },
            child: const Text('Apply'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetFilters();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _productIdFilter = null;
      _userIdFilter = null;
      _isHiddenFilter = null;
      _includeDeletedFilter = null;
    });
    ref.read(adminReviewListNotifierProvider.notifier).resetFilters();
  }

  void _navigateToDetail(BuildContext context, String reviewId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminReviewDetailScreen(reviewId: reviewId),
      ),
    ).then((_) {
      // Refresh lists when returning
      final notifier = ref.read(adminReviewListNotifierProvider.notifier);
      notifier.refreshReviews();
      notifier.refreshReports();
    });
  }
}

// ============================================================
// REVIEW TILE
// ============================================================

class _ReviewTile extends StatelessWidget {
  final ReviewEntity review;
  final VoidCallback onTap;

  const _ReviewTile({required this.review, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(review.rating.toString()),
          backgroundColor: _getRatingColor(review.rating),
        ),
        title: Text('Product: ${review.productId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${review.userId}'),
            if (review.comment != null)
              Text(
                review.comment!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Row(
              children: [
                if (review.isHidden)
                  const Chip(
                    label: Text('Hidden'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                if (review.isVerified)
                  const Chip(
                    label: Text('Verified'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                Text(
                  DateFormat('yyyy-MM-dd').format(review.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.thumb_up,
              color: Colors.grey,
              size: 16,
            ),
            Text(' ${review.likes}'),
            const SizedBox(width: 8),
            Icon(
              Icons.thumb_down,
              color: Colors.grey,
              size: 16,
            ),
            Text(' ${review.dislikes}'),
          ],
        ),
        onTap: onTap,
        isThreeLine: true,
      ),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return Colors.green;
    if (rating >= 3) return Colors.orange;
    return Colors.red;
  }
}

// ============================================================
// REPORT TILE
// ============================================================

class _ReportTile extends StatelessWidget {
  final ReviewReportEntity report;
  final VoidCallback onTap;

  const _ReportTile({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.report, color: Colors.red),
        title: Text('Review: ${report.reviewId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reason: ${report.reason}'),
            if (report.description != null)
              Text(
                report.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              'Reported: ${DateFormat('yyyy-MM-dd').format(report.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: report.resolved
            ? const Chip(label: Text('Resolved'), backgroundColor: Colors.green)
            : const Chip(
          label: Text('Pending'),
          backgroundColor: Colors.orange,
        ),
        onTap: onTap,
        isThreeLine: true,
      ),
    );
  }
}