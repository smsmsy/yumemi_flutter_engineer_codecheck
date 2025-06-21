import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        );
      },
    );
