import 'package:ebazarx/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:ebazarx/features/profile/presentation/widgets/role_badge.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user_profile_entity.dart';


class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          children: [
            ProfileAvatar(
              imageUrl: profile.profileImage,
              initials: profile.initials,
              onEditTap: onEditProfile,
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    profile.fullName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (profile.isVerified) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.verified_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(
              profile.email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (profile.phone != null && profile.phone!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                profile.phone!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoleBadge(role: profile.role),
                const SizedBox(width: 8),
                _ActiveIndicator(isActive: profile.isActive),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveIndicator extends StatelessWidget {
  final bool isActive;

  const _ActiveIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Swap for your semantic AppColors.success / AppColors.error if available.
    final color = isActive ? Colors.green : theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 5),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}