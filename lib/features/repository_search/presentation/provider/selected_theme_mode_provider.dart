import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'selected_theme_mode_provider.g.dart';

@riverpod
class SelectedThemeMode extends _$SelectedThemeMode {
  @override
  Future<ThemeMode> build() async {
    final prefs = SharedPreferencesAsync();
    final modeIndex = await prefs.getInt('theme_mode');
    if (modeIndex != null) {
      return ThemeMode.values[modeIndex];
    }
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncValue.data(mode);
    final prefs = SharedPreferencesAsync();
    await prefs.setInt('theme_mode', mode.index);
  }
}
