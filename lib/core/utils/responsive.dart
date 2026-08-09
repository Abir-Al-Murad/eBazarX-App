// lib/core/utils/responsive.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

extension ResponsiveSizing on BuildContext {
  // ─── Screen dimensions ──────────────────────────────────────────────
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // ─── Web detection ──────────────────────────────────────────────────
  bool get isWeb => kIsWeb;

  // ─── Font sizes (adaptive) ─────────────────────────────────────────
  double get fontSizeExtraSmall => screenWidth >= 1300 ? 12 : 10;
  double get fontSizeSmall      => screenWidth >= 1300 ? 14 : 12;
  double get fontSizeDefault    => screenWidth >= 1300 ? 16 : 14;
  double get fontSizeLarge      => screenWidth >= 1300 ? 18 : 16;
  double get fontSizeExtraLarge => screenWidth >= 1300 ? 20 : 18;
  double get fontSizeOverLarge  => screenWidth >= 1300 ? 26 : 24;

  // ─── Spacing / Padding ──────────────────────────────────────────────
  double get paddingSizeExtraSmall => 5.0;
  double get paddingSizeSmall      => 10.0;
  double get paddingSizeDefault    => 15.0;
  double get paddingSizeLarge      => 20.0;
  double get paddingSizeExtraLarge => 25.0;
  double get paddingSizeOverLarge  => 30.0;
  double get paddingSizeExtraOverLarge => 35.0;

  // ─── Border radius ──────────────────────────────────────────────────
  double get radiusSmall      => 5.0;
  double get radiusDefault    => 10.0;
  double get radiusLarge      => 15.0;
  double get radiusExtraLarge => 20.0;

  // ─── Breakpoints (replacing the static helper) ─────────────────────
  bool get isMobile  => screenWidth < 650 || !kIsWeb;
  bool get isTablet  => screenWidth >= 650 && screenWidth < 1300;
  bool get isDesktop => screenWidth >= 1300;

  // ─── Get device type as enum ───────────────────────────────────────
  DeviceType get deviceType {
    if (isDesktop) return DeviceType.desktop;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  // ─── Convenience: responsive value based on device type ───────────
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

enum DeviceType { mobile, tablet, desktop }