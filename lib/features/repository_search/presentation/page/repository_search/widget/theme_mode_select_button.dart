import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/selected_theme_mode_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// テーマモードを選択するためのボタンウィジェットです。
///
/// このウィジェットは、ユーザーがシステム・ライト・ダークのテーマモードを選択できるポップアップメニューを提供します。
class ThemeModeSelectButton extends ConsumerWidget {
  /// ThemeModeSelectButtonのコンストラクタ。
  ///
  /// [key]はウィジェットの一意性を識別するために使用されます。
  const ThemeModeSelectButton({super.key});

  /// テーマモード選択用のポップアップメニューを構築します。
  ///
  /// ユーザーがテーマモードを選択すると、選択内容が状態管理プロバイダーに反映されます。
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(selectedThemeModeProvider);
    return PopupMenuButton<ThemeMode>(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ThemeMode.system,
            child: Text(
              AppLocalizations.of(context)?.themeModeSystem ??
                  WordingData.themeModeSystem,
            ),
          ),
          PopupMenuItem(
            value: ThemeMode.light,
            child: Text(
              AppLocalizations.of(context)?.themeModeLight ??
                  WordingData.themeModeLight,
            ),
          ),
          PopupMenuItem(
            value: ThemeMode.dark,
            child: Text(
              AppLocalizations.of(context)?.themeModeDark ??
                  WordingData.themeModeDark,
            ),
          ),
        ];
      },
      onSelected: (mode) async {
        await ref.read(selectedThemeModeProvider.notifier).setThemeMode(mode);
      },
      initialValue: themeMode.value ?? ThemeMode.system,
      child: ListTile(
        leading: const Icon(Icons.brightness_6),
        title: Text(
          AppLocalizations.of(context)?.themeModeSelect ??
              WordingData.themeModeSelect,
        ),
      ),
    );
  }
}
