import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ProviderFamily<ThemeData, Brightness> customThemeDataProvider =
    Provider.family<ThemeData, Brightness>(
      (ref, brightness) {
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            brightness: brightness,
            seedColor: const Color(0xFF1158c7),
          ),
        );
      },
    );
