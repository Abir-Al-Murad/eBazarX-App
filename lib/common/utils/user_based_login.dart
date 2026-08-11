import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<bool> userBasedNavigation(
    WidgetRef ref,
    BuildContext context,
    ) async {
  final accessToken = AuthStorage.accessToken;

  if (accessToken == null) {
    return false;
  }

  try {
    await ref.read(profileNotifierProvider.notifier).fetchProfile();
    final profile = ref.read(profileNotifierProvider).profile;

    if (profile == null) {
      return false;
    }

    if (!context.mounted) {
      return false;
    }

    switch (profile.role) {
      case 'admin':
        context.goNamed(
          AppRoutesName.adminDashboard,
        );
        return true;

      case 'seller':
        context.goNamed(
          AppRoutesName.sellerDashboard,
        );
        return true;

      default:
        context.canPop()?context.pop(true):
        context.goNamed(
          AppRoutesName.widgetTree,
        );
        return true;
    }
  } catch (e) {
    debugPrint('User based navigation error: $e');
    return false;
  }
}