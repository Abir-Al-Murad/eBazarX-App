import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';          // adjust import as needed
import 'app_typography.dart';      // AppTypography
import 'app_spacing.dart';         // AppSpacing
import 'app_radius.dart';          // AppRadius

// Dark‑mode color constants (you can move these to AppColors if you prefer)
const _darkBackground = Color(0xFF121212);
const _darkSurface = Color(0xFF1E1E1E);
const _darkBorder = Color(0xFF2C2C2C);
const _darkTextPrimary = Color(0xFFECECEC);
const _darkTextSecondary = Color(0xFFA0A0A0);

ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.dark,
  useMaterial3: true,
  primaryColor: AppColors.primary,
  primaryColorDark: AppColors.primaryDark,
  primaryColorLight: AppColors.primary.withOpacity(0.1),
  secondaryHeaderColor: AppColors.secondary,
  scaffoldBackgroundColor: _darkBackground,
  cardColor: _darkSurface,
  dividerColor: _darkBorder,
  disabledColor: _darkBorder,

  // ─── Color Scheme ──────────────────────────────────────────────
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    primaryContainer: AppColors.primary.withOpacity(0.24),
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondary.withOpacity(0.24),
    surface: _darkSurface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: _darkTextPrimary,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),

  // ─── Text Theme ────────────────────────────────────────────────
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: AppTypography.displayLarge,
      fontWeight: FontWeight.w700,
      color: _darkTextPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: AppTypography.displayMedium,
      fontWeight: FontWeight.w700,
      color: _darkTextPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: AppTypography.displaySmall,
      fontWeight: FontWeight.w600,
      color: _darkTextPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: AppTypography.headlineMedium,
      fontWeight: FontWeight.w600,
      color: _darkTextPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: AppTypography.headlineSmall,
      fontWeight: FontWeight.w600,
      color: _darkTextPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: AppTypography.titleLarge,
      fontWeight: FontWeight.w600,
      color: _darkTextPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: AppTypography.titleMedium,
      fontWeight: FontWeight.w500,
      color: _darkTextPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: AppTypography.titleSmall,
      fontWeight: FontWeight.w500,
      color: _darkTextSecondary,
    ),
    bodyLarge: TextStyle(
      fontSize: AppTypography.bodyLarge,
      color: _darkTextPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: AppTypography.bodyMedium,
      color: _darkTextPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: AppTypography.bodySmall,
      color: _darkTextSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: AppTypography.labelLarge,
      fontWeight: FontWeight.w600,
      color: _darkTextPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: AppTypography.labelMedium,
      fontWeight: FontWeight.w500,
      color: _darkTextSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: AppTypography.labelSmall,
      fontWeight: FontWeight.w500,
      color: _darkTextSecondary,
    ),
  ),

  // ─── AppBar Theme ──────────────────────────────────────────────
  appBarTheme: AppBarTheme(
    backgroundColor: _darkSurface,
    foregroundColor: _darkTextPrimary,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: const TextStyle(
      fontSize: AppTypography.headlineMedium,
      fontWeight: FontWeight.w600,
      color: _darkTextPrimary,
    ),
    iconTheme: const IconThemeData(color: _darkTextPrimary),
  ),

  // ─── Button Themes ──────────────────────────────────────────────
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      textStyle: const TextStyle(
        fontSize: AppTypography.labelLarge,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      textStyle: const TextStyle(
        fontSize: AppTypography.labelLarge,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(
        fontSize: AppTypography.labelLarge,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // ─── Input Decoration Theme ────────────────────────────────────
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _darkSurface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: _darkBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: _darkBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    labelStyle: const TextStyle(
      fontSize: AppTypography.bodyMedium,
      color: _darkTextSecondary,
    ),
    hintStyle: const TextStyle(
      fontSize: AppTypography.bodyMedium,
      color: _darkTextSecondary,
    ),
    prefixIconColor: _darkTextSecondary,
    suffixIconColor: _darkTextSecondary,
  ),

  // ─── Card Theme ──────────────────────────────────────────────────
  cardTheme: CardThemeData(
    color: _darkSurface,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.xl),
    ),
    margin: const EdgeInsets.all(AppSpacing.sm),
  ),

  // ─── Dialog Theme ───────────────────────────────────────────────
  dialogTheme: DialogThemeData(
    backgroundColor: _darkBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.xxl)),
    ),
  ),

  // ─── SnackBar Theme ─────────────────────────────────────────────
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _darkTextPrimary,
    contentTextStyle: const TextStyle(color: _darkBackground),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
  ),

  // ─── Chip Theme ──────────────────────────────────────────────────
  chipTheme: ChipThemeData(
    backgroundColor: _darkSurface,
    selectedColor: AppColors.primary,
    disabledColor: _darkBorder,
    labelStyle: const TextStyle(color: _darkTextPrimary),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      side: const BorderSide(color: _darkBorder),
    ),
  ),

  // ─── Divider Theme ──────────────────────────────────────────────
  dividerTheme: const DividerThemeData(
    color: _darkBorder,
    thickness: 1,
    space: AppSpacing.md,
  ),

  // ─── Icon Theme ──────────────────────────────────────────────────
  iconTheme: const IconThemeData(
    color: _darkTextPrimary,
    size: 24,
  ),

  // ─── Progress Indicator Theme ──────────────────────────────────
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: _darkBorder,
  ),

  // ─── Navigation Bar Theme ──────────────────────────────────────
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: _darkSurface,
    indicatorColor: AppColors.primary.withOpacity(0.24),
  ),

  // ─── Floating Action Button Theme ──────────────────────────────
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),

  // ─── Bottom Sheet Theme ────────────────────────────────────────
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
    ),
  ),
);