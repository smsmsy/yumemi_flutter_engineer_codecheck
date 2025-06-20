import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/provider/selected_theme_mode_provider.dart';

class ThemeModeSelectButton extends ConsumerWidget {
  const ThemeModeSelectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(selectedThemeModeProvider);
    return PopupMenuButton<ThemeMode>(
      icon: const Icon(Icons.brightness_6),
      onSelected: (mode) async {
        await ref.read(selectedThemeModeProvider.notifier).setThemeMode(mode);
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: ThemeMode.system,
              child: Text('System'),
            ),
            const PopupMenuItem(
              value: ThemeMode.light,
              child: Text('Light'),
            ),
            const PopupMenuItem(
              value: ThemeMode.dark,
              child: Text('Dark'),
            ),
          ],
      initialValue: themeMode.value ?? ThemeMode.system,
    );
  }
}
