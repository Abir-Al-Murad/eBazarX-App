// features/order/presentation/screens/order_details_screen.dart
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/order/domain/entities/order_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/order_status.dart';
import 'package:ebazarx/features/order/domain/entities/payment_method.dart';
import 'package:ebazarx/features/order/presentation/providers/order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderNotifierProvider.notifier).getOrder(widget.orderId);
    });
  }

  @override
  void dispose() {
    ref.read(orderNotifierProvider.notifier).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderNotifierProvider);
    final order = state.order;
    final isLoading = state.isLoading;
    final isSuccess = state.isSuccess;
    final failure = state.failure;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          if (order != null && order.isCancellable)
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              onPressed: state.isLoading ? null : () => _cancelOrder(context),
              tooltip: 'Cancel Order',
            ),
        ],
      ),
      body: failure != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text('Error loading order: $failure'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(orderNotifierProvider.notifier)
                    .getOrder(widget.orderId);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : isLoading
          ? const Center(child: CircularProgressIndicator())
          : order == null
          ? const Center(child: Text('Order not found'))
          : _buildOrderContent(context, order),
    );
  }

  Widget _buildOrderContent(BuildContext context, OrderEntity order) {
    final isDesktop = context.isDesktop;
    return isDesktop
        ? _DesktopOrderDetails(order: order)
        : _MobileOrderDetails(order: order);
  }

  Future<void> _cancelOrder(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(orderNotifierProvider.notifier)
          .cancelOrder(widget.orderId);
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order cancelled successfully')),
          );
          // Refresh the order details after cancellation
          ref.read(orderNotifierProvider.notifier).getOrder(widget.orderId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to cancel order. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

// ---------- Desktop Layout ----------
class _DesktopOrderDetails extends StatelessWidget {
  final OrderEntity order;

  const _DesktopOrderDetails({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _OrderInfoCard(order: order),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: _OrderItemsTable(items: order.items),
          ),
        ],
      ),
    );
  }
}

// ---------- Mobile Layout ----------
class _MobileOrderDetails extends StatelessWidget {
  final OrderEntity order;

  const _MobileOrderDetails({required this.order});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderInfoCard(order: order),
          const SizedBox(height: 24),
          const Text(
            'Order Items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) => _OrderItemTile(item: item)),
        ],
      ),
    );
  }
}

// ---------- Order Info Card ----------
class _OrderInfoCard extends StatelessWidget {
  final OrderEntity order;

  const _OrderInfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Order Information'),
            _infoRow('Order ID', '#${order.id.substring(0, 8)}'),
            _infoRow('Date', _formatDate(order.createdAt)),
            _infoRow('Payment Method', order.paymentMethod ?? 'N/A'),
            _infoRow('Payment Status', _paymentStatusText(order.paymentStatus)),
            _infoRow('Order Status', order.orderStatus.displayName),
            const Divider(height: 32),
            _sectionTitle('Order Summary'),
            _infoRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
            _infoRow('Shipping', '\$${order.shippingFee.toStringAsFixed(2)}'),
            _infoRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
            _infoRow('Discount', '- \$${order.discountAmount.toStringAsFixed(2)}'),
            const Divider(height: 32),
            _infoRow(
              'Grand Total',
              '\$${order.grandTotal.toStringAsFixed(2)}',
              bold: true,
              color: theme.primaryColor,
            ),
            if (order.notes != null) ...[
              const SizedBox(height: 16),
              _sectionTitle('Notes'),
              Text(order.notes!, style: const TextStyle(fontSize: 14)),
            ],
            if (order.trackingNumber != null) ...[
              const SizedBox(height: 16),
              _infoRow('Tracking Number', order.trackingNumber!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _paymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
        case PaymentStatus.processing:
        return "Processing";
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// ---------- Order Items Table (Desktop) ----------
class _OrderItemsTable extends StatelessWidget {
  final List<OrderItemEntity> items;

  const _OrderItemsTable({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const Center(child: Text('No items'))
            else
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor:
                  MaterialStateProperty.all(Colors.grey.shade100),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  columns: const [
                    DataColumn(label: Text('Product')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Qty')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Total')),
                  ],
                  rows: items.map((item) {
                    final total = item.priceAtTime * item.quantity;
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              _productImage(item.productImageAtTime, 40),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.productNameAtTime,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(
                            '\$${item.priceAtTime.toStringAsFixed(2)}')),
                        DataCell(Text('${item.quantity}')),
                        DataCell(_statusChip(item.status)),
                        DataCell(Text('\$${total.toStringAsFixed(2)}')),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _productImage(String? imageUrl, double size) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image, size: 20, color: Colors.grey),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      ),
    );
  }

  Widget _statusChip(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName.toUpperCase(),
        style: TextStyle(
          color: status.color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ---------- Order Item Tile (Mobile) ----------
class _OrderItemTile extends StatelessWidget {
  final OrderItemEntity item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final total = item.priceAtTime * item.quantity;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _productImage(item.productImageAtTime, 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productNameAtTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${item.priceAtTime.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 12),
                      Text('Qty: ${item.quantity}'),
                      const SizedBox(width: 12),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _statusChip(item.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productImage(String? imageUrl, double size) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image, size: 30, color: Colors.grey),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      ),
    );
  }

  Widget _statusChip(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName.toUpperCase(),
        style: TextStyle(
          color: status.color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}