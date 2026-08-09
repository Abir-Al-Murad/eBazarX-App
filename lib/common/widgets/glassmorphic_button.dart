import 'dart:ui';

import 'package:ebazarx/common/utils/styles.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class GlassmorphicButton extends StatelessWidget {
  const GlassmorphicButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.height = 52,
    this.blurSigma = 14,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final double height;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final tint = colors.onSurface;
    final primary = colors.primary;
    final content = enabled ? tint: tint.withValues(alpha: 0.4);
    return ClipRRect(
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: blurSigma,sigmaY:  blurSigma),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: context.paddingSizeDefault),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.radiusExtraLarge),
              border: Border.all(color: content.withOpacity(enabled?0.18:0.08)),
              gradient: LinearGradient(
                  begin: Alignment.topLeft
                  ,end: Alignment.bottomRight,
                  colors: [
                primary.withValues(alpha: enabled?0.14:0.06),
                primary.withValues(alpha: enabled?0.04:0.02),
              ])
            ),
            child: Row(
              children: [
                Icon(icon,color: content,size: 18,),
                SizedBox(width: context.paddingSizeSmall),
                Text(
                  label,
                  style: context.medium.copyWith(
                    color: content,
                  ),
                ),
                // SizedBox()
              ],
            ),
          ),
        ),
      ),),
    );
  }
}
