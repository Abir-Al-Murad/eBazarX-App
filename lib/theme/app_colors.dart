import 'dart:ui';

class AppColors {
  // Brand
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color secondary = Color(0xFF10B981); // Emerald

  // Background
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  // ============================================================
  // STATUS & BORDER (Refined Palette)
  // ============================================================

  // Success (Vibrant, high-contrast Emerald-Green)
  // Replaced generic green with a warmer, rich green that pops nicely on 12% opacity overlays.
  static const Color success = Color(0xFF10B981);

  // Error (Clean, non-harsh Crimson)
  // Balanced red that conveys urgency without visual fatigue.
  static const Color error = Color(0xFFF43F5E);

  // Warning (Warm Amber/Honey)
  // Adjusted hue away from harsh yellow toward warm amber for crisp text readability.
  static const Color warning = Color(0xFFF59E0B);

  // Pending (Deep Royal Indigo-Violet)
  // Slightly shifted from pure violet to harmonize with your primary indigo brand token.
  static const Color pending = Color(0xFF6366F1);

  // Draft (Vibrant Slate Teal)
  // Shifted to a rich ocean teal to differentiate clearly from grey archived states.
  static const Color draft = Color(0xFF0284C7);

  // Archived / Inactive (Neutral Slate)
  // Uses a neutral grey tone matching your secondary text palette.
  static const Color archived = Color(0xFF64748B);

  // Out of Stock (Rich Rose Magenta)
  // Deep berry-rose hue that signals stock unavailability clearly without looking like an error red.
  static const Color outOfStock = Color(0xFFE11D48);

  // Border (Soft Slate Border)
  static const Color border = Color(0xFFE2E8F0);
}