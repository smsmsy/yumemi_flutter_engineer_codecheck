import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/search_history_list_view.dart';

/// 検索履歴リストの状態とAnimatedListの操作を管理するViewModel。
///
/// スクロールコントローラーやリストキー、内部リスト、
/// AnimatedListの同期ロジックを保持します。
class SearchHistoryListViewModel extends ChangeNotifier {
  /// スクロール位置を管理するコントローラー。
  final scrollController = ScrollController();

  /// AnimatedListの状態を管理するキー。
  final listKey = GlobalKey<AnimatedListState>();

  /// 内部で保持する履歴リスト。
  List<String> internalList = [];

  /// 初回ビルドかどうかのフラグ。
  var _firstBuild = true;
  bool get firstBuild => _firstBuild;

  /// アニメーションの継続時間。
  static const animationDuration = Duration(milliseconds: 150);

  /// AnimatedListの内容を新しい履歴リスト[newList]に同期します。
  ///
  /// 初回ビルド時はリストをそのままコピーし、
  /// 2回目以降は削除・追加のアニメーションを適用してリストを更新します。
  void updateAnimatedList(List<String> newList) {
    final listState = listKey.currentState;
    if (firstBuild) {
      internalList = List.from(newList);
      _firstBuild = false;
      notifyListeners();
      return;
    }
    if (listState == null) {
      return;
    }
    _deleteItems(newList, listState);
    _addItems(newList, listState);
    notifyListeners();
  }

  /// [newList]に含まれる要素をinternalListに追加し、AnimatedListに挿入アニメーションを適用します。
  ///
  /// newListの各要素をinternalListと比較し、異なる場合は該当位置に挿入します。
  void _addItems(List<String> newList, AnimatedListState listState) {
    for (var i = 0; i < newList.length; i++) {
      if (i >= internalList.length || internalList[i] != newList[i]) {
        internalList.insert(i, newList[i]);
        listState.insertItem(i, duration: animationDuration);
      }
    }
  }

  /// internalListから[newList]に含まれない要素を削除し、AnimatedListに削除アニメーションを適用します。
  ///
  /// internalListを後ろから走査し、newListに存在しない要素をAnimatedListからアニメーション付きで削除します。
  void _deleteItems(List<String> newList, AnimatedListState listState) {
    for (var i = internalList.length - 1; i >= 0; i--) {
      if (!newList.contains(internalList[i])) {
        final removed = internalList.removeAt(i);
        listState.removeItem(
          i,
          (context, animation) => SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: Curves.decelerate,
            ),
            child: SearchHistoryListItem(
              index: i,
              value: removed,
              onHistoryTap: (value) {},
            ),
          ),
          duration: animationDuration,
        );
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
