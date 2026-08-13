import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class DesktopHeader extends StatelessWidget {
  const DesktopHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.canPop(context);

    return Row(
      children: [
        if (canPop) ...[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Back',
          ),
          SizedBox(width: context.paddingSizeSmall),
        ],

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: context.fontSizeExtraLarge + 4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.all(
            context.paddingSizeSmall,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(
              alpha: 0.1,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.admin_panel_settings_rounded,
            color: theme.colorScheme.primary,
            size: 22,
          ),
        ),
      ],
    );
  }
}