import 'package:ebazarx/common/utils/styles.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import '../../core/failures/failure.dart';

class ErrorView extends StatelessWidget {
  final Failure failure;
  final VoidCallback onRetry;
  final String? customTitle;
  final String? customMessage;

  const ErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
    this.customTitle,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorDetails = _getErrorDetails(failure);

    final title = customTitle ?? errorDetails.title;
    final message = customMessage ?? errorDetails.message;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingSizeLarge,
          vertical: context.paddingSizeDefault,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Decorative Icon Container
            Container(
              padding: EdgeInsets.all(context.paddingSizeLarge),
              decoration: BoxDecoration(
                color: errorDetails.accentColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: errorDetails.accentColor.withValues(alpha: 0.18),
                  width: 1.5,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(context.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: errorDetails.accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  errorDetails.icon,
                  size: 44,
                  color: errorDetails.accentColor,
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

            // Description Body
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
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

            // Optional Technical Diagnostics (Debug Mode Only)
            if (kDebugMode && failure.message.isNotEmpty && failure.message != message) ...[
              SizedBox(height: context.paddingSizeSmall),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.paddingSizeSmall,
                  vertical: context.paddingSizeExtraSmall,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(context.radiusSmall),
                ),
                child: Text(
                  'Debug: ${failure.message}',
                  style: context.regular.copyWith(
                    fontSize: context.fontSizeExtraSmall,
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            SizedBox(height: context.paddingSizeLarge),

            // Action Button
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Try Again',
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
        ),
      ),
    );
  }

  _ErrorDetail _getErrorDetails(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return _ErrorDetail(
          icon: Icons.wifi_off_rounded,
          accentColor: const Color(0xFFE57373), // Soft Red
          title: 'No Internet Connection',
          message: 'Please check your Wi-Fi or cellular data network and try again.',
        );

      case TimeoutFailure:
        return _ErrorDetail(
          icon: Icons.timer_outlined,
          accentColor: const Color(0xFFFFB74D), // Soft Orange
          title: 'Connection Timed Out',
          message: 'The server took too long to respond. Please check your connection strength.',
        );

      case ServerFailure:
        return _ErrorDetail(
          icon: Icons.cloud_off_rounded,
          accentColor: const Color(0xFFBA68C8), // Soft Purple
          title: 'Server Unavailable',
          message: failure.message.isNotEmpty
              ? failure.message
              : 'Our servers are temporarily down for maintenance. Please try again shortly.',
        );

      default:
        return _ErrorDetail(
          icon: Icons.error_outline_rounded,
          accentColor: const Color(0xFFEF5350),
          title: 'Something Went Wrong',
          message: failure.message.isNotEmpty
              ? failure.message
              : 'An unexpected issue occurred. Please tap retry to try again.',
        );
    }
  }
}

class _ErrorDetail {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String message;

  _ErrorDetail({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.message,
  });
}