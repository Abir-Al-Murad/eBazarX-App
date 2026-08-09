// lib/core/utils/app_snackbar.dart
import 'package:flutter/material.dart';
import 'package:ebazarx/common/utils/styles.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/theme/app_colors.dart';

enum _SnackType { success, error, warning, info }

/// Central snackbar utility. One consistent visual style, one API,
/// callable from anywhere — including places without a `BuildContext`
/// (Riverpod notifiers, repositories, error interceptors) via the
/// global [AppSnackBar.messengerKey].
///
/// Setup: attach the key once in your MaterialApp —
/// ```dart
/// MaterialApp.router(
///   scaffoldMessengerKey: AppSnackbar.messengerKey,
///   ...
/// )
/// ```
/// After that, `AppSnackBar.success('Saved')` works from any layer.
class AppSnackBar {
  AppSnackBar._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
  GlobalKey<ScaffoldMessengerState>();

  /// Prefer the context-taking variant when you have one on hand (it
  /// correctly resolves theme colors for that context's Localizations/
  /// Theme scope); this falls back to it when available, and to the
  /// global messenger key otherwise.
  static ScaffoldMessengerState? _resolveMessenger(BuildContext? context) {
    if (context != null) {
      try {
        return ScaffoldMessenger.of(context);
      } catch (_) {
        // No ScaffoldMessenger ancestor for this context — fall through.
      }
    }
    return messengerKey.currentState;
  }

  static void success(String message, {BuildContext? context, SnackBarAction? action}) {
    _show(context, message, _SnackType.success, action: action);
  }

  static void error(String message, {BuildContext? context, SnackBarAction? action}) {
    _show(context, message, _SnackType.error, action: action, duration: const Duration(seconds: 4));
  }

  static void warning(String message, {BuildContext? context, SnackBarAction? action}) {
    _show(context, message, _SnackType.warning, action: action);
  }

  static void info(String message, {BuildContext? context, SnackBarAction? action}) {
    _show(context, message, _SnackType.info, action: action);
  }

  /// Hides whatever snackbar is currently showing, if any.
  static void dismiss({BuildContext? context}) {
    _resolveMessenger(context)?.hideCurrentSnackBar();
  }

  static void _show(
      BuildContext? context,
      String message,
      _SnackType type, {
        SnackBarAction? action,
        Duration duration = const Duration(seconds: 3),
      }) {
    final messenger = _resolveMessenger(context);
    if (messenger == null) return; // no app shell mounted yet — fail quietly

    // Use the messenger's own context so theme resolves correctly even
    // when this was called from a code path with no context at all.
    final resolvedContext = context ?? messengerKey.currentContext;
    if (resolvedContext == null) return;

    final theme = Theme.of(resolvedContext);
    final config = _configFor(type);

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: theme.brightness == Brightness.dark?Colors.white:Colors.black,
          elevation: 6,
          margin: EdgeInsets.symmetric(
            horizontal: resolvedContext.paddingSizeDefault,
            vertical: resolvedContext.paddingSizeSmall,
          ),
          padding: EdgeInsets.all(resolvedContext.paddingSizeSmall),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(resolvedContext.radiusDefault),
            side: BorderSide(color: theme.dividerColor),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: config.color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(config.icon, size: 17, color: config.color),
              ),
              SizedBox(width: resolvedContext.paddingSizeSmall),
              Expanded(
                child: Text(
                  message,
                  style: resolvedContext.medium.copyWith(
                    fontSize: resolvedContext.fontSizeSmall,
                    color: theme.brightness == Brightness.dark?Colors.black:Colors.white,
                  ),
                ),
              ),
            ],
          ),
          action: action,
        ),
      );
  }

  static _SnackConfig _configFor(_SnackType type) {
    switch (type) {
      case _SnackType.success:
        return _SnackConfig(AppColors.success, Icons.check_circle_rounded);
      case _SnackType.error:
        return _SnackConfig(AppColors.error, Icons.error_rounded);
      case _SnackType.warning:
        return _SnackConfig(AppColors.warning, Icons.warning_rounded);
      case _SnackType.info:
        return const _SnackConfig(Color(0xFF3B82F6), Icons.info_rounded);
    }
  }
}

class _SnackConfig {
  final Color color;
  final IconData icon;
  const _SnackConfig(this.color, this.icon);
}