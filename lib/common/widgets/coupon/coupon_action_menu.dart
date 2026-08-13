// common/widgets/coupon/coupon_actions_menu.dart
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 3-dot Edit/Delete menu shared by admin + seller coupon screens
/// (table row trailing cell, and card trailing icon).
class CouponActionsMenu extends StatelessWidget {
  const CouponActionsMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
    this.compact = false,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, size: compact ? 20 : 22),
      padding: EdgeInsets.zero,
      tooltip: 'Actions',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radiusDefault),
      ),
      onSelected: (value) {
        if (value == 'edit') onEdit();
        if (value == 'delete') onDelete();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline_rounded, color: AppColors.error),
            title: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ),
      ],
    );
  }
}