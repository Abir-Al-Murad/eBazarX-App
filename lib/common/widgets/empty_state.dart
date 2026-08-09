import 'package:ebazarx/common/utils/styles.dart';
import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.buttonText,
    this.onPressed,
    this.buttonIcon,
    this.iconColor,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onPressed;
  final IconData? buttonIcon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingSizeExtraLarge,
          vertical: context.paddingSizeDefault,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Layered Glass/Glow Icon Container
            Container(
              padding: EdgeInsets.all(context.paddingSizeLarge),
              decoration: BoxDecoration(
                color: effectiveIconColor.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: effectiveIconColor.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              child: Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: effectiveIconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 38,
                  color: effectiveIconColor,
                ),
              ),
            ),

            SizedBox(height: context.paddingSizeLarge),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.bold.copyWith(
                fontSize: context.fontSizeLarge,
                color: theme.textTheme.titleLarge?.color,
                letterSpacing: -0.3,
              ),
            ),

            SizedBox(height: context.paddingSizeExtraSmall + 2),

            // Message Body with Constraint for Ideal Line Length
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: context.regular.copyWith(
                  fontSize: context.fontSizeSmall,
                  color: theme.hintColor,
                  height: 1.45,
                ),
              ),
            ),

            // Optional Action Button
            if (buttonText != null && onPressed != null) ...[
              SizedBox(height: context.paddingSizeLarge),

              FilledButton.icon(
                onPressed: onPressed,
                icon: Icon(
                  buttonIcon ?? Icons.arrow_forward_rounded,
                  size: 18,
                ),
                label: Text(
                  buttonText!,
                  style: context.bold.copyWith(
                    fontSize: context.fontSizeSmall,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                style: FilledButton.styleFrom(
                  elevation: 0,
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.paddingSizeExtraLarge,
                    vertical: context.paddingSizeSmall + 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}