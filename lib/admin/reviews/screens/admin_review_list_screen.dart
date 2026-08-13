// admin/reviews/presentation/screens/admin_review_list_screen.dart
import 'package:ebazarx/admin/reviews/notifiers/admin_review_list_notifier.dart';
import 'package:ebazarx/admin/reviews/providers/admin_review_providers.dart';
import 'package:ebazarx/admin/reviews/screens/admin_review_details_screen.dart';
import 'package:ebazarx/admin/reviews/states/admin_review_list_state.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/common/widgets/page_loading_container.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_entity.dart';
import 'package:ebazarx/features/reviews/domain/entities/review_report_entity.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminReviewListScreen extends ConsumerStatefulWidget {
  const AdminReviewListScreen({super.key});

  @override
  ConsumerState<AdminReviewListScreen> createState() =>
      _AdminReviewListScreenState();
}

class _AdminReviewListScreenState extends ConsumerState<AdminReviewListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _reviewScrollController = ScrollController();
  final ScrollController _reportScrollController = ScrollController();

  String? _productIdFilter;
  String? _userIdFilter;
  bool? _isHiddenFilter;
  bool? _includeDeletedFilter;

  bool get _hasActiveFilters =>
      _productIdFilter != null ||
          _userIdFilter != null ||
          _isHiddenFilter != null ||
          (_includeDeletedFilter ?? false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));

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
    _reviewScrollController.removeListener(_onReviewScroll);
    _reviewScrollController.dispose();
    _reportScrollController.removeListener(_onReportScroll);
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

  void _navigateToDetail(String reviewId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminReviewDetailScreen(reviewId: reviewId)),
    ).then((_) {
      final notifier = ref.read(adminReviewListNotifierProvider.notifier);
      notifier.refreshReviews();
      notifier.refreshReports();
    });
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

  Future<void> _showFilterDialog() async {
    String? productId = _productIdFilter;
    String? userId = _userIdFilter;
    bool? isHidden = _isHiddenFilter;
    bool includeDeleted = _includeDeletedFilter ?? false;

    final theme = Theme.of(context);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radiusLarge),
          ),
          title: const Text('Filter Reviews'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: productId,
                  decoration: const InputDecoration(labelText: 'Product ID'),
                  onChanged: (v) => productId = v.isNotEmpty ? v : null,
                ),
                SizedBox(height: context.paddingSizeSmall),
                TextFormField(
                  initialValue: userId,
                  decoration: const InputDecoration(labelText: 'User ID'),
                  onChanged: (v) => userId = v.isNotEmpty ? v : null,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Hidden only'),
                  value: isHidden ?? false,
                  onChanged: (v) => setDialogState(() => isHidden = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Include Deleted'),
                  value: includeDeleted,
                  onChanged: (v) => setDialogState(() => includeDeleted = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _resetFilters();
              },
              child: const Text('Clear'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _productIdFilter = productId;
                  _userIdFilter = userId;
                  _isHiddenFilter = isHidden;
                  _includeDeletedFilter = includeDeleted;
                });
                Navigator.pop(ctx);
                ref.read(adminReviewListNotifierProvider.notifier).applyFilters(
                  productId: _productIdFilter,
                  userId: _userIdFilter,
                  isHidden: _isHiddenFilter,
                  includeDeleted: _includeDeletedFilter,
                );
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(adminReviewListNotifierProvider);
    final notifier = ref.read(adminReviewListNotifierProvider.notifier);
    final isReviewsTab = _tabController.index == 0;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.paddingSizeLarge,
            context.paddingSizeLarge,
            context.paddingSizeLarge,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: DesktopHeader(
                      title: 'Reviews',
                      subtitle: 'Moderate customer reviews and reported content',
                    ),
                  ),
                  if (isReviewsTab) ...[
                    SizedBox(width: context.paddingSizeSmall),
                    _HeaderIconButton(
                      icon: Icons.filter_list_rounded,
                      tooltip: 'Filters',
                      highlighted: _hasActiveFilters,
                      onTap: _showFilterDialog,
                    ),
                  ],
                  SizedBox(width: context.paddingSizeSmall),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Refresh',
                    onPressed: () =>
                    isReviewsTab ? notifier.refreshReviews() : notifier.refreshReports(),
                  ),
                ],
              ),
              SizedBox(height: context.paddingSizeExtraLarge),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(context.radiusLarge),
                  border: Border.all(color: theme.dividerColor),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.paddingSizeSmall,
                  vertical: context.paddingSizeExtraSmall,
                ),
                child: TabBar(
                  controller: _tabController,
                  tabAlignment: context.isDesktop ? TabAlignment.fill : TabAlignment.start,
                  isScrollable: !context.isDesktop,
                  splashBorderRadius: BorderRadius.circular(context.radiusLarge),
                  indicator: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(context.radiusLarge),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: theme.colorScheme.onPrimary,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  labelStyle: TextStyle(
                    fontSize: context.fontSizeSmall,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: context.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                  ),
                  labelPadding: EdgeInsets.symmetric(horizontal: context.paddingSizeDefault),
                  tabs: [
                    Tab(text: 'Reviews (${state.reviews.length})'),
                    Tab(text: 'Reports (${state.reports.length})'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    RefreshIndicator(
                      onRefresh: () => notifier.refreshReviews(),
                      child: _ReviewsTab(
                        isLoading: state.isLoadingReviews,
                        reviews: state.reviews,
                        hasMore: state.hasMoreReviews,
                        scrollController: _reviewScrollController,
                        onTap: (id) => _navigateToDetail(id),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () => notifier.refreshReports(),
                      child: _ReportsTab(
                        isLoading: state.isLoadingReports,
                        reports: state.reports,
                        hasMore: state.hasMoreReports,
                        scrollController: _reportScrollController,
                        onTap: (id) => _navigateToDetail(id),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================
// Header icon button (with active-filter dot, reused pattern from category screen)
// ================================
class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String tooltip;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(context.radiusDefault),
            border: Border.all(color: theme.dividerColor),
          ),
          child: IconButton(icon: Icon(icon, size: 20), tooltip: tooltip, onPressed: onTap),
        ),
        if (highlighted)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: theme.cardColor, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

// ================================
// REVIEWS TAB
// ================================
class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({
    required this.isLoading,
    required this.reviews,
    required this.hasMore,
    required this.scrollController,
    required this.onTap,
  });

  final bool isLoading;
  final List<ReviewEntity> reviews;
  final bool hasMore;
  final ScrollController scrollController;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading && reviews.isEmpty) {
      return const LoadingContainer();
    }

    if (reviews.isEmpty) {
      return const EmptyState(
        icon: Icons.reviews_outlined,
        title: 'No reviews found',
        message: 'Try adjusting your filters, or check back once customers leave reviews.',
      );
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
          sliver: SliverList.separated(
            itemCount: reviews.length,
            separatorBuilder: (_, __) => SizedBox(height: context.paddingSizeSmall),
            itemBuilder: (context, index) => _ReviewCard(
              review: reviews[index],
              onTap: () => onTap(reviews[index].id),
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

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.onTap});

  final ReviewEntity review;
  final VoidCallback onTap;

  Color _ratingColor() {
    if (review.rating >= 4) return AppColors.success;
    if (review.rating >= 3) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratingColor = _ratingColor();

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ratingColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 14, color: ratingColor),
                        Text(
                          '${review.rating}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: ratingColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.paddingSizeSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product: ${review.productId}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'User: ${review.userId}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(review.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (review.comment != null) ...[
                SizedBox(height: context.paddingSizeSmall),
                Text(
                  review.comment!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              SizedBox(height: context.paddingSizeSmall),
              Row(
                children: [
                  if (review.isHidden) ...[
                    const StatusChip(status: 'Hidden', showDot: false),
                    SizedBox(width: context.paddingSizeExtraSmall),
                  ],
                  if (review.isVerified) ...[
                    const StatusChip(status: 'Verified', showDot: false),
                    SizedBox(width: context.paddingSizeExtraSmall),
                  ],
                  const Spacer(),
                  Icon(Icons.thumb_up_outlined, size: 15, color: theme.colorScheme.onSurfaceVariant),
                  SizedBox(width: 3),
                  Text('${review.likes}', style: theme.textTheme.labelSmall),
                  SizedBox(width: context.paddingSizeSmall),
                  Icon(Icons.thumb_down_outlined, size: 15, color: theme.colorScheme.onSurfaceVariant),
                  SizedBox(width: 3),
                  Text('${review.dislikes}', style: theme.textTheme.labelSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================
// REPORTS TAB
// ================================
class _ReportsTab extends StatelessWidget {
  const _ReportsTab({
    required this.isLoading,
    required this.reports,
    required this.hasMore,
    required this.scrollController,
    required this.onTap,
  });

  final bool isLoading;
  final List<ReviewReportEntity> reports;
  final bool hasMore;
  final ScrollController scrollController;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading && reports.isEmpty) {
      return const LoadingContainer();
    }

    if (reports.isEmpty) {
      return const EmptyState(
        icon: Icons.flag_outlined,
        title: 'No pending reports',
        message: 'Reported reviews will show up here for moderation.',
      );
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
          sliver: SliverList.separated(
            itemCount: reports.length,
            separatorBuilder: (_, __) => SizedBox(height: context.paddingSizeSmall),
            itemBuilder: (context, index) => _ReportCard(
              report: reports[index],
              onTap: () => onTap(reports[index].reviewId),
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

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report, required this.onTap});

  final ReviewReportEntity report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.paddingSizeDefault),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(context.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.flag_rounded, size: 18, color: AppColors.error),
              ),
              SizedBox(width: context.paddingSizeSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Review: ${report.reviewId}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        StatusChip(
                          status: report.resolved ? 'Resolved' : 'Pending',
                          showDot: false,
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Reason: ${report.reason}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (report.description != null) ...[
                      SizedBox(height: 2),
                      Text(
                        report.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    SizedBox(height: context.paddingSizeExtraSmall),
                    Text(
                      'Reported: ${DateFormat('dd MMM yyyy').format(report.createdAt)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}