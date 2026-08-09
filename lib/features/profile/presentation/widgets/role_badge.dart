import 'package:flutter/material.dart';

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  _RoleStyle _styleFor(String role, ThemeData theme) {
    switch (role.toLowerCase()) {
      case 'seller':
        return _RoleStyle(
          bg: Colors.orange.withOpacity(0.12),
          fg: Colors.orange.shade800,
          icon: Icons.storefront_rounded,
          label: 'Seller',
        );
      case 'admin':
        return _RoleStyle(
          bg: theme.colorScheme.primary.withOpacity(0.12),
          fg: theme.colorScheme.primary,
          icon: Icons.admin_panel_settings_rounded,
          label: 'Admin',
        );
      default:
        return _RoleStyle(
          bg: theme.colorScheme.secondary.withOpacity(0.12),
          fg: theme.colorScheme.secondary,
          icon: Icons.person_rounded,
          label: 'Customer',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = _styleFor(role, theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 13, color: style.fg),
          const SizedBox(width: 4),
          Text(
            style.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: style.fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleStyle {
  final Color bg;
  final Color fg;
  final IconData icon;
  final String label;

  const _RoleStyle({
    required this.bg,
    required this.fg,
    required this.icon,
    required this.label,
  });
}