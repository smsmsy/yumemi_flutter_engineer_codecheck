import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/search_history_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/number_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// 検索履歴リストを表示するウィジェット。
///
/// 検索履歴のリストをAnimatedListでアニメーション付きで表示します。
/// 履歴が空の場合は「履歴なし」メッセージを表示します。
class SearchHistoryListView extends ConsumerStatefulWidget {
  /// [onHistoryTap]コールバックを受け取るコンストラクタ。
  ///
  /// 検索履歴項目がタップされた際に呼ばれるコールバックを指定します。
  const SearchHistoryListView({required this.onHistoryTap, super.key});

  /// 検索履歴項目がタップされたときに呼ばれるコールバック。
  final void Function(String) onHistoryTap;
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

/// 検索履歴リストの状態を管理するStateクラス。
///
/// AnimatedListの状態管理や履歴リストの同期処理を行います。
class _SearchHistoryListViewState extends ConsumerState<SearchHistoryListView> {
  /// スクロール位置を管理するコントローラー。
  final _scrollController = ScrollController();

  /// AnimatedListの状態を管理するキー。
  final _listKey = GlobalKey<AnimatedListState>();

  /// 内部で保持する履歴リスト。
  List<String> _internalList = [];

  /// 初回ビルドかどうかのフラグ。
  var _firstBuild = true;

  /// アニメーションの継続時間。
  static const _animationDuration = Duration(milliseconds: 150);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 検索履歴リストのUIを構築します。
  ///
  /// RiverpodのProviderから履歴を監視し、AnimatedListで表示します。
  @override
  Widget build(BuildContext context) {
    // 検索履歴のProviderを監視し、更新があればAnimatedListを同期します。
    ref.listen(searchHistoryProvider, (_, history) {
      if (history is AsyncData<List<String>>) {
        _updateAnimatedList(history.requireValue);
      }
    });
    final historyAsync = ref.watch(searchHistoryProvider);
    return Expanded(
      child: historyAsync.when(
        data: (history) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateAnimatedList(history);
          });
          if (_internalList.isEmpty) {
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
              initialItemCount: _internalList.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                  child: _SearchHistoryListItem(
                    index: index,
                    value: _internalList[index],
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

  /// AnimatedListの内容を新しい履歴リスト[newList]に同期します。
  ///
  /// 初回ビルド時はリストをそのままコピーし、
  /// 2回目以降は削除・追加のアニメーションを適用してリストを更新します。
  void _updateAnimatedList(List<String> newList) {
    final listState = _listKey.currentState;
    if (_firstBuild) {
      _internalList = List.from(newList);
      _firstBuild = false;
      return;
    }
    if (listState == null) {
      return;
    }
    // 削除（降順）
    for (var i = _internalList.length - 1; i >= 0; i--) {
      if (!newList.contains(_internalList[i])) {
        final removed = _internalList.removeAt(i);
        listState.removeItem(
          i,
          (context, animation) => SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: ListTile(title: Text(removed)),
          ),
          duration: _animationDuration,
        );
      }
    }
    // 追加（昇順）
    for (var i = 0; i < newList.length; i++) {
      if (i >= _internalList.length || _internalList[i] != newList[i]) {
        _internalList.insert(i, newList[i]);
        listState.insertItem(i, duration: _animationDuration);
      }
    }
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
