import 'dart:ui';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/utils/load_necessary_data.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GoToLogIn extends ConsumerWidget  {
  final IconData icon;
  final String label;

  const GoToLogIn({
    super.key,
    this.icon = Icons.lock_outline_rounded,
    required this.label,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final double iconSize = context.responsive(mobile: 30, tablet: 30, desktop: 40);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingSizeLarge,
        ),
        child: Container(
          width: context.isDesktop
              ? 400
              : context.isTablet
                  ? 350
                  : 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.radiusExtraLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.radiusExtraLarge),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: EdgeInsets.all(context.paddingSizeExtraLarge),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.white.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(context.radiusExtraLarge),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.12)
                        : Colors.white.withOpacity(0.7),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Frosted Icon Badge
                    Container(
                      padding: EdgeInsets.all(context.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: colorScheme.primary,
                      ),
                    ),

                    SizedBox(height: context.paddingSizeDefault),

                    // Title Header
                    Text(
                      'Authentication Required',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: context.fontSizeLarge,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Label Subtitle
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: context.fontSizeSmall,
                      ),
                    ),

                    SizedBox(height: context.paddingSizeLarge),

                    // Glassmorphic Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: ()async{
                         final result = await context.pushNamed(AppRoutesName.login);
                         if(result == true){
                           await loadNecessaryData(ref);
                         }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                          colorScheme.primary.withOpacity(0.88),
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(context.radiusDefault),
                          ),
                        ),
                        icon: const Icon(
                          Icons.login_rounded,
                          size: 18,
                        ),
                        label: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: context.fontSizeDefault,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}