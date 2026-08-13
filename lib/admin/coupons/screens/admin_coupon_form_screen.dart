// admin/coupons/screens/admin_coupon_form_screen.dart
import 'package:ebazarx/admin/coupons/providers/admin_coupon_providers.dart';
import 'package:ebazarx/common/widgets/desktop_header.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminCouponFormScreen extends ConsumerStatefulWidget {
  final AdminCouponEntity? coupon;

  const AdminCouponFormScreen({super.key, this.coupon});

  bool get isEdit => coupon != null;

  @override
  ConsumerState<AdminCouponFormScreen> createState() =>
      _AdminCouponFormScreenState();
}

class _AdminCouponFormScreenState extends ConsumerState<AdminCouponFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountValueController;
  late TextEditingController _minOrderAmountController;
  late TextEditingController _maxDiscountController;
  late TextEditingController _usageLimitController;
  late TextEditingController _perUserLimitController;

  String _discountType = 'percentage';
  bool _isActive = true;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    final coupon = widget.coupon;

    _codeController = TextEditingController(text: coupon?.code ?? '');
    _descriptionController = TextEditingController(text: coupon?.description ?? '');
    _discountValueController =
        TextEditingController(text: coupon?.discountValue.toString() ?? '');
    _minOrderAmountController =
        TextEditingController(text: coupon?.minOrderAmount?.toString() ?? '');
    _maxDiscountController =
        TextEditingController(text: coupon?.maxDiscount?.toString() ?? '');
    _usageLimitController =
        TextEditingController(text: coupon?.usageLimit?.toString() ?? '');
    _perUserLimitController =
        TextEditingController(text: coupon?.perUserLimit?.toString() ?? '');

    _discountType = coupon?.discountType ?? 'percentage';
    _isActive = coupon?.isActive ?? true;
    if (coupon != null) {
      _startDate = coupon.startDate;
      _endDate = coupon.endDate;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minOrderAmountController.dispose();
    _maxDiscountController.dispose();
    _usageLimitController.dispose();
    _perUserLimitController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
      if (_endDate.isBefore(_startDate)) {
        setState(() => _endDate = _startDate.add(const Duration(days: 30)));
      }
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(couponCrudNotifierProvider.notifier);

    final discountValue = double.tryParse(_discountValueController.text) ?? 0;
    final minOrderAmount = _minOrderAmountController.text.isNotEmpty
        ? double.tryParse(_minOrderAmountController.text)
        : null;
    final maxDiscount = _maxDiscountController.text.isNotEmpty
        ? double.tryParse(_maxDiscountController.text)
        : null;
    final usageLimit = _usageLimitController.text.isNotEmpty
        ? int.tryParse(_usageLimitController.text)
        : null;
    final perUserLimit = _perUserLimitController.text.isNotEmpty
        ? int.tryParse(_perUserLimitController.text)
        : null;

    bool success;
    if (widget.isEdit) {
      success = await notifier.updateCoupon(
        couponId: widget.coupon!.id,
        code: _codeController.text.trim(),
        description:
        _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        discountType: _discountType,
        discountValue: discountValue,
        minOrderAmount: minOrderAmount,
        maxDiscount: maxDiscount,
        usageLimit: usageLimit,
        perUserLimit: perUserLimit,
        isActive: _isActive,
        startDate: _startDate,
        endDate: _endDate,
      );
    } else {
      success = await notifier.createCoupon(
        code: _codeController.text.trim(),
        description:
        _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        discountType: _discountType,
        discountValue: discountValue,
        minOrderAmount: minOrderAmount,
        maxDiscount: maxDiscount,
        usageLimit: usageLimit,
        perUserLimit: perUserLimit,
        isActive: _isActive,
        startDate: _startDate,
        endDate: _endDate,
      );
    }

    if (!mounted) return;

    if (success) {
      AppSnackBar.success(context: context, widget.isEdit ? 'Coupon updated' : 'Coupon created');
      Navigator.pop(context, true);
    } else {
      final crudState = ref.read(couponCrudNotifierProvider);
      AppSnackBar.error(context: context, crudState.failure?.toString() ?? 'Failed to save coupon');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crudState = ref.watch(couponCrudNotifierProvider);
    final isLoading = crudState.isLoading;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: context.isDesktop
          ? null
          : AppBar(title: Text(widget.isEdit ? 'Edit Coupon' : 'Create Coupon')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.paddingSizeLarge),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (context.isDesktop) ...[
                          DesktopHeader(
                            title: widget.isEdit ? 'Edit Coupon' : 'Create Coupon',
                            subtitle: widget.isEdit
                                ? 'Update this discount code'
                                : 'Set up a new discount code for customers',
                          ),
                          SizedBox(height: context.paddingSizeExtraLarge),
                        ],
                        _FormSectionCard(
                          title: 'Coupon Details',
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _codeController,
                                textCapitalization: TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  labelText: 'Coupon Code *',
                                  hintText: 'e.g., SUMMER20',
                                ),
                                validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Required' : null,
                              ),
                              SizedBox(height: context.paddingSizeDefault),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: 2,
                                decoration: const InputDecoration(labelText: 'Description'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.paddingSizeDefault),
                        _FormSectionCard(
                          title: 'Discount',
                          subtitle: 'How much the customer saves and any spending conditions',
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: DropdownButtonFormField<String>(
                                      initialValue: _discountType,
                                      decoration: const InputDecoration(labelText: 'Type'),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'percentage',
                                          child: Text('Percentage'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'fixed',
                                          child: Text('Fixed Amount'),
                                        ),
                                      ],
                                      onChanged: (val) => setState(() => _discountType = val!),
                                    ),
                                  ),
                                  SizedBox(width: context.paddingSizeDefault),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      controller: _discountValueController,
                                      keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        labelText: 'Value *',
                                        prefixText: _discountType == 'percentage' ? null : '৳ ',
                                        suffixText: _discountType == 'percentage' ? '%' : null,
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) return 'Required';
                                        if (double.tryParse(v) == null) return 'Invalid number';
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: context.paddingSizeDefault),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _minOrderAmountController,
                                      keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(
                                        labelText: 'Min Order Amount',
                                        prefixText: '৳ ',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: context.paddingSizeDefault),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _maxDiscountController,
                                      keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(
                                        labelText: 'Max Discount',
                                        prefixText: '৳ ',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.paddingSizeDefault),
                        _FormSectionCard(
                          title: 'Usage Limits',
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _usageLimitController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Total Usage Limit',
                                    hintText: 'Leave blank for unlimited',
                                  ),
                                ),
                              ),
                              SizedBox(width: context.paddingSizeDefault),
                              Expanded(
                                child: TextFormField(
                                  controller: _perUserLimitController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Per User Limit',
                                    hintText: 'Leave blank for unlimited',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.paddingSizeDefault),
                        _FormSectionCard(
                          title: 'Validity & Status',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _DateField(
                                      label: 'Start Date *',
                                      date: _startDate,
                                      onTap: _selectStartDate,
                                    ),
                                  ),
                                  SizedBox(width: context.paddingSizeDefault),
                                  Expanded(
                                    child: _DateField(
                                      label: 'End Date *',
                                      date: _endDate,
                                      onTap: _selectEndDate,
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
                                      onChanged: (val) => setState(() => _isActive = val),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _SubmitBar(isEdit: widget.isEdit, isSaving: isLoading, onSubmit: _submit),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.date, required this.onTap});

  final String label;
  final DateTime date;
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
        child: Text(DateFormat('dd MMM yyyy').format(date)),
      ),
    );
  }
}

// ================================
// Shared section card wrapper (same as banner/category form)
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
// Sticky submit bar (same as banner/category form)
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
          constraints: const BoxConstraints(maxWidth: 720),
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
                    : (isEdit ? 'Update Coupon' : 'Create Coupon'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}