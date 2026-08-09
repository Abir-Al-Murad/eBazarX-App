import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/features/category/presentation/providers/category_providers.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/category/presentation/widgets/category_horizontal_list_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryHorizontalListView extends ConsumerStatefulWidget {
  const CategoryHorizontalListView({super.key});

  @override
  ConsumerState<CategoryHorizontalListView> createState() =>
      _CategoryHorizontalListViewState();
}

class _CategoryHorizontalListViewState
    extends ConsumerState<CategoryHorizontalListView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   ref.read(categoryListNotifierProvider.notifier).fetchCategories();
    // });

    _scrollController = ScrollController()..addListener(_handlePagination);
  }

  void _handlePagination() {
    final state = ref.read(categoryListNotifierProvider);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoading &&
        !state.isLoadingMore &&
        state.hasMore) {
      ref.read(categoryListNotifierProvider.notifier).loadMoreCategories();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handlePagination)
      ..dispose();

    super.dispose();
  }

  double get _height => context.isDesktop
      ? 200
      : context.isTablet
      ? 150
      : 100;

  double get _itemWidth => context.isDesktop
      ? 130.0
      : context.isTablet
      ? 100.0
      : 80.0;

  double get _avatarRadius => context.isDesktop
      ? 60.0
      : context.isTablet
      ? 45.0
      : 30.0;

  int get _errorPlaceholderCount => context.isDesktop
      ? 6
      : context.isTablet
      ? 5
      : 4;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryListNotifierProvider);
    final theme = Theme.of(context);

    // Initial loading — shimmer
    if (state.isLoading && state.categories.isEmpty) {
      return const CategoryHorizontalListShimmer();
    }

    // Initial load failed — no cached data to show
    if (state.failure != null && state.categories.isEmpty) {
      return _buildErrorList(theme, state.failure!.message);
    }

    // Empty state — fetch succeeded but no categories
    if (state.categories.isEmpty) {
      return SizedBox(
        height: _height,
        child: Center(
          child: Text(
            'No categories found',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: _height,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
        state.categories.length +
            (state.isLoadingMore || state.loadMoreFailure != null ? 1 : 0),
        itemBuilder: (context, index) {
          // Trailing item: load-more spinner or retry
          if (index == state.categories.length) {
            if (state.loadMoreFailure != null) {
              return SizedBox(
                width: _itemWidth,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: theme.colorScheme.error,
                    ),
                    tooltip: 'Retry',
                    onPressed: () => ref
                        .read(categoryListNotifierProvider.notifier)
                        .loadMoreCategories(),
                  ),
                ),
              );
            }
            return SizedBox(
              width: _itemWidth,
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          final category = state.categories[index];
          final hasImage =
              category.imageUrl != null && category.imageUrl!.isNotEmpty;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: _itemWidth,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: _avatarRadius-10,
                    backgroundColor: Colors.transparent,
                    child: hasImage
                        ? CachedNetworkImage(
                      imageUrl: category.imageUrl!,
                      width: _avatarRadius * 2,
                      height: _avatarRadius * 2,
                      fit: BoxFit.scaleDown,
                      placeholder: (context, url) => Container(
                        width: _avatarRadius * 2,
                        height: _avatarRadius * 2,
                        color: theme.dividerColor.withValues(alpha: 0.2),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: _avatarRadius * 2,
                        height: _avatarRadius * 2,
                        color: theme.dividerColor.withValues(alpha: 0.2),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.category,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    )
                        : Container(
                      width: _avatarRadius * 2,
                      height: _avatarRadius * 2,
                      color: theme.dividerColor.withValues(alpha: 0.2),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.category,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Renders the initial-load-failed state as a horizontal listview of
  /// retry-able circles instead of a centered block, so the section keeps
  /// the same shape/rhythm it has once categories actually load — no
  /// layout jump between states, and it's obvious *where* the failure is
  /// (right where the category avatars would normally sit).
  Widget _buildErrorList(ThemeData theme, String message) {
    return SizedBox(
      height: _height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _errorPlaceholderCount,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: _itemWidth,
                    child: Column(
                      children: [
                        InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => ref
                              .read(categoryListNotifierProvider.notifier)
                              .retry(),
                          child: Container(
                            width: _avatarRadius * 2,
                            height: _avatarRadius * 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                              theme.colorScheme.error.withValues(alpha: 0.08),
                              border: Border.all(
                                color: theme.colorScheme.error
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.refresh_rounded,
                              color: theme.colorScheme.error,
                              size: _avatarRadius * 0.7,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Retry',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}