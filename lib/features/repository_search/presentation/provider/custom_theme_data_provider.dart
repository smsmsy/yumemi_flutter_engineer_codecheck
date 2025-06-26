import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Brightnessに応じたカスタムテーマを提供するProviderFamilyです。
///
/// このProviderFamilyは、指定された[Brightness]（明るさ）に基づいて、
/// アプリ全体で使用する[ThemeData]を生成します。
/// テキストフィールドやAppBarなどのテーマ設定も含まれています。
final ProviderFamily<ThemeData, Brightness> customThemeDataProvider =
    Provider.family<ThemeData, Brightness>(
      (ref, brightness) {
        final colorScheme = ColorScheme.fromSeed(
          brightness: brightness,
          seedColor: const Color(0xFF1158c7),
        );
        return ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,

          // テキストフィールド類のテーマ設定を行う
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIconColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return colorScheme.primary;
              }
              return colorScheme.secondary;
            }),
          ),

          // AppBarのテーマ設定を行う
          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            titleTextStyle: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            // ステータスバーの色とアイコンの明るさを設定
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: colorScheme.surface,
              statusBarIconBrightness: brightness,
              statusBarBrightness: brightness,
            ),
            // ボディをスクロールしたとしても背景の色が変わらないようにする
            scrolledUnderElevation: 0,
          ),
        );
      },
    );
