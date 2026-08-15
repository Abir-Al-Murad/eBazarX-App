// lib/features/profile/presentation/screens/apply_seller_screen.dart
import 'package:ebazarx/common/widgets/loading_state.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/profile/presentation/providers/profile_provider.dart';
import 'package:ebazarx/features/upload/presentation/widgets/single_image_upload_field.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ApplySellerScreen extends ConsumerStatefulWidget {
  const ApplySellerScreen({super.key});

  @override
  ConsumerState<ApplySellerScreen> createState() => _ApplySellerScreenState();
}

class _ApplySellerScreenState extends ConsumerState<ApplySellerScreen> {
  final _formKey = GlobalKey<FormState>();

  final _shopNameController = TextEditingController();
  final _shopSlugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _tradeLicenseController = TextEditingController();
  final _nidController = TextEditingController();
  final _tinController = TextEditingController();

  String _selectedCountry = 'Bangladesh';

  String? _logoUrl;
  String? _coverUrl;

  @override
  void dispose() {
    _shopNameController.dispose();
    _shopSlugController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _tradeLicenseController.dispose();
    _nidController.dispose();
    _tinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_logoUrl == null) {
      AppSnackBar.info(context: context, 'Please upload a shop logo');
      return;
    }

    final notifier = ref.read(applyNotifierProvider.notifier);
    await notifier.applyForSeller(
      shopName: _shopNameController.text.trim(),
      shopSlug: _shopSlugController.text.trim(),
      description:
      _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      logo: _logoUrl,
      coverImage: _coverUrl,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      district: _districtController.text.trim(),
      country: _selectedCountry,
      tradeLicense:
      _tradeLicenseController.text.trim().isEmpty ? null : _tradeLicenseController.text.trim(),
      nid: _nidController.text.trim().isEmpty ? null : _nidController.text.trim(),
      tin: _tinController.text.trim().isEmpty ? null : _tinController.text.trim(),
    );

    // if (!mounted) return;

    // final state = ref.read(applyNotifierProvider);
    // if (state.application != null && !state.isApplying) {
    //   _showSuccessDialog();
    // }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.radiusLarge)),
        icon: Container(
          padding: EdgeInsets.all(context.paddingSizeSmall),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle_rounded, color: AppColors.success, size: 32),
        ),
        title: const Text('Application Submitted', textAlign: TextAlign.center),
        content: const Text(
          'Your seller application has been submitted successfully. '
              'We will review it and get back to you soon.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyNotifierProvider);
    final theme = Theme.of(context);

    ref.listen(applyNotifierProvider, (previous, next) {
      // Started
      if (next.isApplying && !(previous?.isApplying ?? false)) {
        LoadingState.show(context);
      }

      // Finished
      if (!next.isApplying && (previous?.isApplying ?? false)) {
        LoadingState.hide();
      }

      // Failed
      if (next.failure != null &&
          next.failure != previous?.failure) {
        AppSnackBar.error(
          context: context,
          next.failure!.message,
        );
        return;
      }

      // Success
      if (next.application != null &&
          next.failure == null &&
          !next.isApplying &&
          (previous?.isApplying ?? false)) {
        _showSuccessDialog();
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('Apply as Seller')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.paddingSizeLarge),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us about your shop',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'This information helps customers find and trust your store.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: context.paddingSizeExtraLarge),

                    _FormSectionCard(
                      title: 'Shop Details',
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _shopNameController,
                            decoration: const InputDecoration(labelText: 'Shop Name *'),
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Shop name is required' : null,
                          ),
                          SizedBox(height: context.paddingSizeDefault),
                          TextFormField(
                            controller: _shopSlugController,
                            decoration: const InputDecoration(
                              labelText: 'Shop Slug *',
                              hintText: 'e.g., my-shop-name',
                              helperText: 'This becomes part of your shop\'s URL',
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Shop slug is required';
                              if (!RegExp(r'^[a-z0-9-]+$').hasMatch(v.trim())) {
                                return 'Only lowercase letters, numbers, and hyphens';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: context.paddingSizeDefault),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(labelText: 'Description (optional)'),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.paddingSizeDefault),

                    // ============================================================
                    // Shop Images – using the new SingleImageUploadField
                    // ============================================================
                    _FormSectionCard(
                      title: 'Shop Images',
                      subtitle: 'Logo appears on your shop card and listings; '
                          'cover shows as a banner at the top of your shop page.',
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 500;
                          final logoField = SingleImageUploadField(
                            label: 'Shop Logo *',
                            hint: 'Square image, ideally 400×400px',
                            aspectRatio: 1,
                            onUploaded: (url) => setState(() => _logoUrl = url),
                            initialUrl: _logoUrl, // pass existing URL if editing
                          );
                          final coverField = SingleImageUploadField(
                            label: 'Cover Image (optional)',
                            hint: 'Wide banner, ideally 1200×400px',
                            aspectRatio: 3,
                            onUploaded: (url) => setState(() => _coverUrl = url),
                            initialUrl: _coverUrl,
                          );

                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: logoField),
                                SizedBox(width: context.paddingSizeDefault),
                                Expanded(child: coverField),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              logoField,
                              SizedBox(height: context.paddingSizeDefault),
                              coverField,
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: context.paddingSizeDefault),

                    _FormSectionCard(
                      title: 'Contact Information',
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(labelText: 'Phone *'),
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
                          ),
                          SizedBox(height: context.paddingSizeDefault),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'Email *'),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Email is required';
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.paddingSizeDefault),

                    _FormSectionCard(
                      title: 'Address',
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(labelText: 'Address *'),
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Address is required' : null,
                          ),
                          SizedBox(height: context.paddingSizeDefault),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _cityController,
                                  decoration: const InputDecoration(labelText: 'City *'),
                                  validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'City is required' : null,
                                ),
                              ),
                              SizedBox(width: context.paddingSizeDefault),
                              Expanded(
                                child: TextFormField(
                                  controller: _districtController,
                                  decoration: const InputDecoration(labelText: 'District *'),
                                  validator: (v) => (v == null || v.trim().isEmpty)
                                      ? 'District is required'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.paddingSizeDefault),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCountry,
                            items: const [
                              DropdownMenuItem(value: 'Bangladesh', child: Text('Bangladesh')),
                            ],
                            onChanged: (value) {
                              if (value != null) setState(() => _selectedCountry = value);
                            },
                            decoration: const InputDecoration(labelText: 'Country *'),
                            validator: (v) =>
                            (v == null || v.isEmpty) ? 'Country is required' : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.paddingSizeDefault),

                    _FormSectionCard(
                      title: 'Business Verification',
                      subtitle: 'Optional, but speeds up review',
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _tradeLicenseController,
                            decoration: const InputDecoration(labelText: 'Trade License'),
                          ),
                          SizedBox(height: context.paddingSizeDefault),
                          TextFormField(
                            controller: _nidController,
                            decoration: const InputDecoration(labelText: 'NID'),
                          ),
                          SizedBox(height: context.paddingSizeDefault),
                          TextFormField(
                            controller: _tinController,
                            decoration: const InputDecoration(labelText: 'TIN'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.paddingSizeExtraLarge),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: state.isApplying ? null : _submit,
                        child: state.isApplying
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                            : const Text('Submit Application'),
                      ),
                    ),

                    if (state.failure != null && state.application != null) ...[
                      SizedBox(height: context.paddingSizeDefault),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(context.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(context.radiusDefault),
                        ),
                        child: Text(
                          state.failure?.message ?? 'Unknown error',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                    SizedBox(height: context.paddingSizeDefault),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Shared section card wrapper (same pattern as admin forms)
// ============================================================
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
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
          SizedBox(height: context.paddingSizeDefault),
          child,
        ],
      ),
    );
  }
}