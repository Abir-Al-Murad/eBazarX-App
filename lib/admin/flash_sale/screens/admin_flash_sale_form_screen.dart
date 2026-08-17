// admin/flash_sale/screens/flash_sale_form_screen.dart

import 'package:ebazarx/admin/flash_sale/providers/admin_flash_sale_providers.dart';
import 'package:ebazarx/admin/flash_sale/states/flash_sale_crud_state.dart';
import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminFlashSaleFormScreen extends ConsumerStatefulWidget {
  final FlashSale? flashSale;

  const AdminFlashSaleFormScreen({super.key, this.flashSale});

  bool get isEdit => flashSale != null;

  @override
  ConsumerState<AdminFlashSaleFormScreen> createState() =>
      _AdminFlashSaleFormScreenState();
}

class _AdminFlashSaleFormScreenState
    extends ConsumerState<AdminFlashSaleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isActive = true;

  // Product entries: each as a map with productId, discountPrice, stockLimit
  List<Map<String, dynamic>> _productEntries = [];

  @override
  void initState() {
    super.initState();
    final flashSale = widget.flashSale;

    _nameController = TextEditingController(text: flashSale?.name ?? '');
    _descriptionController =
        TextEditingController(text: flashSale?.description ?? '');

    if (flashSale != null) {
      _startDate = flashSale.startDate;
      _endDate = flashSale.endDate;
      _isActive = flashSale.isActive;
      _productEntries = flashSale.products
          .map((p) => {
        'product_id': p.productId,
        'discount_price': p.discountPrice,
        'stock_limit': p.stockLimit,
      })
          .toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ============================================================
  // PRODUCT MANAGEMENT
  // ============================================================

  void _addProductEntry() {
    setState(() {
      _productEntries.add({
        'product_id': '',
        'discount_price': 0.0,
        'stock_limit': 0,
      });
    });
  }

  void _removeProductEntry(int index) {
    setState(() {
      _productEntries.removeAt(index);
    });
  }

  void _updateProductEntry(int index, String key, dynamic value) {
    setState(() {
      _productEntries[index][key] = value;
    });
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
      if (_endDate.isBefore(_startDate)) {
        setState(() => _endDate = _startDate.add(const Duration(days: 7)));
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
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate product entries
    for (var entry in _productEntries) {
      if (entry['productId'].toString().trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product ID is required for all entries')),
        );
        return;
      }
      if (entry['discountPrice'] <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Discount price must be positive')),
        );
        return;
      }
      if (entry['stockLimit'] <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock limit must be positive')),
        );
        return;
      }
    }

    final notifier = ref.read(flashSaleCrudNotifierProvider.notifier);

    bool success;

    if (widget.isEdit) {
      success = await notifier.updateFlashSale(
        flashSaleId: widget.flashSale!.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        isActive: _isActive,
        products: _productEntries,
      );
    } else {
      success = await notifier.createFlashSale(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        isActive: _isActive,
        products: _productEntries,
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final crudState = ref.watch(flashSaleCrudNotifierProvider);
    final isLoading = crudState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Flash Sale' : 'Create Flash Sale'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: 'Summer Flash Sale',
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

            // Product Entries
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _addProductEntry,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (_productEntries.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No products added yet.'),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _productEntries.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final entry = _productEntries[index];
                  return _ProductEntryRow(
                    index: index,
                    entry: entry,
                    onUpdate: (key, value) =>
                        _updateProductEntry(index, key, value),
                    onRemove: () => _removeProductEntry(index),
                  );
                },
              ),
            const SizedBox(height: 24),

            // Error
            if (crudState.isFailure)
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
                  widget.isEdit ? 'Update Flash Sale' : 'Create Flash Sale',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PRODUCT ENTRY ROW WIDGET
// ============================================================

class _ProductEntryRow extends StatelessWidget {
  final int index;
  final Map<String, dynamic> entry;
  final void Function(String key, dynamic value) onUpdate;
  final VoidCallback onRemove;

  const _ProductEntryRow({
    required this.index,
    required this.entry,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: entry['productId'],
            decoration: const InputDecoration(
              labelText: 'Product ID',
              hintText: 'product_123',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => onUpdate('productId', value),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: entry['discountPrice'].toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Disc. Price',
              hintText: '19.99',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) =>
                onUpdate('discountPrice', double.tryParse(value) ?? 0.0),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: entry['stockLimit'].toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stock Limit',
              hintText: '50',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) =>
                onUpdate('stockLimit', int.tryParse(value) ?? 0),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onRemove,
        ),
      ],
    );
  }
}