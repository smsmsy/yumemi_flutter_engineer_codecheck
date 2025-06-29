import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/search_history_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/number_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// 検索履歴リスト部分のウィジェット。
///
/// 検索履歴のリストを表示し、履歴項目のタップ時に[onHistoryTap]が呼ばれます。
class SearchHistoryListView extends ConsumerStatefulWidget {
  /// 検索履歴リストのコンストラクタ。
  ///
  /// [onHistoryTap]は履歴の文字列を引数に取り、タップ時に呼び出されます。
  const SearchHistoryListView({required this.onHistoryTap, super.key});

  /// 検索履歴の項目がタップされたときに呼ばれるコールバック。
  final void Function(String) onHistoryTap;

  /// Stateを生成します。
  @override
  ConsumerState<SearchHistoryListView> createState() =>
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
class _SearchHistoryListViewState extends ConsumerState<SearchHistoryListView> {
  final _scrollController = ScrollController();
  final _listKey = GlobalKey<AnimatedListState>();
  List<String> _oldHistory = [];

  static const _animationDuration = Duration(milliseconds: 150);

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(searchHistoryProvider);
    return Expanded(
      child: historyAsync.when(
        data: (history) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateAnimatedList(history);
          });
          // AnimatedListStateがまだ取得できていない場合は、_oldHistoryをhistoryで初期化
          if (_listKey.currentState == null &&
              _oldHistory.length != history.length) {
            _oldHistory = List.from(history);
          }
          if (_oldHistory.isEmpty) {
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
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              initialItemCount: _oldHistory.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                  child: _SearchHistoryListItem(
                    index: index,
                    value: _oldHistory[index],
                    onHistoryTap: widget.onHistoryTap,
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  void _updateAnimatedList(List<String> newHistory) {
    final listState = _listKey.currentState;
    if (listState == null) {
      _oldHistory = List.from(newHistory);
      return;
    }
    // 差分検出
    final old = List<String>.from(_oldHistory);
    final newList = List<String>.from(newHistory);
    // 削除
    for (var i = old.length - 1; i >= 0; i--) {
      if (!newList.contains(old[i])) {
        listState.removeItem(
          i,
          (context, animation) => SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: _SearchHistoryListItem(
              index: i,
              value: old[i],
              onHistoryTap: widget.onHistoryTap,
            ),
          ),
          duration: _animationDuration,
        );
        _oldHistory.removeAt(i);
      }
    }
    // 追加
    for (var i = 0; i < newList.length; i++) {
      if (i >= _oldHistory.length || _oldHistory[i] != newList[i]) {
        _oldHistory.insert(i, newList[i]);
        listState.insertItem(i, duration: _animationDuration);
      }
    }
    // 長さ調整
    if (_oldHistory.length > newList.length) {
      _oldHistory = List.from(newList);
    }
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
          if (!context.mounted || !ref.context.mounted) {
            return;
          }
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
