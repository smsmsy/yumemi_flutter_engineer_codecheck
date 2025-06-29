import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/search_history_list_view.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/show_oss_license_button.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/theme_mode_select_button.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/search_history_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/number_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// 検索履歴やテーマ切り替えなどを含むカスタムドロワーウィジェット。
///
/// 検索履歴のリスト表示やテーマモードの切り替え、OSSライセンス表示ボタンを含みます。
class CustomDrawer extends ConsumerWidget {
  /// 検索履歴の項目がタップされたときに呼ばれるコールバックを受け取るコンストラクタ。
  ///
  /// [onHistoryTap]は履歴の文字列を引数に取り、タップ時に呼び出されます。
  const CustomDrawer({required this.onHistoryTap, super.key});

  /// 検索履歴の項目がタップされたときに呼ばれるコールバック。
  final void Function(String) onHistoryTap;

  /// ドロワーのUIを構築します。
  ///
  /// 検索履歴リストやテーマ切り替えボタンなどを表示します。
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      right: false,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: NumberData.paddingSmall,
          ),
          child: Column(
            children: <Widget>[
              const _SearchHistoryTitle(),
              SearchHistoryListView(
                onHistoryTap: onHistoryTap,
              ),
              const Divider(),
              const ThemeModeSelectButton(),
              const ShowOssLicenseButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<void Function(String)>.has(
        'onHistoryTap',
        onHistoryTap,
      ),
    );
  }
}

/// 検索履歴タイトル部分のウィジェット。
class _SearchHistoryTitle extends StatelessWidget {
  /// デフォルトコンストラクタ。
  const _SearchHistoryTitle();

  /// タイトル行のUIを構築します。
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.history),
            title: Text(
              AppLocalizations.of(context)?.searchHistory ??
                  WordingData.searchHistory,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (kDebugMode) const _ApplyTestDataButton(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}


/// テスト用の検索履歴データを適用するボタンウィジェット。
class _ApplyTestDataButton extends ConsumerWidget {
  /// デフォルトコンストラクタ。
  const _ApplyTestDataButton();

  /// テストデータを履歴に追加するボタンのUIを構築します。
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        if (!context.mounted || !ref.context.mounted) {
          return;
        }
        const searchHistories = [
          'flutter riverpod',
          'yumemi',
          'flutter yumemi',
          'yumemi flutter engineer codecheck repository search',
          'flutter yumemi',
          'yumemi engineer',
          'yumemi engineer codecheck',
          'jest',
          'react testing library',
          'flutter testing',
          'flutter test',
          'freezed',
          'json serialization',
          'yumemi flutter engineer codecheck',
          'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW',
        ];
        await ref.read(searchHistoryProvider.notifier).clear();
        for (final s in searchHistories) {
          await ref.read(searchHistoryProvider.notifier).add(s);
        }
      },
      icon: const Icon(Icons.recycling),
    );
  }
}
