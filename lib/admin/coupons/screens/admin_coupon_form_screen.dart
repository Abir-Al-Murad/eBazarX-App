// admin/coupons/screens/coupon_form_screen.dart
import 'package:ebazarx/admin/coupons/providers/admin_coupon_providers.dart';
import 'package:ebazarx/admin/coupons/states/coupon_crud_state.dart';
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

class _AdminCouponFormScreenState
    extends ConsumerState<AdminCouponFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountValueController;
  late TextEditingController _minOrderAmountController;
  late TextEditingController _maxDiscountController;
  late TextEditingController _usageLimitController;
  late TextEditingController _perUserLimitController;

  String _discountType = 'percentage'; // percentage or fixed
  bool _isActive = true;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  // For seller/product/category selections (optional - leave as is)
  // We'll keep them simple; they can be enhanced later.

  @override
  void initState() {
    super.initState();
    final coupon = widget.coupon;

    _codeController = TextEditingController(text: coupon?.code ?? '');
    _descriptionController =
        TextEditingController(text: coupon?.description ?? '');
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

  // ============================================================
  // DATE PICKERS
  // ============================================================

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
      // Ensure end date is after start date
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

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(couponCrudNotifierProvider.notifier);

    final double discountValue = double.tryParse(_discountValueController.text) ?? 0;
    final double? minOrderAmount =
    _minOrderAmountController.text.isNotEmpty
        ? double.tryParse(_minOrderAmountController.text)
        : null;
    final double? maxDiscount =
    _maxDiscountController.text.isNotEmpty
        ? double.tryParse(_maxDiscountController.text)
        : null;
    final int? usageLimit =
    _usageLimitController.text.isNotEmpty
        ? int.tryParse(_usageLimitController.text)
        : null;
    final int? perUserLimit =
    _perUserLimitController.text.isNotEmpty
        ? int.tryParse(_perUserLimitController.text)
        : null;

    bool success;

    if (widget.isEdit) {
      success = await notifier.updateCoupon(
        couponId: widget.coupon!.id,
        code: _codeController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        discountType: _discountType,
        discountValue: discountValue,
        minOrderAmount: minOrderAmount,
        maxDiscount: maxDiscount,
        usageLimit: usageLimit,
        perUserLimit: perUserLimit,
        isActive: _isActive,
        startDate: _startDate,
        endDate: _endDate,
        // sellerId, productIds, categoryIds can be added later
      );
    } else {
      success = await notifier.createCoupon(
        code: _codeController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        discountType: _discountType,
        discountValue: discountValue,
        minOrderAmount: minOrderAmount,
        maxDiscount: maxDiscount,
        usageLimit: usageLimit,
        perUserLimit: perUserLimit,
        isActive: _isActive,
        startDate: _startDate,
        endDate: _endDate,
        // sellerId, productIds, categoryIds can be added later
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final crudState = ref.watch(couponCrudNotifierProvider);
    final isLoading = crudState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Coupon' : 'Create Coupon'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Code
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Coupon Code *',
                hintText: 'e.g., SUMMER20',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Discount Type & Value
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _discountType,
                    decoration: const InputDecoration(
                      labelText: 'Discount Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'percentage', child: Text('Percentage')),
                      DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount')),
                    ],
                    onChanged: (val) => setState(() => _discountType = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _discountValueController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Discount Value *',
                      border: OutlineInputBorder(),
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
            const SizedBox(height: 16),

            // Min Order Amount & Max Discount
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minOrderAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Min Order Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _maxDiscountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Max Discount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Usage Limits
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _usageLimitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Usage Limit (total)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _perUserLimitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Per User Limit',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Start & End Dates
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectStartDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date *',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(DateFormat('yyyy-MM-dd').format(_startDate)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _selectEndDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'End Date *',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(DateFormat('yyyy-MM-dd').format(_endDate)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Active Switch
            SwitchListTile(
              title: const Text('Active'),
              value: _isActive,
              onChanged: (val) => setState(() => _isActive = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),

            // Error
            if (crudState.hasError)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  crudState.failure?.toString() ?? 'Error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Submit
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(
                  widget.isEdit ? 'Update Coupon' : 'Create Coupon',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}