import 'package:ebazarx/theme/app_radius.dart';
import 'package:ebazarx/theme/app_spacing.dart';
import 'package:ebazarx/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; // adjust import path as needed

ThemeData lightTheme = ThemeData(
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: AppColors.primary,
  primaryColorDark: AppColors.primaryDark,
  primaryColorLight: AppColors.primary.withOpacity(0.1), // light variant for backgrounds
  secondaryHeaderColor: AppColors.secondary,
  scaffoldBackgroundColor: AppColors.background,
  cardColor: AppColors.surface,
  dividerColor: AppColors.border,
  disabledColor: AppColors.border,

  // ─── Color Scheme ──────────────────────────────────────────────
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.primary.withOpacity(0.12),
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondary.withOpacity(0.12),
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
    brightness: Brightness.light,
  ),

  // ─── Text Theme ────────────────────────────────────────────────
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: AppTypography.displayLarge,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: AppTypography.displayMedium,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: AppTypography.displaySmall,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: AppTypography.headlineMedium,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: AppTypography.headlineSmall,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: AppTypography.titleLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: AppTypography.titleMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: AppTypography.titleSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
    bodyLarge: TextStyle(
      fontSize: AppTypography.bodyLarge,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: AppTypography.bodyMedium,
      color: AppColors.textPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: AppTypography.bodySmall,
      color: AppColors.textSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: AppTypography.labelLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: AppTypography.labelMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: AppTypography.labelSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
  ),

  // ─── AppBar Theme ──────────────────────────────────────────────
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: const TextStyle(
      fontSize: AppTypography.headlineMedium,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white),
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
        borderRadius: BorderRadius.circular(AppRadius.sm),
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
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: const BorderSide(color: AppColors.border),
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
      color: AppColors.textSecondary,
    ),
    hintStyle: const TextStyle(
      fontSize: AppTypography.bodyMedium,
      color: AppColors.textSecondary,
    ),
    prefixIconColor: AppColors.textSecondary,
    suffixIconColor: AppColors.textSecondary,
  ),

  // ─── Card Theme ──────────────────────────────────────────────────
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.xl),
    ),
    margin:const EdgeInsets.all(AppSpacing.sm),
  ),

  // ─── Dialog Theme ───────────────────────────────────────────────
  dialogTheme: const DialogThemeData(
    backgroundColor: AppColors.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.xxl)),
    ),
  ),

  // ─── SnackBar Theme ─────────────────────────────────────────────
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: AppColors.textPrimary,
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
    ),
  ),

  // ─── Chip Theme ──────────────────────────────────────────────────
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surface,
    selectedColor: AppColors.primary,
    disabledColor: AppColors.border,
    labelStyle: const TextStyle(color: AppColors.textPrimary),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      side: const BorderSide(color: AppColors.border),
    ),
  ),

  // ─── Divider Theme ──────────────────────────────────────────────
  dividerTheme: const DividerThemeData(
    color: AppColors.border,
    thickness: 1,
    space: AppSpacing.md,
  ),

  // ─── Icon Theme ──────────────────────────────────────────────────
  iconTheme: const IconThemeData(
    color: AppColors.textPrimary,
    size: 24,
  ),

  // ─── Progress Indicator Theme ──────────────────────────────────
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.border,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.surface,
    indicatorColor: AppColors.primary.withOpacity(.12),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
    ),
  ),
);