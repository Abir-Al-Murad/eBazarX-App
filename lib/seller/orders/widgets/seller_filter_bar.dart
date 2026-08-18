import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ebazarx/common/widgets/filter_dropdown.dart';
import 'package:flutter/material.dart';

class SellerFilterBar extends StatelessWidget {
  final String orderStatus;
  final String paymentStatus;
  final String sortBy;

  final ValueChanged<String?> onOrderStatusChanged;
  final ValueChanged<String?> onPaymentStatusChanged;
  final ValueChanged<String?> onSortChanged;

  final VoidCallback onDateRangePressed;
  final VoidCallback? onReset;

  const SellerFilterBar({
    super.key,
    required this.orderStatus,
    required this.paymentStatus,
    required this.sortBy,
    required this.onOrderStatusChanged,
    required this.onPaymentStatusChanged,
    required this.onSortChanged,
    required this.onDateRangePressed,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    if (isDesktop) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FilterDropdown<String>(
            label: "Order Status",
            value: orderStatus,
            icon: Icons.local_shipping_outlined,
            items: const [
              "All",
              "Pending",
              "Processing",
              "Shipped",
              "Delivered",
              "Cancelled",
            ],
            labelBuilder: (e) => e,
            onChanged: onOrderStatusChanged,
          ),

          FilterDropdown<String>(
            label: "Payment Status",
            value: paymentStatus,
            icon: Icons.payment_outlined,
            items: const [
              "All",
              "Paid",
              "Pending",
              "Failed",
            ],
            labelBuilder: (e) => e,
            onChanged: onPaymentStatusChanged,
          ),

          FilterDropdown<String>(
            label: "Sort By",
            value: sortBy,
            icon: Icons.sort,
            items: const [
              "Newest",
              "Oldest",
              "Highest Price",
              "Lowest Price",
            ],
            labelBuilder: (e) => e,
            onChanged: onSortChanged,
          ),

          OutlinedButton.icon(
            onPressed: onDateRangePressed,
            icon: const Icon(Icons.date_range),
            label: const Text("Date Range"),
          ),

          if (onReset != null)
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text("Reset"),
            ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showFilterBottomSheet(context),
        icon: const Icon(Icons.tune),
        label: const Text("Filters"),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FilterDropdown<String>(
                  label: "Order Status",
                  value: orderStatus,
                  icon: Icons.local_shipping_outlined,
                  items: const [
                    "All",
                    "Pending",
                    "Processing",
                    "Shipped",
                    "Delivered",
                    "Cancelled",
                  ],
                  labelBuilder: (e) => e,
                  onChanged: onOrderStatusChanged,
                ),

                const SizedBox(height: 16),

                FilterDropdown<String>(
                  label: "Payment Status",
                  value: paymentStatus,
                  icon: Icons.payment_outlined,
                  items: const [
                    "All",
                    "Paid",
                    "Pending",
                    "Failed",
                  ],
                  labelBuilder: (e) => e,
                  onChanged: onPaymentStatusChanged,
                ),

                const SizedBox(height: 16),

                FilterDropdown<String>(
                  label: "Sort By",
                  value: sortBy,
                  icon: Icons.sort,
                  items: const [
                    "Newest",
                    "Oldest",
                    "Highest Price",
                    "Lowest Price",
                  ],
                  labelBuilder: (e) => e,
                  onChanged: onSortChanged,
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onDateRangePressed,
                    icon: const Icon(Icons.date_range),
                    label: const Text("Select Date Range"),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          onReset?.call();
                          Navigator.pop(context);
                        },
                        child: const Text("Reset"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Apply"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}