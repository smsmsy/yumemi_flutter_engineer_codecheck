import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'selected_theme_mode_provider.g.dart';

/// 選択されたテーマモードを管理するRiverpodのStateNotifierクラスです。
///
/// ユーザーが選択したテーマモード（ライト・ダーク・システム）を永続化し、
/// アプリ全体で一貫したテーマ設定を提供します。
@riverpod
class SelectedThemeMode extends _$SelectedThemeMode {
  @override
  /// 保存されたテーマモードを取得します。
  ///
  /// SharedPreferencesから保存済みのテーマモードを読み込み、
  /// 未設定の場合はシステムのテーマモードを返します。
  Future<ThemeMode> build() async {
    final prefs = SharedPreferencesAsync();
    final modeIndex = await prefs.getInt('theme_mode');
    if (modeIndex != null) {
      return ThemeMode.values[modeIndex];
    }
    return ThemeMode.system;
  }

  /// テーマモードを保存し、状態を更新します。
  ///
  /// [mode]で指定されたテーマモードをSharedPreferencesに保存し、
  /// StateNotifierの状態も即座に更新します。
  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncValue.data(mode);
    final prefs = SharedPreferencesAsync();
    await prefs.setInt('theme_mode', mode.index);
  }
}
