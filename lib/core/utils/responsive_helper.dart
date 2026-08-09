// lib/core/utils/responsive_helper.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ResponsiveHelper {
  // ─── Web detection ──────────────────────────────────────────────────
  static bool isWeb() => kIsWeb;

  // ─── Mobile (phone) detection ──────────────────────────────────────
  static bool isMobilePhone() {
    // On non‑web platforms, we assume it's a phone unless proven otherwise.
    // For more accuracy, you can check screen size as well.
    if (!kIsWeb) return true;
    // On web, we rely on width (see below)
    return false;
  }

  // ─── Responsive breakpoints using BuildContext ────────────────────
  static bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 650 || !kIsWeb; // non‑web is treated as mobile
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 650 && width < 1300;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 1300;
  }

  // ─── Optional: get device type as enum ────────────────────────────
  static DeviceType getDeviceType(BuildContext context) {
    if (isDesktop(context)) return DeviceType.desktop;
    if (isTablet(context)) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

enum DeviceType { mobile, tablet, desktop }