// admin/sellers/presentation/screens/seller_list_screen.dart

import 'package:ebazarx/admin/sellers/presentation/providers/seller_providers.dart';
import 'package:ebazarx/admin/sellers/presentation/screens/admin_seller_detail_screen.dart';
import 'package:ebazarx/admin/sellers/domain/entities/seller_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminSellerListScreen extends ConsumerStatefulWidget {
  const AdminSellerListScreen({super.key});

  @override
  ConsumerState<AdminSellerListScreen> createState() =>
      _AdminSellerListScreenState();
}

class _AdminSellerListScreenState extends ConsumerState<AdminSellerListScreen> {
  String _selectedStatus = 'all'; // 'all', 'pending', 'active', 'rejected'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSellers();
    });
  }

  void _fetchSellers() {
    final notifier = ref.read(sellerListNotifierProvider.notifier);
    if (_selectedStatus == 'pending') {
      notifier.getPendingSellers();
    } else {
      notifier.getAllSellers(
        status: _selectedStatus == 'all' ? null : _selectedStatus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerListNotifierProvider);
    final notifier = ref.read(sellerListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sellers'),
        actions: [
          DropdownButton<String>(
            value: _selectedStatus,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'approved', child: Text('Approved')),
              DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedStatus = val;
                  _fetchSellers();
                });
              }
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.sellers.isEmpty
          ? const Center(child: Text('No sellers found'))
          : RefreshIndicator(
        onRefresh: () async => _fetchSellers(),
        child: ListView.builder(
          itemCount: state.sellers.length,
          itemBuilder: (context, index) {
            final seller = state.sellers[index];
            return _SellerTile(
              seller: seller,
              onTap: () => _navigateToDetail(context, seller),
            );
          },
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, SellerEntity seller) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminSellerDetailScreen(seller: seller),
      ),
    ).then((_) {
      // Refresh list after returning from detail
      _fetchSellers();
    });
  }
}

class _SellerTile extends StatelessWidget {
  final SellerEntity seller;
  final VoidCallback onTap;

  const _SellerTile({required this.seller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (seller.status) {
      case 'active':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Text(
            seller.shopName[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(seller.shopName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(seller.shopSlug),
            if (seller.userEmail != null) Text(seller.userEmail!),
            if (seller.userPhone != null) Text(seller.userPhone!),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            seller.status.toUpperCase(),
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: onTap,
        isThreeLine: true,
      ),
    );
  }
}