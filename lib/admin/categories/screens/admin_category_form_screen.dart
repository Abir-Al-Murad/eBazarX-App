import 'package:ebazarx/admin/categories/providers/admin_category_providers.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/upload/models/upload_image_item.dart';
import 'package:ebazarx/features/upload/presentation/widgets/reusable_image_uploader.dart';
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

class _AdminCategoryFormScreenState
    extends ConsumerState<AdminCategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _slugController;
  late final TextEditingController _descriptionController;

  String? _parentId;
  bool _isActive = true;

  // Image upload state
  List<UploadImageItem> _uploadedImages = [];

  @override
  void initState() {
    super.initState();

    final category = widget.category;

    _nameController = TextEditingController(text: category?.name ?? '');
    _slugController = TextEditingController(text: category?.slug ?? '');
    _descriptionController = TextEditingController(
      text: category?.description ?? '',
    );

    _parentId = category?.parentId;
    _isActive = category?.isActive ?? true;

    // Initialize uploaded images from existing imageUrl
    if (category?.imageUrl != null) {
      _uploadedImages = [
        UploadImageItem(
          url: category!.imageUrl!,
          isPrimary: true, order: 1,
        ),
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

  // ============================================================
  // VALID PARENT ID
  // ============================================================

  String? _getValidParentId(List<Category> categories) {
    if (_parentId == null) {
      return null;
    }

    final exists = categories.any((category) => category.id == _parentId);

    return exists ? _parentId : null;
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(adminCategoryCrudNotifierProvider.notifier);

    // Get image URL from uploaded images (if any)
    final imageUrl = _uploadedImages.isNotEmpty ? _uploadedImages.first.url : null;

    bool success;

    if (widget.isEdit) {
      success = await notifier.updateCategory(
        id: widget.category!.id,
        name: _nameController.text.trim(),
        slug: _slugController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        imageUrl: imageUrl,
        parentId: _parentId,
      );
    } else {
      success = await notifier.createCategory(
        name: _nameController.text.trim(),
        slug: _slugController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        imageUrl: imageUrl,
        parentId: _parentId,
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryListState = ref.watch(adminCategoryListNotifierProvider);
    final crudState = ref.watch(adminCategoryCrudNotifierProvider);

    final categories = categoryListState.categories;
    final validParentId = _getValidParentId(categories);
    final isSaving = crudState.isCreating || crudState.isUpdating;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Category' : 'Create Category'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ==================================================
            // IMAGE UPLOADER
            // ==================================================
            ReusableImageUploader(
              initialImages: _uploadedImages,
              maxImages: 1,
              onChanged: (images) {
                setState(() {
                  _uploadedImages = images;
                });
              },
            ),
            const SizedBox(height: 16),

            // ==================================================
            // NAME
            // ==================================================
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'Enter category name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Category name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ==================================================
            // SLUG
            // ==================================================
            TextFormField(
              controller: _slugController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Slug',
                hintText: 'example-category',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Slug is required';
                }
                final slugRegex = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
                if (!slugRegex.hasMatch(value.trim())) {
                  return 'Use lowercase letters, numbers and hyphens';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ==================================================
            // DESCRIPTION
            // ==================================================
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter category description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ==================================================
            // PARENT CATEGORY
            // ==================================================
            DropdownButtonFormField<String>(
              value: validParentId,
              decoration: const InputDecoration(
                labelText: 'Parent Category',
                border: OutlineInputBorder(),
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
                    .fold<Map<String, Category>>({}, (map, category) {
                  map[category.id] = category;
                  return map;
                })
                    .values
                    .where(
                      (category) =>
                  !widget.isEdit || category.id != widget.category!.id,
                )
                    .map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(
                      category.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ],
              onChanged: categoryListState.isLoading
                  ? null
                  : (value) {
                setState(() {
                  _parentId = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // ==================================================
            // ACTIVE
            // ==================================================
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active'),
              value: _isActive,
              onChanged: widget.isEdit
                  ? (value) {
                setState(() {
                  _isActive = value;
                });
              }
                  : null,
            ),
            const SizedBox(height: 24),

            // ==================================================
            // ERROR
            // ==================================================
            if (crudState.failure != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  crudState.failure!.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // ==================================================
            // SAVE BUTTON
            // ==================================================
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : _submit,
                child: isSaving
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(
                  widget.isEdit ? 'Update Category' : 'Create Category',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}