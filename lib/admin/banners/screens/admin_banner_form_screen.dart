// admin/banners/screens/admin_banner_form_screen.dart
import 'package:ebazarx/admin/banners/notifiers/admin_banner_notifier.dart';
import 'package:ebazarx/admin/banners/providers/admin_banner_provider.dart';
import 'package:ebazarx/admin/banners/states/admin_banner_state.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/banner/domain/entities/banner.dart';
import 'package:ebazarx/features/upload/models/upload_image_item.dart';
import 'package:ebazarx/features/upload/presentation/widgets/reusable_image_uploader.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdminBannerFormScreen extends ConsumerStatefulWidget {
  final BannerEntity? banner;

  const AdminBannerFormScreen({super.key, this.banner});

  @override
  ConsumerState<AdminBannerFormScreen> createState() =>
      _AdminBannerFormScreenState();
}

class _AdminBannerFormScreenState extends ConsumerState<AdminBannerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _linkUrlController;
  late final TextEditingController _productIdController;
  late final TextEditingController _categoryIdController;
  late final TextEditingController _positionController;

  bool _isActive = true;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    final banner = widget.banner;
    _titleController = TextEditingController(text: banner?.title ?? '');
    _descriptionController = TextEditingController(text: banner?.description ?? '');
    _linkUrlController = TextEditingController(text: banner?.linkUrl ?? '');
    _productIdController = TextEditingController(text: banner?.productId ?? '');
    _categoryIdController = TextEditingController(text: banner?.categoryId ?? '');
    _positionController = TextEditingController(text: (banner?.position ?? 0).toString());
    _isActive = banner?.isActive ?? true;
    _startDate = banner?.startDate;
    _endDate = banner?.endDate;
    _imageUrl = banner?.imageUrl;
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

  bool get _isEditing => widget.banner != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bannerState = ref.watch(adminBannerNotifierProvider);
    final notifier = ref.read(adminBannerNotifierProvider.notifier);

    ref.listen<AdminBannerState>(adminBannerNotifierProvider, (prev, next) {
      if (!mounted) return;

      final createFinished =
          prev?.isCreating == true && !next.isCreating && next.failure == null;
      final updateFinished =
          prev?.isUpdating == true && !next.isUpdating && next.failure == null;

      if (createFinished || updateFinished) {
        _onSuccess();
        return;
      }

      if (next.failure != null) {
        AppSnackBar.error(context: context, next.failure!.message);
        notifier.clearFailure();
      }
    });

    final isLoading = _isEditing ? bannerState.isUpdating : bannerState.isCreating;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: context.isDesktop
          ? null
          : AppBar(title: Text(_isEditing ? 'Edit Banner' : 'Create Banner')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.paddingSizeLarge),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (context.isDesktop) ...[
                            DesktopHeader(
                              title: _isEditing ? 'Edit Banner' : 'Create Banner',
                              subtitle: _isEditing
                                  ? 'Update this promotional banner'
                                  : 'Add a new promotional banner to the home screen',
                            ),
                            SizedBox(height: context.paddingSizeExtraLarge),
                          ],
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 700;
                              final imageSection = _ImageSection(
                                imageUrl: _imageUrl,
                                initialBanner: widget.banner,
                                onChanged: (images) {
                                  setState(() {
                                    _imageUrl = images.isNotEmpty ? images.first.url : null;
                                  });
                                },
                              );
                              final detailsSection = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _BasicInfoSection(
                                    titleController: _titleController,
                                    descriptionController: _descriptionController,
                                  ),
                                  SizedBox(height: context.paddingSizeDefault),
                                  _TargetingSection(
                                    linkUrlController: _linkUrlController,
                                    productIdController: _productIdController,
                                    categoryIdController: _categoryIdController,
                                    positionController: _positionController,
                                  ),
                                  SizedBox(height: context.paddingSizeDefault),
                                  _ScheduleSection(
                                    isActive: _isActive,
                                    startDate: _startDate,
                                    endDate: _endDate,
                                    onActiveChanged: (v) => setState(() => _isActive = v),
                                    onSelectDate: _selectDate,
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
              _SubmitBar(
                isEditing: _isEditing,
                isLoading: isLoading,
                onSubmit: () {
                  if (_formKey.currentState!.validate()) {
                    _submit(notifier);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submit(AdminBannerNotifier notifier) {
    if (_imageUrl == null || _imageUrl!.isEmpty) {
      AppSnackBar.info(context: context, 'Please upload a banner image.');
      return;
    }

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final linkUrl = _linkUrlController.text.trim();
    final productId = _productIdController.text.trim();
    final categoryId = _categoryIdController.text.trim();
    final position = int.parse(_positionController.text.trim());

    if (_isEditing) {
      notifier.updateBanner(
        id: widget.banner!.id,
        title: title,
        description: description,
        imageUrl: _imageUrl!,
        linkUrl: linkUrl.isEmpty ? null : linkUrl,
        productId: productId.isEmpty ? null : productId,
        categoryId: categoryId.isEmpty ? null : categoryId,
        position: position,
        isActive: _isActive,
        startDate: _startDate,
        endDate: _endDate,
      );
    } else {
      notifier.createBanner(
        title: title,
        description: description,
        imageUrl: _imageUrl!,
        linkUrl: linkUrl.isEmpty ? null : linkUrl,
        productId: productId.isEmpty ? null : productId,
        categoryId: categoryId.isEmpty ? null : categoryId,
        position: position,
        isActive: _isActive,
        startDate: _startDate,
        endDate: _endDate,
      );
    }
  }

  void _onSuccess() {
    ref.read(adminBannerListNotifierProvider.notifier).refresh();
    AppSnackBar.success(
      context: context,
      _isEditing ? 'Banner updated' : 'Banner created',
    );
    context.pop();
  }
}

// ================================
// Shared section card wrapper
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
// Basic Info
// ================================
class _BasicInfoSection extends StatelessWidget {
  const _BasicInfoSection({
    required this.titleController,
    required this.descriptionController,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return _FormSectionCard(
      title: 'Basic Information',
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title *'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
          ),
          SizedBox(height: context.paddingSizeDefault),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

// ================================
// Image
// ================================
class _ImageSection extends StatelessWidget {
  const _ImageSection({
    required this.imageUrl,
    required this.initialBanner,
    required this.onChanged,
  });

  final String? imageUrl;
  final BannerEntity? initialBanner;
  final ValueChanged<List<UploadImageItem>> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _FormSectionCard(
      title: 'Banner Image',
      subtitle: 'Recommended: wide aspect ratio, under 2MB',
      child: Column(
        children: [
          ReusableImageUploader(
            initialImages: initialBanner != null
                ? [
              UploadImageItem(
                url: initialBanner!.imageUrl,
                order: 0,
                isPrimary: true,
              ),
            ]
                : [],
            maxImages: 1,
            onChanged: onChanged,
          ),
          if (imageUrl != null && imageUrl!.isNotEmpty) ...[
            SizedBox(height: context.paddingSizeDefault),
            Text(
              'Preview',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: context.paddingSizeSmall),
            ClipRRect(
              borderRadius: BorderRadius.circular(context.radiusDefault),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ================================
// Targeting / Links
// ================================
class _TargetingSection extends StatelessWidget {
  const _TargetingSection({
    required this.linkUrlController,
    required this.productIdController,
    required this.categoryIdController,
    required this.positionController,
  });

  final TextEditingController linkUrlController;
  final TextEditingController productIdController;
  final TextEditingController categoryIdController;
  final TextEditingController positionController;

  @override
  Widget build(BuildContext context) {
    return _FormSectionCard(
      title: 'Link & Targeting',
      subtitle: 'Where should tapping this banner take the customer?',
      child: Column(
        children: [
          TextFormField(
            controller: linkUrlController,
            decoration: const InputDecoration(labelText: 'Link URL (optional)'),
          ),
          SizedBox(height: context.paddingSizeDefault),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: productIdController,
                  decoration: const InputDecoration(labelText: 'Product ID (optional)'),
                ),
              ),
              SizedBox(width: context.paddingSizeDefault),
              Expanded(
                child: TextFormField(
                  controller: categoryIdController,
                  decoration: const InputDecoration(labelText: 'Category ID (optional)'),
                ),
              ),
            ],
          ),
          SizedBox(height: context.paddingSizeDefault),
          TextFormField(
            controller: positionController,
            decoration: const InputDecoration(
              labelText: 'Display Position *',
              helperText: 'Lower numbers appear first',
            ),
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (int.tryParse(v.trim()) == null) return 'Must be a number';
              return null;
            },
          ),
        ],
      ),
    );
  }
}

// ================================
// Schedule & Status
// ================================
class _ScheduleSection extends StatelessWidget {
  const _ScheduleSection({
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.onActiveChanged,
    required this.onSelectDate,
  });

  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<bool> onActiveChanged;
  final void Function(bool isStart) onSelectDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _FormSectionCard(
      title: 'Schedule & Status',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: 'Start Date',
                  date: startDate,
                  onTap: () => onSelectDate(true),
                ),
              ),
              SizedBox(width: context.paddingSizeDefault),
              Expanded(
                child: _DateField(
                  label: 'End Date',
                  date: endDate,
                  onTap: () => onSelectDate(false),
                ),
              ),
            ],
          ),
          SizedBox(height: context.paddingSizeSmall),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.paddingSizeSmall,
              vertical: context.paddingSizeExtraSmall,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(context.radiusDefault),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Active',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Switch(value: isActive, onChanged: onActiveChanged),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.date, required this.onTap});

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radiusDefault),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(
            Icons.calendar_today_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        child: Text(
          date != null ? DateFormat('dd MMM yyyy').format(date!) : 'Not set',
          style: date == null
              ? TextStyle(color: theme.colorScheme.onSurfaceVariant)
              : null,
        ),
      ),
    );
  }
}

// ================================
// Sticky Submit Bar
// ================================
class _SubmitBar extends StatelessWidget {
  const _SubmitBar({
    required this.isEditing,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isEditing;
  final bool isLoading;
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
          constraints: const BoxConstraints(maxWidth: 960),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: isLoading ? null : onSubmit,
              icon: isLoading
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : Icon(isEditing ? Icons.save_rounded : Icons.add_rounded, size: 20),
              label: Text(isLoading
                  ? (isEditing ? 'Updating...' : 'Creating...')
                  : (isEditing ? 'Update Banner' : 'Create Banner')),
            ),
          ),
        ),
      ),
    );
  }
}