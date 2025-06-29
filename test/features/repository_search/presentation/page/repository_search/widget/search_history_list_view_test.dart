import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/search_history_list_view.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/search_history_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

import '../../../../../../mock/mock_shared_preferences_async_platform.dart';

void main() {
  group('SearchHistoryListView', () {
    setUp(() {
      // SharedPreferencesのモックを初期化
      SharedPreferencesAsyncPlatform.instance =
          MockSharedPreferencesAsyncPlatform();
    });

    testWidgets('履歴が空の場合は「履歴なし」メッセージが表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchHistoryProvider.overrideWith(
              () => TestSearchHistory(<String>[]),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
            ],
            home: Scaffold(
              body: Column(
                children: [
                  SearchHistoryListView(
                    onHistoryTap: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(WordingData.noSearchHistory), findsOneWidget);
    });

    testWidgets('履歴がある場合はリストが表示される', (tester) async {
      const history = ['Flutter', 'Dart'];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchHistoryProvider.overrideWith(
              () => TestSearchHistory(history),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  SearchHistoryListView(
                    onHistoryTap: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final item in history) {
        expect(find.text(item), findsOneWidget);
      }
    });

    testWidgets('履歴項目をタップするとonHistoryTapが呼ばれる', (tester) async {
      const history = ['Flutter'];
      String? tapped;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchHistoryProvider.overrideWith(
              () => TestSearchHistory(history),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  SearchHistoryListView(
                    onHistoryTap: (value) => tapped = value,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Flutter'));
      expect(tapped, 'Flutter');
    });
  });
}

// テスト用の検索履歴管理クラス
class TestSearchHistory extends SearchHistory {
  TestSearchHistory([List<String>? initial]) : _history = initial ?? [];
  List<String> _history;

  @override
  Future<List<String>> build() async {
    return _history;
  }

  @override
  Future<void> add(String keyword) async {
    if (keyword.isEmpty) {
      return;
    }
    _history = [keyword, ..._history.where((e) => e != keyword)];
    _history = _history.take(10).toList();
    state = AsyncData(_history);
  }

  @override
  Future<void> clear() async {
    _history = [];
    state = const AsyncData([]);
  }

  @override
  Future<void> removeTo(String data) async {
    _history = _history.where((e) => e != data).toList();
    state = AsyncData(_history);
  }
}
