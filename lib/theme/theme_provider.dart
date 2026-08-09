
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _themePrefKey = "app_theme_mode";

class ThemeModeNotifier extends StateNotifier<ThemeMode>{
  ThemeModeNotifier() : super(ThemeMode.system){
    _loadSavedThemeMode();
  }

  Future<void> _loadSavedThemeMode()async{
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final savedThemeMode = await storage.read(key: _themePrefKey);
    if(savedThemeMode != null){
      state = _getThemeModeFromString(savedThemeMode);
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode)async{
    state = themeMode;
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.write(key: _themePrefKey, value: themeMode.toString());
  }


  Future<void> toggleTheme()async{
    final newThemeMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newThemeMode);
  }

  ThemeMode _getThemeModeFromString(String themeMode){
    switch(themeMode){
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}