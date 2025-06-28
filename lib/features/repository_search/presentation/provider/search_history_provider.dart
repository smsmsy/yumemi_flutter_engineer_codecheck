import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_history_provider.g.dart';

/// 検索履歴を管理するRiverpodプロバイダのクラス。
///
/// 検索履歴の保存・取得・追加・クリアなどの機能を提供します。
@riverpod
class SearchHistory extends _$SearchHistory {
  /// 検索履歴の最大保存件数。
  static const _maxHistoryLength = 10;

  /// 検索履歴を保存する際のキー。
  static const _historyKey = 'search_history';

  /// SharedPreferencesへの非同期アクセス用インスタンス。
  final _prefs = SharedPreferencesAsync();

  /// 検索履歴を非同期で取得します。
  ///
  /// SharedPreferencesから履歴を取得し、存在しない場合は空リストを返します。
  @override
  Future<List<String>> build() async {
    final searchHistory = await _prefs.getStringList(_historyKey);
    return searchHistory ?? [];
  }

  /// 検索キーワードを履歴に追加します。
  ///
  /// 既存の履歴から重複を除外し、最大件数を超えないように保存します。
  /// 空文字列は追加されません。
  Future<void> add(String keyword) async {
    if (keyword.isEmpty) {
      return;
    }
    final current = state.value ?? [];
    final newHistory = [keyword, ...current.where((e) => e != keyword)];
    final limitedHistory = newHistory.take(_maxHistoryLength).toList();
    await _prefs.setStringList(_historyKey, limitedHistory);
    state = AsyncData(limitedHistory);
  }

  /// 検索履歴をすべて削除します。
  ///
  /// SharedPreferences上の履歴も空リストとして保存されます。
  Future<void> clear() async {
    await _prefs.setStringList(_historyKey, []);
    state = const AsyncData([]);
  }

  Future<void> removeTo(String data) async {
    final current = state.value ?? [];
    final newHistory = current.where((e) => e != data).toList();
    await _prefs.setStringList(_historyKey, newHistory);
    state = AsyncData(newHistory);
  }
}
