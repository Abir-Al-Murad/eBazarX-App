import 'package:flutter/material.dart';

class SellerEmptyWidget extends StatelessWidget {
  const SellerEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No Orders Found', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('You don\'t have any seller orders yet.', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // refresh action is handled by parent
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}