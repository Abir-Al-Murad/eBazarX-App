import 'package:ebazarx/common/utils/styles.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;

  const ConfirmDialog({super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radiusLarge),
      ),
      title: Text(title, style: context.bold.copyWith(fontSize: context.fontSizeLarge)),
      content: Text(message, style: context.regular),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: context.medium.copyWith(color: theme.textTheme.bodyMedium?.color)),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context,true);
          },
          child: Text(confirmLabel, style: context.medium.copyWith(color: AppColors.error)),
        ),
      ],
    );
  }
}