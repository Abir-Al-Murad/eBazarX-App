// admin/flash_sale/screens/flash_sale_list_screen.dart

import 'package:ebazarx/admin/flash_sale/providers/admin_flash_sale_providers.dart';
import 'package:ebazarx/admin/flash_sale/screens/admin_flash_sale_form_screen.dart';
import 'package:ebazarx/admin/flash_sale/states/flash_sale_admin_list_state.dart';
import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminFlashSaleListScreen extends ConsumerStatefulWidget {
  const AdminFlashSaleListScreen({super.key});

  @override
  ConsumerState<AdminFlashSaleListScreen> createState() =>
      _AdminFlashSaleListScreenState();
}

class _AdminFlashSaleListScreenState
    extends ConsumerState<AdminFlashSaleListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(flashSaleAdminListNotifierProvider.notifier).fetchFlashSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashSaleAdminListNotifierProvider);
    final notifier = ref.read(flashSaleAdminListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToForm(context),
          ),
        ],
      ),
      body: state.status == FlashSaleAdminListStatus.loading &&
          state.flashSales.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.flashSales.isEmpty
          ? const Center(child: Text('No flash sales found'))
          : RefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: ListView.builder(
          itemCount: state.flashSales.length,
          itemBuilder: (context, index) {
            final flashSale = state.flashSales[index];
            return _FlashSaleTile(
              flashSale: flashSale,
              onEdit: () => _navigateToForm(context, flashSale: flashSale),
              onDelete: () => _confirmDelete(context, flashSale.id),
            );
          },
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context, {FlashSale? flashSale}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminFlashSaleFormScreen(flashSale: flashSale),
      ),
    ).then((_) {
      // Refresh after returning from form
      ref.read(flashSaleAdminListNotifierProvider.notifier).refresh();
    });
  }

  void _confirmDelete(BuildContext context, String flashSaleId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Flash Sale'),
        content: const Text('Are you sure you want to delete this flash sale?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final notifier =
              ref.read(flashSaleCrudNotifierProvider.notifier);
              final success = await notifier.deleteFlashSale(flashSaleId);
              if (success) {
                ref.read(flashSaleAdminListNotifierProvider.notifier).refresh();
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to delete flash sale')),
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

class _FlashSaleTile extends StatelessWidget {
  final FlashSale flashSale;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FlashSaleTile({
    required this.flashSale,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(flashSale.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${dateFormat.format(flashSale.startDate)} → ${dateFormat.format(flashSale.endDate)}',
            ),
            Text('Products: ${flashSale.products.length}'),
          ],
        ),
        leading: flashSale.isActive
            ? const Icon(Icons.flash_on, color: Colors.orange)
            : const Icon(Icons.flash_off, color: Colors.grey),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}