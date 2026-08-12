// admin/sellers/presentation/screens/seller_detail_screen.dart

import 'package:ebazarx/admin/sellers/domain/entities/seller_entity.dart';
import 'package:ebazarx/admin/sellers/presentation/providers/seller_providers.dart';
import 'package:ebazarx/admin/sellers/presentation/states/seller_crud_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminSellerDetailScreen extends ConsumerStatefulWidget {
  final SellerEntity seller;

  const AdminSellerDetailScreen({super.key, required this.seller});

  @override
  ConsumerState<AdminSellerDetailScreen> createState() =>
      _AdminSellerDetailScreenState();
}

class _AdminSellerDetailScreenState
    extends ConsumerState<AdminSellerDetailScreen> {
  final TextEditingController _adminNotesController = TextEditingController();

  @override
  void dispose() {
    _adminNotesController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(String status) async {
    final notifier = ref.read(sellerCrudNotifierProvider.notifier);
    final success = await notifier.updateSellerStatus(
      sellerId: widget.seller.id,
      status: status,
      adminNotes: _adminNotesController.text.trim().isEmpty
          ? null
          : _adminNotesController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seller ${widget.seller.shopName} $status'),
          backgroundColor: status == 'active' ? Colors.green : Colors.red,
        ),
      );
      Navigator.pop(context, true);
    } else {
      final failure = ref.read(sellerCrudNotifierProvider).failure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: ${failure?.toString() ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final crudState = ref.watch(sellerCrudNotifierProvider);
    final seller = widget.seller;

    return Scaffold(
      appBar: AppBar(
        title: Text('Seller: ${seller.shopName}'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shop Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seller.shopName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text('Slug: ${seller.shopSlug}'),
                        const SizedBox(height: 4),
                        Text('Status: ${seller.status.toUpperCase()}'),
                        const SizedBox(height: 4),
                        Text('User ID: ${seller.userId}'),
                        const SizedBox(height: 8),
                        if (seller.userEmail != null)
                          Text('Email: ${seller.userEmail}'),
                        if (seller.userPhone != null)
                          Text('Phone: ${seller.userPhone}'),
                        const SizedBox(height: 8),
                        Text('Created: ${DateFormat('yyyy-MM-dd HH:mm').format(seller.createdAt)}'),
                        Text('Updated: ${DateFormat('yyyy-MM-dd HH:mm').format(seller.updatedAt)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Admin Notes
                TextField(
                  controller: _adminNotesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Admin Notes (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                if (seller.status == 'pending') ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: crudState.isLoading
                              ? null
                              : () => _updateStatus('active'),
                          icon: const Icon(Icons.check),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: crudState.isLoading
                              ? null
                              : () => _updateStatus('rejected'),
                          icon: const Icon(Icons.close),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (seller.status == 'active') ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: crudState.isLoading
                              ? null
                              : () => _updateStatus('pending'),
                          icon: const Icon(Icons.pending),
                          label: const Text('Set Pending'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: crudState.isLoading
                              ? null
                              : () => _updateStatus('rejected'),
                          icon: const Icon(Icons.close),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (seller.status == 'rejected') ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: crudState.isLoading
                              ? null
                              : () => _updateStatus('pending'),
                          icon: const Icon(Icons.pending),
                          label: const Text('Reconsider'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: crudState.isLoading
                              ? null
                              : () => _updateStatus('active'),
                          icon: const Icon(Icons.check),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),
                // Error display
                if (crudState.isFailure)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      crudState.failure?.toString() ?? 'Error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          if (crudState.isLoading)
            const Opacity(
              opacity: 0.7,
              child: ModalBarrier(dismissible: false),
            ),
          if (crudState.isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}