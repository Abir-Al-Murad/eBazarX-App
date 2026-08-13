import 'package:ebazarx/common/widgets/coupon/coupon_action_menu.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CouponTableRow {
  const CouponTableRow({
    required this.code,
    required this.discountText,
    required this.startDate,
    required this.endDate,
    required this.usedCount,
    required this.usageLimit,
    required this.isActive,
    required this.onEdit,
    required this.onDelete,
  });

  final String code;
  final String discountText;
  final DateTime startDate;
  final DateTime endDate;
  final int usedCount;
  final int? usageLimit;
  final bool isActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
}

/// Desktop coupon table — shared by admin + seller coupon screens.
class CouponDesktopTable extends StatelessWidget {
  const CouponDesktopTable({
    super.key,
    required this.rows,
    required this.hasMore,
    this.scrollController,
  });

  final List<CouponTableRow> rows;
  final bool hasMore;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(context.radiusLarge),
          border: Border.all(color: theme.dividerColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 24,
                headingRowHeight: 46,
                dataRowMinHeight: 60,
                dataRowMaxHeight: 60,
                headingRowColor: WidgetStateProperty.all(
                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ),
                headingTextStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                dividerThickness: 0.6,
                columns: const [
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('Discount')),
                  DataColumn(label: Text('Valid')),
                  DataColumn(label: Text('Usage')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('')),
                ],
                rows: rows.map((row) {
                  return DataRow(
                    cells: [
                      DataCell(Text(row.code, style: const TextStyle(fontWeight: FontWeight.w700))),
                      DataCell(Text(row.discountText)),
                      DataCell(Text(
                        '${dateFormat.format(row.startDate)} → ${dateFormat.format(row.endDate)}',
                      )),
                      DataCell(Text('${row.usedCount} / ${row.usageLimit ?? "∞"}')),
                      DataCell(StatusChip(
                        status: row.isActive ? 'Active' : 'Inactive',
                        showDot: false,
                      )),
                      DataCell(CouponActionsMenu(onEdit: row.onEdit, onDelete: row.onDelete)),
                    ],
                  );
                }).toList(),
              ),
            ),
            if (hasMore)
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.paddingSizeDefault),
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}