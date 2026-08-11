import 'package:ebazarx/admin/banners/notifiers/admin_banner_notifier.dart';
import 'package:ebazarx/admin/banners/providers/admin_banner_provider.dart';
import 'package:ebazarx/admin/banners/states/admin_banner_state.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:ebazarx/features/upload/models/upload_image_item.dart';
import 'package:ebazarx/features/upload/presentation/widgets/reusable_image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminBannerFormScreen extends ConsumerStatefulWidget {
  final BannerEntity? banner;

  const AdminBannerFormScreen({super.key, this.banner});

  @override
  ConsumerState<AdminBannerFormScreen> createState() =>
      _AdminBannerFormScreenState();
}

class _AdminBannerFormScreenState
    extends ConsumerState<AdminBannerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _linkUrlController;
  late final TextEditingController _productIdController;
  late final TextEditingController _categoryIdController;
  late final TextEditingController _positionController;

  bool _isActive = true;
  DateTime? _startDate;
  DateTime? _endDate;

  // Image URL from uploader
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    final banner = widget.banner;
    _titleController = TextEditingController(text: banner?.title ?? '');
    _descriptionController =
        TextEditingController(text: banner?.description ?? '');
    _linkUrlController = TextEditingController(text: banner?.linkUrl ?? '');
    _productIdController =
        TextEditingController(text: banner?.productId ?? '');
    _categoryIdController =
        TextEditingController(text: banner?.categoryId ?? '');
    _positionController =
        TextEditingController(text: (banner?.position ?? 0).toString());
    _isActive = banner?.isActive ?? true;
    _startDate = banner?.startDate;
    _endDate = banner?.endDate;
    _imageUrl = banner?.imageUrl;

    // Clear uploader state when leaving (done in dispose)
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkUrlController.dispose();
    _productIdController.dispose();
    _categoryIdController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerState = ref.watch(adminBannerNotifierProvider);
    final notifier = ref.read(adminBannerNotifierProvider.notifier);

    ref.listen<AdminBannerState>(
      adminBannerNotifierProvider,
          (prev, next) {
        if (!mounted) return;

        final createFinished =
            prev?.isCreating == true &&
                !next.isCreating &&
                next.failure == null;

        final updateFinished =
            prev?.isUpdating == true &&
                !next.isUpdating &&
                next.failure == null;

        if (createFinished || updateFinished) {
          _onSuccess(context);
          return;
        }

        if (next.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${next.failure!.message}'),
              backgroundColor: Colors.red,
            ),
          );

          notifier.clearFailure();
        }
      },
    );

    final isEditing = widget.banner != null;
    final isLoading = isEditing
        ? bannerState.isUpdating
        : bannerState.isCreating;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Banner' : 'Create Banner'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return SingleChildScrollView(
                  child: isWide
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildFormFields(context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: _buildImagePreview(),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      _buildFormFields(context),
                      const SizedBox(height: 16),
                      _buildImagePreview(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
            if (_formKey.currentState!.validate()) {
              _submit(notifier);
            }
          },
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Text(isEditing ? 'Update Banner' : 'Create Banner'),
        ),
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title *'),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 3,
        ),
        // --- Replace image URL field with uploader ---
        const Text('Banner Image *', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ReusableImageUploader(
          initialImages: widget.banner != null
              ? [
            UploadImageItem(
              url: widget.banner!.imageUrl,
              order: 0,
              isPrimary: true,
            ),
          ]
              : [],
          maxImages: 1,
          onChanged: (images) {
            setState(() {
              _imageUrl = images.isNotEmpty ? images.first.url : null;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _linkUrlController,
          decoration: const InputDecoration(labelText: 'Link URL (optional)'),
        ),
        TextFormField(
          controller: _productIdController,
          decoration: const InputDecoration(labelText: 'Product ID (optional)'),
        ),
        TextFormField(
          controller: _categoryIdController,
          decoration: const InputDecoration(labelText: 'Category ID (optional)'),
        ),
        TextFormField(
          controller: _positionController,
          decoration: const InputDecoration(labelText: 'Position *'),
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Required';
            if (int.tryParse(v) == null) return 'Must be a number';
            return null;
          },
        ),
        Row(
          children: [
            const Text('Active:'),
            Switch(
              value: _isActive,
              onChanged: (val) => setState(() => _isActive = val),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, true),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Start Date'),
                  child: Text(_startDate != null
                      ? '${_startDate!.toLocal()}'.split(' ')[0]
                      : 'Not set'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, false),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'End Date'),
                  child: Text(_endDate != null
                      ? '${_endDate!.toLocal()}'.split(' ')[0]
                      : 'Not set'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    final url = _imageUrl;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('Image Preview',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            url != null && url.isNotEmpty
                ? Image.network(
              url,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 100),
            )
                : Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                  child: Text('Upload an image using the widget above')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  void _submit(AdminBannerNotifier notifier) {
    // Validate image is uploaded
    if (_imageUrl == null || _imageUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a banner image.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final Map<String, dynamic> params = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'imageUrl': _imageUrl!,
      'linkUrl': _linkUrlController.text.trim().isEmpty
          ? null
          : _linkUrlController.text.trim(),
      'productId': _productIdController.text.trim().isEmpty
          ? null
          : _productIdController.text.trim(),
      'categoryId': _categoryIdController.text.trim().isEmpty
          ? null
          : _categoryIdController.text.trim(),
      'position': int.parse(_positionController.text.trim()),
      'isActive': _isActive,
      'startDate': _startDate,
      'endDate': _endDate,
    };

    if (widget.banner != null) {
      notifier.updateBanner(
        id: widget.banner!.id,
        title: params['title']!,
        description: params['description'],
        imageUrl: params['imageUrl']!,
        linkUrl: params['linkUrl'],
        productId: params['productId'],
        categoryId: params['categoryId'],
        position: params['position'],
        isActive: params['isActive'],
        startDate: params['startDate'],
        endDate: params['endDate'],
      );
    } else {
      notifier.createBanner(
        title: params['title']!,
        description: params['description'],
        imageUrl: params['imageUrl']!,
        linkUrl: params['linkUrl'],
        productId: params['productId'],
        categoryId: params['categoryId'],
        position: params['position'],
        isActive: params['isActive'],
        startDate: params['startDate'],
        endDate: params['endDate'],
      );
    }
  }

  void _onSuccess(BuildContext context) {
    ref.read(adminBannerListNotifierProvider.notifier).refresh();
    context.pop();
  }
}