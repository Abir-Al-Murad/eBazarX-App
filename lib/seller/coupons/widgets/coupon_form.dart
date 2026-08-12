import 'package:flutter/material.dart';
import 'package:ebazarx/features/coupon/domain/entities/admin_coupon_entity.dart';

class CouponForm extends StatefulWidget {
  final AdminCouponEntity? initialData;
  final bool isEditing;
  final void Function(Map<String, dynamic>) onSubmit;
  final VoidCallback onCancel;
  final bool isSubmitting;

  const CouponForm({
    super.key,
    this.initialData,
    required this.isEditing,
    required this.onSubmit,
    required this.onCancel,
    this.isSubmitting = false,
  });

  @override
  State<CouponForm> createState() => _CouponFormState();
}

class _CouponFormState extends State<CouponForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _discountValueController;
  late final TextEditingController _minOrderController;
  late final TextEditingController _maxDiscountController;
  late final TextEditingController _usageLimitController;
  late final TextEditingController _perUserLimitController;

  String _discountType = 'percentage';
  bool _isActive = true;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    final initial = widget.initialData;
    _codeController = TextEditingController(text: initial?.code ?? '');
    _descriptionController =
        TextEditingController(text: initial?.description ?? '');
    _discountValueController =
        TextEditingController(text: initial?.discountValue.toString() ?? '');
    _minOrderController =
        TextEditingController(text: initial?.minOrderAmount?.toString() ?? '');
    _maxDiscountController =
        TextEditingController(text: initial?.maxDiscount?.toString() ?? '');
    _usageLimitController =
        TextEditingController(text: initial?.usageLimit?.toString() ?? '');
    _perUserLimitController =
        TextEditingController(text: initial?.perUserLimit?.toString() ?? '');

    if (initial != null) {
      _discountType = initial.discountType;
      _isActive = initial.isActive;
      _startDate = initial.startDate;
      _endDate = initial.endDate;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minOrderController.dispose();
    _maxDiscountController.dispose();
    _usageLimitController.dispose();
    _perUserLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Code
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Coupon Code *',
              hintText: 'e.g., SUMMER20',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Coupon code is required';
              }
              if (value.length > 50) {
                return 'Coupon code must be at most 50 characters';
              }
              if (!RegExp(r'^[A-Z0-9_]+$').hasMatch(value)) {
                return 'Only uppercase letters, numbers, and underscores allowed';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Brief description of the coupon',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Discount Type + Value
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _discountType,
                  items: const [
                    DropdownMenuItem(value: 'percentage', child: Text('Percentage')),
                    DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount')),
                  ],
                  onChanged: (val) => setState(() => _discountType = val!),
                  decoration: const InputDecoration(
                    labelText: 'Discount Type *',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _discountValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _discountType == 'percentage'
                        ? 'Discount % *'
                        : 'Amount (৳) *',
                    hintText: _discountType == 'percentage' ? 'e.g., 20' : 'e.g., 50',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Discount value is required';
                    }
                    final numValue = double.tryParse(value);
                    if (numValue == null || numValue <= 0) {
                      return 'Enter a valid positive number';
                    }
                    if (_discountType == 'percentage' && numValue > 100) {
                      return 'Percentage cannot exceed 100%';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Min Order Amount
          TextFormField(
            controller: _minOrderController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minimum Order Amount',
              hintText: 'Leave empty for no minimum',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Max Discount
          TextFormField(
            controller: _maxDiscountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Maximum Discount Amount',
              hintText: 'Leave empty for no maximum',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Usage Limit
          TextFormField(
            controller: _usageLimitController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Total Usage Limit',
              hintText: 'Leave empty for unlimited',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Per User Limit
          TextFormField(
            controller: _perUserLimitController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Per User Limit',
              hintText: 'Leave empty for unlimited',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Date Range
          Row(
            children: [
              Expanded(
                child: _buildDatePicker(
                  context,
                  label: 'Start Date *',
                  value: _startDate,
                  onChanged: (date) => setState(() => _startDate = date),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDatePicker(
                  context,
                  label: 'End Date *',
                  value: _endDate,
                  onChanged: (date) => setState(() => _endDate = date),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Active toggle
          SwitchListTile(
            title: const Text('Active'),
            subtitle: const Text('Coupon will be available for customers'),
            value: _isActive,
            onChanged: (val) => setState(() => _isActive = val),
          ),

          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.isSubmitting ? null : widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.isSubmitting ? null : _submit,
                  child: widget.isSubmitting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(widget.isEditing ? 'Update' : 'Create'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
      BuildContext context, {
        required String label,
        required DateTime value,
        required ValueChanged<DateTime> onChanged,
      }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 730)),
        );
        if (date != null) {
          final time = TimeOfDay.now();
          final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          onChanged(newDateTime);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(_formatDate(value)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'code': _codeController.text.trim().toUpperCase(),
        'description': _descriptionController.text.trim(),
        'discountType': _discountType,
        'discountValue': double.tryParse(_discountValueController.text) ?? 0,
        'minOrderAmount': double.tryParse(_minOrderController.text),
        'maxDiscount': double.tryParse(_maxDiscountController.text),
        'usageLimit': int.tryParse(_usageLimitController.text),
        'perUserLimit': int.tryParse(_perUserLimitController.text),
        'isActive': _isActive,
        'startDate': _startDate,
        'endDate': _endDate,
      };
      widget.onSubmit(data);
    }
  }
}