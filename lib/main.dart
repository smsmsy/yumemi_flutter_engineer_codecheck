import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/custom_theme_data_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/go_router_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/selected_theme_mode_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(selectedThemeModeProvider);
    return MaterialApp.router(
      title: WordingData.applicationName,
      theme: ref.watch(customThemeDataProvider(Brightness.light)),
      darkTheme: ref.watch(customThemeDataProvider(Brightness.dark)),
      themeMode: themeMode.value ?? ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
