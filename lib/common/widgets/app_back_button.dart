
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showBacking;
  final double size;

  const AppBackButton({super.key,
    required this.icon,
    required this.onTap,
    this.showBacking = true,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 5,right: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: showBacking
              ? (isDark ? Colors.black.withOpacity(0.45) : Colors.white.withOpacity(0.9))
              : Colors.transparent,
          boxShadow: showBacking
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Icon(
              icon,
              size: size * 0.45,
              color: showBacking
                  ? (isDark ? Colors.white : Colors.black87)
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}