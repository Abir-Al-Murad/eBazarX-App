// admin/categories/screens/admin_category_form_screen.dart
import 'package:ebazarx/admin/categories/providers/admin_category_providers.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/upload/models/upload_image_item.dart';
import 'package:ebazarx/features/upload/presentation/widgets/reusable_image_uploader.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminCategoryFormScreen extends ConsumerStatefulWidget {
  final Category? category;

  const AdminCategoryFormScreen({super.key, this.category});

  bool get isEdit => category != null;

  @override
  ConsumerState<AdminCategoryFormScreen> createState() =>
      _AdminCategoryFormScreenState();
}

class _AdminCategoryFormScreenState extends ConsumerState<AdminCategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _slugController;
  late final TextEditingController _descriptionController;

  String? _parentId;
  bool _isActive = true;
  List<UploadImageItem> _uploadedImages = [];

  @override
  void initState() {
    super.initState();

    final category = widget.category;
    _nameController = TextEditingController(text: category?.name ?? '');
    _slugController = TextEditingController(text: category?.slug ?? '');
    _descriptionController = TextEditingController(text: category?.description ?? '');
    _parentId = category?.parentId;
    _isActive = category?.isActive ?? true;

    if (category?.imageUrl != null) {
      _uploadedImages = [
        UploadImageItem(url: category!.imageUrl!, isPrimary: true, order: 1),
      ];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _getValidParentId(List<Category> categories) {
    if (_parentId == null) return null;
    final exists = categories.any((c) => c.id == _parentId);
    return exists ? _parentId : null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(adminCategoryCrudNotifierProvider.notifier);
    final imageUrl = _uploadedImages.isNotEmpty ? _uploadedImages.first.url : null;

    bool success;
    if (widget.isEdit) {
      success = await notifier.updateCategory(
        id: widget.category!.id,
        name: _nameController.text.trim(),
        slug: _slugController.text.trim(),
        description:
        _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        imageUrl: imageUrl,
        parentId: _parentId,
      );
    } else {
      success = await notifier.createCategory(
        name: _nameController.text.trim(),
        slug: _slugController.text.trim(),
        description:
        _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        imageUrl: imageUrl,
        parentId: _parentId,
      );
    }

    if (!mounted) return;

    if (success) {
      AppSnackBar.success(
        context: context,
        widget.isEdit ? 'Category updated' : 'Category created',
      );
      Navigator.pop(context, true);
    } else {
      final crudState = ref.read(adminCategoryCrudNotifierProvider);
      AppSnackBar.error(
        context: context,
        crudState.failure?.toString() ?? 'Failed to save category',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryListState = ref.watch(adminCategoryListNotifierProvider);
    final crudState = ref.watch(adminCategoryCrudNotifierProvider);

    final categories = categoryListState.categories;
    final validParentId = _getValidParentId(categories);
    final isSaving = crudState.isCreating || crudState.isUpdating;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: context.isDesktop
          ? null
          : AppBar(title: Text(widget.isEdit ? 'Edit Category' : 'Create Category')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.paddingSizeLarge),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (context.isDesktop) ...[
                          DesktopHeader(
                            title: widget.isEdit ? 'Edit Category' : 'Create Category',
                            subtitle: widget.isEdit
                                ? 'Update this category\'s details'
                                : 'Add a new category to organize your catalog',
                          ),
                          SizedBox(height: context.paddingSizeExtraLarge),
                        ],
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 650;

                            final imageSection = _FormSectionCard(
                              title: 'Category Image',
                              subtitle: 'A square image works best',
                              child: ReusableImageUploader(
                                initialImages: _uploadedImages,
                                maxImages: 1,
                                onChanged: (images) => setState(() => _uploadedImages = images),
                              ),
                            );

                            final detailsSection = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FormSectionCard(
                                  title: 'Basic Information',
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _nameController,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                          labelText: 'Category Name *',
                                          hintText: 'Enter category name',
                                        ),
                                        validator: (v) => (v == null || v.trim().isEmpty)
                                            ? 'Category name is required'
                                            : null,
                                      ),
                                      SizedBox(height: context.paddingSizeDefault),
                                      TextFormField(
                                        controller: _slugController,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                          labelText: 'Slug *',
                                          hintText: 'example-category',
                                        ),
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return 'Slug is required';
                                          }
                                          final slugRegex = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
                                          if (!slugRegex.hasMatch(v.trim())) {
                                            return 'Use lowercase letters, numbers and hyphens';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: context.paddingSizeDefault),
                                      TextFormField(
                                        controller: _descriptionController,
                                        maxLines: 4,
                                        decoration: const InputDecoration(
                                          labelText: 'Description',
                                          hintText: 'Enter category description',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: context.paddingSizeDefault),
                                _FormSectionCard(
                                  title: 'Hierarchy & Status',
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      DropdownButtonFormField<String>(
                                        initialValue: validParentId,
                                        decoration: const InputDecoration(
                                          labelText: 'Parent Category',
                                        ),
                                        hint: categoryListState.isLoading
                                            ? const Text('Loading categories...')
                                            : const Text('Select parent category'),
                                        isExpanded: true,
                                        items: [
                                          const DropdownMenuItem<String>(
                                            value: null,
                                            child: Text('No Parent'),
                                          ),
                                          ...categories
                                              .fold<Map<String, Category>>({}, (map, c) {
                                            map[c.id] = c;
                                            return map;
                                          })
                                              .values
                                              .where((c) => !widget.isEdit || c.id != widget.category!.id)
                                              .map(
                                                (c) => DropdownMenuItem<String>(
                                              value: c.id,
                                              child: Text(c.name, overflow: TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ],
                                        onChanged: categoryListState.isLoading
                                            ? null
                                            : (value) => setState(() => _parentId = value),
                                      ),
                                      SizedBox(height: context.paddingSizeSmall),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.paddingSizeSmall,
                                          vertical: context.paddingSizeExtraSmall,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surfaceContainerHighest
                                              .withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.circular(context.radiusDefault),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Active',
                                                style: theme.textTheme.bodyMedium
                                                    ?.copyWith(fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Switch(
                                              value: _isActive,
                                              onChanged: widget.isEdit
                                                  ? (value) => setState(() => _isActive = value)
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!widget.isEdit) ...[
                                        SizedBox(height: 4),
                                        Text(
                                          'New categories start active by default.',
                                          style: theme.textTheme.labelSmall?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            );

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 3, child: detailsSection),
                                  SizedBox(width: context.paddingSizeDefault),
                                  Expanded(flex: 2, child: imageSection),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                imageSection,
                                SizedBox(height: context.paddingSizeDefault),
                                detailsSection,
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _SubmitBar(isEdit: widget.isEdit, isSaving: isSaving, onSubmit: _submit),
          ],
        ),
      ),
    );
  }
}

// ================================
// Shared section card wrapper (matches banner form)
// ================================
class _FormSectionCard extends StatelessWidget {
  const _FormSectionCard({required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.paddingSizeDefault),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: context.paddingSizeDefault),
          child,
        ],
      ),
    );
  }
}

// ================================
// Sticky submit bar (matches banner form)
// ================================
class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.isEdit, required this.isSaving, required this.onSubmit});

  final bool isEdit;
  final bool isSaving;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(context.paddingSizeDefault),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: isSaving ? null : onSubmit,
              icon: isSaving
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : Icon(isEdit ? Icons.save_rounded : Icons.add_rounded, size: 20),
              label: Text(
                isSaving
                    ? (isEdit ? 'Updating...' : 'Creating...')
                    : (isEdit ? 'Update Category' : 'Create Category'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}