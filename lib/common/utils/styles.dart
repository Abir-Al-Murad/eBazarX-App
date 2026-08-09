import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';
import 'app_constants.dart';

extension ResponsiveTextStyle on BuildContext {
  // ─── Regular (w400) ──────────────────────────
  TextStyle get regular {
    return const TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w400,
    ).copyWith(fontSize: fontSizeDefault);
  }

  // ─── Medium (w500) ──────────────────────────
  TextStyle get medium {
    return const TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w500,
    ).copyWith(fontSize: fontSizeDefault);
  }

  // ─── Bold (w700) ─────────────────────────────
  TextStyle get bold {
    return const TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w700,
    ).copyWith(fontSize: fontSizeDefault);
  }

  // ─── Black (w900) ────────────────────────────
  TextStyle get black {
    return const TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w900,
    ).copyWith(fontSize: fontSizeDefault);
  }

}