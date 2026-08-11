// admin_category_list_screen.dart
import 'package:ebazarx/admin/categories/notifiers/admin_category_list_notifier.dart';
import 'package:ebazarx/admin/categories/providers/admin_category_providers.dart';
import 'package:ebazarx/admin/categories/screens/admin_category_form_screen.dart';
import 'package:ebazarx/admin/categories/states/admin_category_list_state.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminCategoryListScreen extends ConsumerStatefulWidget {
  const AdminCategoryListScreen({super.key});

  @override
  ConsumerState<AdminCategoryListScreen> createState() =>
      _AdminCategoryListScreenState();
}

class _AdminCategoryListScreenState
    extends ConsumerState<AdminCategoryListScreen> {
  final ScrollController _scrollController = ScrollController();

  // Filter state
  String? _nameFilter;
  String? _slugFilter;
  String? _parentIdFilter;
  bool? _isActiveFilter;
  bool _includeDeleted = false;

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
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminCategoryListNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(adminCategoryListNotifierProvider);
    final listNotifier = ref.read(adminCategoryListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToForm(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          if (_nameFilter != null ||
              _slugFilter != null ||
              _parentIdFilter != null ||
              _isActiveFilter != null ||
              _includeDeleted)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 6,
                children: [
                  if (_nameFilter != null)
                    Chip(
                      label: Text('Name: $_nameFilter'),
                      onDeleted: () => setState(() => _nameFilter = null),
                    ),
                  if (_slugFilter != null)
                    Chip(
                      label: Text('Slug: $_slugFilter'),
                      onDeleted: () => setState(() => _slugFilter = null),
                    ),
                  if (_parentIdFilter != null)
                    Chip(
                      label: Text('Parent ID: $_parentIdFilter'),
                      onDeleted: () => setState(() => _parentIdFilter = null),
                    ),
                  if (_isActiveFilter != null)
                    Chip(
                      label: Text(_isActiveFilter! ? 'Active' : 'Inactive'),
                      onDeleted: () => setState(() => _isActiveFilter = null),
                    ),
                  if (_includeDeleted)
                    Chip(
                      label: const Text('Include deleted'),
                      onDeleted: () => setState(() => _includeDeleted = false),
                    ),
                  Chip(
                    label: const Text('Clear all'),
                    onDeleted: _clearFilters,
                  ),
                ],
              ),
            ),

          // Content
          Expanded(
            child: listState.isLoading && listState.categories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : listState.categories.isEmpty
                ? const Center(child: Text('No categories found'))
                : RefreshIndicator(
              onRefresh: () => listNotifier.refresh(),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: listState.categories.length +
                    (listState.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == listState.categories.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final category = listState.categories[index];
                  return _CategoryTile(
                    category: category,
                    onEdit: () => _navigateToForm(context,
                        category: category),
                    onDelete: () => _confirmDelete(
                        context, category.id, listNotifier),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (v) => _nameFilter = v.isNotEmpty ? v : null,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Slug'),
              onChanged: (v) => _slugFilter = v.isNotEmpty ? v : null,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Parent ID'),
              onChanged: (v) => _parentIdFilter = v.isNotEmpty ? v : null,
            ),
            SwitchListTile(
              title: const Text('Active'),
              value: _isActiveFilter ?? false,
              onChanged: (v) => _isActiveFilter = v,
            ),
            SwitchListTile(
              title: const Text('Include deleted'),
              value: _includeDeleted,
              onChanged: (v) => _includeDeleted = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _applyFilters();
            },
            child: const Text('Apply'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _clearFilters();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    final notifier = ref.read(adminCategoryListNotifierProvider.notifier);
    notifier.applyFilters(
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

  void _navigateToForm(BuildContext context, {Category? category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminCategoryFormScreen(
          category: category,
        ),
      ),
    ).then((_) {
      // Refresh list when returning from form (e.g., after create/update/delete)
      ref.read(adminCategoryListNotifierProvider.notifier).refresh();
    });
  }

  void _confirmDelete(BuildContext context, String categoryId,
      AdminCategoryListNotifier listNotifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final crudNotifier =
              ref.read(adminCategoryCrudNotifierProvider.notifier);
              final success = await crudNotifier.deleteCategory(categoryId);
              if (success) {
                // Refresh the list after deletion
                listNotifier.refresh();
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to delete category')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryTile({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: category.imageUrl != null
          ? Image.network(
        category.imageUrl!,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image),
      )
          : const Icon(Icons.category),
      title: Text(category.name),
      subtitle: Text(category.slug),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
      isThreeLine: false,
      tileColor: category.isActive ? null : Colors.grey.shade100,
    );
  }
}