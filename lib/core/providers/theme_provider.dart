// core/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ─── Secure storage key ──────────────────────────────────────────────
const String _themePrefKey = "app_theme_mode";

// ─── ThemeModeNotifier (StateNotifier) ──────────────────────────────
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadSavedThemeMode();
  }

  Future<void> _loadSavedThemeMode() async {
    const storage = FlutterSecureStorage();
    final saved = await storage.read(key: _themePrefKey);
    if (saved != null) {
      state = _fromString(saved);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    const storage = FlutterSecureStorage();
    await storage.write(key: _themePrefKey, value: mode.toString());
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  ThemeMode _fromString(String value) {
    switch (value) {
      case "ThemeMode.light":
        return ThemeMode.light;
      case "ThemeMode.dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

// ─── Riverpod Provider ──────────────────────────────────────────────
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});