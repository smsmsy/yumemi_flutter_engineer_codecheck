import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              _SearchHistoryListView(
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

/// 検索履歴リスト部分のウィジェット。
///
/// 検索履歴のリストを表示し、履歴項目のタップ時に[onHistoryTap]が呼ばれます。
class _SearchHistoryListView extends ConsumerStatefulWidget {
  /// 検索履歴リストのコンストラクタ。
  ///
  /// [onHistoryTap]は履歴の文字列を引数に取り、タップ時に呼び出されます。
  const _SearchHistoryListView({required this.onHistoryTap});

  /// 検索履歴の項目がタップされたときに呼ばれるコールバック。
  final void Function(String) onHistoryTap;

  /// Stateを生成します。
  @override
  ConsumerState<_SearchHistoryListView> createState() =>
      _SearchHistoryListViewState();

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

/// 検索履歴リストの状態管理クラス。
///
/// スクロールコントローラの管理や、履歴データの監視・表示を行います。
class _SearchHistoryListViewState
    extends ConsumerState<_SearchHistoryListView> {
  /// スクロールコントローラ。
  final _scrollController = ScrollController();

  /// ウィジェット破棄時にコントローラを破棄します。
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  /// 検索履歴リストのUIを構築します。
  ///
  /// 履歴が空の場合はメッセージを表示し、履歴がある場合はリスト表示します。
  @override
  Widget build(BuildContext context) {
    final history = ref.watch(searchHistoryProvider);
    return Expanded(
      child: history.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)?.noSearchHistory ??
                    WordingData.noSearchHistory,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _SearchHistoryListItem(
                  index: index,
                  value: data[index],
                  onHistoryTap: widget.onHistoryTap,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<void Function(String)>.has(
        'onHistoryTap',
        widget.onHistoryTap,
      ),
    );
  }
}

/// 検索履歴リストの各項目ウィジェット。
///
/// 履歴の値や削除ボタン、タップ時の挙動を定義します。
class _SearchHistoryListItem extends ConsumerWidget {
  /// 検索履歴リスト項目のコンストラクタ。
  ///
  /// [index]はリスト内のインデックス、[value]は履歴の値、[onHistoryTap]はタップ時のコールバックです。
  const _SearchHistoryListItem({
    required this.index,
    required this.value,
    required this.onHistoryTap,
  });

  /// リスト内のインデックス。
  final int index;

  /// 履歴の値。
  final String value;

  /// 履歴項目がタップされたときに呼ばれるコールバック。
  final void Function(String) onHistoryTap;

  /// 履歴項目のUIを構築します。
  ///
  /// タップで履歴を選択、削除ボタンで履歴を削除します。
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        NumberData.paddingMedium,
        0,
        NumberData.paddingSmall,
        0,
      ),
      horizontalTitleGap: NumberData.paddingSmall,
      title: Text(
        value,
        maxLines: 2,
        style: Theme.of(context).textTheme.bodySmall,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () async {
          await ref.read(searchHistoryProvider.notifier).removeTo(value);
        },
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      onTap: () {
        onHistoryTap(value);
        Navigator.pop(context);
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('value', value));
    properties.add(
      ObjectFlagProperty<void Function(String)>.has(
        'onHistoryTap',
        onHistoryTap,
      ),
    );
    properties.add(IntProperty('index', index));
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
