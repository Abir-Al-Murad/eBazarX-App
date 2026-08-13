// admin/categories/screens/admin_category_list_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/admin/categories/notifiers/admin_category_list_notifier.dart';
import 'package:ebazarx/admin/categories/providers/admin_category_providers.dart';
import 'package:ebazarx/admin/categories/screens/admin_category_form_screen.dart';
import 'package:ebazarx/admin/categories/states/admin_category_list_state.dart';
import 'package:ebazarx/common/widgets/confirm_dialog.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/common/widgets/page_loading_container.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminCategoryListScreen extends ConsumerStatefulWidget {
  const AdminCategoryListScreen({super.key});

  @override
  ConsumerState<AdminCategoryListScreen> createState() =>
      _AdminCategoryListScreenState();
}

class _AdminCategoryListScreenState extends ConsumerState<AdminCategoryListScreen> {
  final ScrollController _scrollController = ScrollController();

  String? _nameFilter;
  String? _slugFilter;
  String? _parentIdFilter;
  bool? _isActiveFilter;
  bool _includeDeleted = false;

  bool get _hasActiveFilters =>
      _nameFilter != null ||
          _slugFilter != null ||
          _parentIdFilter != null ||
          _isActiveFilter != null ||
          _includeDeleted;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminCategoryListNotifierProvider.notifier).loadCategories();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminCategoryListNotifierProvider.notifier).loadMore();
    }
  }

  void _navigateToForm({Category? category}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminCategoryFormScreen(category: category)),
    ).then((_) {
      ref.read(adminCategoryListNotifierProvider.notifier).refresh();
    });
  }

  Future<void> _confirmDelete(String categoryId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDialog(
        title: 'Delete Category',
        message: 'Are you sure you want to delete this category? This action cannot be undone.',
        confirmLabel: 'Delete',
      ),
    );
    if (confirmed != true) return;

    final listNotifier = ref.read(adminCategoryListNotifierProvider.notifier);
    final crudNotifier = ref.read(adminCategoryCrudNotifierProvider.notifier);
    final success = await crudNotifier.deleteCategory(categoryId);

    if (!mounted) return;
    if (success) {
      listNotifier.refresh();
      AppSnackBar.success(context: context, 'Category deleted');
    } else {
      AppSnackBar.error(context: context, 'Failed to delete category');
    }
  }

  void _applyFilters() {
    ref.read(adminCategoryListNotifierProvider.notifier).applyFilters(
      name: _nameFilter,
      slug: _slugFilter,
      parentId: _parentIdFilter,
      isActive: _isActiveFilter,
      includeDeleted: _includeDeleted,
    );
  }

  void _clearFilters() {
    setState(() {
      _nameFilter = null;
      _slugFilter = null;
      _parentIdFilter = null;
      _isActiveFilter = null;
      _includeDeleted = false;
    });
    ref.read(adminCategoryListNotifierProvider.notifier).clearFilters();
  }

  Future<void> _showFilterDialog() async {
    // Local temp state so "Cancel" (tap outside / back) doesn't mutate
    // the real filters before "Apply" is pressed.
    String? name = _nameFilter;
    String? slug = _slugFilter;
    String? parentId = _parentIdFilter;
    bool? isActive = _isActiveFilter;
    bool includeDeleted = _includeDeleted;

    final theme = Theme.of(context);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radiusLarge),
          ),
          title: const Text('Filter Categories'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (v) => name = v.isNotEmpty ? v : null,
                ),
                SizedBox(height: context.paddingSizeSmall),
                TextFormField(
                  initialValue: slug,
                  decoration: const InputDecoration(labelText: 'Slug'),
                  onChanged: (v) => slug = v.isNotEmpty ? v : null,
                ),
                SizedBox(height: context.paddingSizeSmall),
                TextFormField(
                  initialValue: parentId,
                  decoration: const InputDecoration(labelText: 'Parent ID'),
                  onChanged: (v) => parentId = v.isNotEmpty ? v : null,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Active only'),
                  value: isActive ?? false,
                  onChanged: (v) => setDialogState(() => isActive = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Include deleted'),
                  value: includeDeleted,
                  onChanged: (v) => setDialogState(() => includeDeleted = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _nameFilter = name;
                  _slugFilter = slug;
                  _parentIdFilter = parentId;
                  _isActiveFilter = isActive;
                  _includeDeleted = includeDeleted;
                });
                Navigator.pop(ctx);
                _applyFilters();
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
    final listState = ref.watch(adminCategoryListNotifierProvider);
    final listNotifier = ref.read(adminCategoryListNotifierProvider.notifier);

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
                      title: 'Category Management',
                      subtitle: 'Organize how products are grouped and browsed',
                    ),
                  ),
                  SizedBox(width: context.paddingSizeSmall),
                  _HeaderIconButton(
                    icon: Icons.filter_list_rounded,
                    tooltip: 'Filters',
                    highlighted: _hasActiveFilters,
                    onTap: _showFilterDialog,
                  ),
                  SizedBox(width: context.paddingSizeSmall),
                  FilledButton.icon(
                    onPressed: () => _navigateToForm(),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Category'),
                  ),
                ],
              ),
              SizedBox(height: context.paddingSizeDefault),
              if (_hasActiveFilters) ...[
                _FilterChipsRow(
                  nameFilter: _nameFilter,
                  slugFilter: _slugFilter,
                  parentIdFilter: _parentIdFilter,
                  isActiveFilter: _isActiveFilter,
                  includeDeleted: _includeDeleted,
                  onRemoveName: () {
                    setState(() => _nameFilter = null);
                    _applyFilters();
                  },
                  onRemoveSlug: () {
                    setState(() => _slugFilter = null);
                    _applyFilters();
                  },
                  onRemoveParentId: () {
                    setState(() => _parentIdFilter = null);
                    _applyFilters();
                  },
                  onRemoveIsActive: () {
                    setState(() => _isActiveFilter = null);
                    _applyFilters();
                  },
                  onRemoveIncludeDeleted: () {
                    setState(() => _includeDeleted = false);
                    _applyFilters();
                  },
                  onClearAll: _clearFilters,
                ),
                SizedBox(height: context.paddingSizeDefault),
              ],
              Expanded(
                child: _CategoryBody(
                  state: listState,
                  notifier: listNotifier,
                  scrollController: _scrollController,
                  onEdit: (category) => _navigateToForm(category: category),
                  onDelete: (category) => _confirmDelete(category.id),
                  onAdd: () => _navigateToForm(),
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
// Header icon button (filter trigger, with active-state dot)
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
          child: IconButton(
            icon: Icon(icon, size: 20),
            tooltip: tooltip,
            onPressed: onTap,
          ),
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
// Filter chips row
// ================================
class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({
    required this.nameFilter,
    required this.slugFilter,
    required this.parentIdFilter,
    required this.isActiveFilter,
    required this.includeDeleted,
    required this.onRemoveName,
    required this.onRemoveSlug,
    required this.onRemoveParentId,
    required this.onRemoveIsActive,
    required this.onRemoveIncludeDeleted,
    required this.onClearAll,
  });

  final String? nameFilter;
  final String? slugFilter;
  final String? parentIdFilter;
  final bool? isActiveFilter;
  final bool includeDeleted;
  final VoidCallback onRemoveName;
  final VoidCallback onRemoveSlug;
  final VoidCallback onRemoveParentId;
  final VoidCallback onRemoveIsActive;
  final VoidCallback onRemoveIncludeDeleted;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: context.paddingSizeExtraSmall,
      runSpacing: context.paddingSizeExtraSmall,
      children: [
        if (nameFilter != null)
          _FilterChip(label: 'Name: $nameFilter', onRemove: onRemoveName),
        if (slugFilter != null)
          _FilterChip(label: 'Slug: $slugFilter', onRemove: onRemoveSlug),
        if (parentIdFilter != null)
          _FilterChip(label: 'Parent: $parentIdFilter', onRemove: onRemoveParentId),
        if (isActiveFilter != null)
          _FilterChip(
            label: isActiveFilter! ? 'Active' : 'Inactive',
            onRemove: onRemoveIsActive,
          ),
        if (includeDeleted)
          _FilterChip(label: 'Include deleted', onRemove: onRemoveIncludeDeleted),
        ActionChip(
          label: Text('Clear all', style: TextStyle(color: theme.colorScheme.error)),
          onPressed: onClearAll,
          backgroundColor: theme.colorScheme.error.withValues(alpha: 0.08),
          side: BorderSide.none,
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InputChip(
      label: Text(label, style: TextStyle(fontSize: context.fontSizeSmall)),
      onDeleted: onRemove,
      deleteIconColor: theme.colorScheme.onSurfaceVariant,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
      side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
    );
  }
}

// ================================
// Body: loading / empty / responsive content
// ================================
class _CategoryBody extends StatelessWidget {
  const _CategoryBody({
    required this.state,
    required this.notifier,
    required this.scrollController,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
  });

  final AdminCategoryListState state;
  final AdminCategoryListNotifier notifier;
  final ScrollController scrollController;
  final ValueChanged<Category> onEdit;
  final ValueChanged<Category> onDelete;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.categories.isEmpty) {
      return const LoadingContainer();
    }

    if (state.categories.isEmpty) {
      return EmptyState(
        icon: Icons.category_outlined,
        title: 'No categories found',
        message: 'Create a category to start organizing your product catalog.',
        buttonText: 'Add Category',
        buttonIcon: Icons.add_rounded,
        onPressed: onAdd,
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: context.isDesktop
          ? _DesktopCategoryTable(
        categories: state.categories,
        hasMore: state.hasMore,
        scrollController: scrollController,
        onEdit: onEdit,
        onDelete: onDelete,
      )
          : _CategoryGrid(
        categories: state.categories,
        hasMore: state.hasMore,
        scrollController: scrollController,
        crossAxisCount: context.isTablet ? 2 : 1,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}

// ================================
// Desktop table
// ================================
class _DesktopCategoryTable extends StatelessWidget {
  const _DesktopCategoryTable({
    required this.categories,
    required this.hasMore,
    required this.scrollController,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Category> categories;
  final bool hasMore;
  final ScrollController scrollController;
  final ValueChanged<Category> onEdit;
  final ValueChanged<Category> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(context.radiusLarge),
          border: Border.all(color: theme.dividerColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 24,
                headingRowHeight: 46,
                dataRowMinHeight: 60,
                dataRowMaxHeight: 60,
                headingRowColor: WidgetStateProperty.all(
                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ),
                headingTextStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                dividerThickness: 0.6,
                columns: const [
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Slug')),
                  DataColumn(label: Text('Parent')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('')),
                ],
                rows: categories.map((category) {
                  return DataRow(
                    cells: [
                      DataCell(_CategoryNameCell(category: category)),
                      DataCell(Text(category.slug)),
                      DataCell(Text(category.parentId ?? '—')),
                      DataCell(
                        StatusChip(
                          status: category.isActive ? 'Active' : 'Inactive',
                          showDot: false,
                        ),
                      ),
                      DataCell(_CategoryActionsMenu(
                        category: category,
                        onEdit: () => onEdit(category),
                        onDelete: () => onDelete(category),
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
            if (hasMore)
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryNameCell extends StatelessWidget {
  const _CategoryNameCell({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.radiusSmall),
          child: category.imageUrl != null
              ? CachedNetworkImage(
            imageUrl: category.imageUrl!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 40,
              height: 40,
              color: theme.dividerColor.withValues(alpha: 0.2),
            ),
            errorWidget: (_, __, ___) => _CategoryFallbackIcon(theme: theme),
          )
              : _CategoryFallbackIcon(theme: theme),
        ),
        SizedBox(width: context.paddingSizeSmall),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _CategoryFallbackIcon extends StatelessWidget {
  const _CategoryFallbackIcon({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      color: theme.dividerColor.withValues(alpha: 0.2),
      child: Icon(Icons.category_outlined, size: 18, color: theme.colorScheme.onSurfaceVariant),
    );
  }
}

// ================================
// Grid / list (mobile 1 col, tablet 2 col)
// ================================
class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.categories,
    required this.hasMore,
    required this.scrollController,
    required this.crossAxisCount,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Category> categories;
  final bool hasMore;
  final ScrollController scrollController;
  final int crossAxisCount;
  final ValueChanged<Category> onEdit;
  final ValueChanged<Category> onDelete;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
          sliver: crossAxisCount == 1
              ? SliverList.separated(
            itemCount: categories.length,
            separatorBuilder: (_, __) => SizedBox(height: context.paddingSizeSmall),
            itemBuilder: (context, index) => _CategoryCard(
              category: categories[index],
              onEdit: () => onEdit(categories[index]),
              onDelete: () => onDelete(categories[index]),
            ),
          )
              : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 3.4,
              crossAxisSpacing: context.paddingSizeDefault,
              mainAxisSpacing: context.paddingSizeDefault,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _CategoryCard(
                category: categories[index],
                onEdit: () => onEdit(categories[index]),
                onDelete: () => onDelete(categories[index]),
              ),
              childCount: categories.length,
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

// ================================
// Category card (mobile / tablet)
// ================================
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
        onTap: onEdit,
        child: Padding(
          padding: EdgeInsets.all(context.paddingSizeSmall),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.radiusDefault),
                child: category.imageUrl != null
                    ? CachedNetworkImage(
                  imageUrl: category.imageUrl!,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 52,
                    height: 52,
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                  errorWidget: (_, __, ___) => _CategoryFallbackIcon(theme: theme),
                )
                    : SizedBox(
                  width: 52,
                  height: 52,
                  child: _CategoryFallbackIcon(theme: theme),
                ),
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
                            category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: context.fontSizeDefault,
                            ),
                          ),
                        ),
                        StatusChip(
                          status: category.isActive ? 'Active' : 'Inactive',
                          showDot: false,
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      category.slug,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _CategoryActionsMenu(
                category: category,
                onEdit: onEdit,
                onDelete: onDelete,
                compact: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================
// Actions menu (shared by table + card)
// ================================
class _CategoryActionsMenu extends StatelessWidget {
  const _CategoryActionsMenu({
    required this.category,
    required this.onEdit,
    required this.onDelete,
    this.compact = false,
  });

  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, size: compact ? 20 : 22),
      padding: EdgeInsets.zero,
      tooltip: 'Actions',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radiusDefault),
      ),
      onSelected: (value) {
        if (value == 'edit') onEdit();
        if (value == 'delete') onDelete();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline_rounded, color: AppColors.error),
            title: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ),
      ],
    );
  }
}