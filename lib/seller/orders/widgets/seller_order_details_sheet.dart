import 'package:flutter/material.dart';
import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';

class SellerOrderDetailsSheet extends StatelessWidget {
  final OrderItemEntity order;

  const SellerOrderDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order #${order.id}', style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Product Information'),
                  _infoRow('Product', order.productNameAtTime),
                  if (order.productImageAtTime != null)
                    Image.network(order.productImageAtTime!, height: 100),
                  _infoRow('Price', '\$${order.priceAtTime.toStringAsFixed(2)}'),
                  _infoRow('Quantity', '${order.quantity}'),
                  if (order.sizeAtTime != null) _infoRow('Size', order.sizeAtTime!),
                  if (order.colorAtTime != null) _infoRow('Color', order.colorAtTime!),
                  const SizedBox(height: 12),
                  _sectionTitle('Status'),
                  _infoRow('Current Status', order.status.name.toUpperCase()),
                  const SizedBox(height: 12),
                  _sectionTitle('Additional Info'),
                  _infoRow('Product ID', order.productId),
                  _infoRow('Variant ID', order.variantId),
                  _infoRow('Seller ID', order.sellerId),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}