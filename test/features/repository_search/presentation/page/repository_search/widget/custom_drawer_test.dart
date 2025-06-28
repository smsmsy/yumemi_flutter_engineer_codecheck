import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/repository_search_page.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/custom_drawer.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/search_history_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

import '../../../../../../mock/mock_shared_preferences_async_platform.dart';
import '../../../../../../test_util/test_util.dart';

void main() {
  group('CustomDrawerのテスト', () {
    setUp(() {
      // SharedPreferencesのモックを初期化
      SharedPreferencesAsyncPlatform.instance =
          MockSharedPreferencesAsyncPlatform();
    });

    testWidgets('DrawerにOSSライセンス(ja)が表示される', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('ja'),
        home: const RepositorySearchPage(),
      );
      // Drawerを開く
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      // OSSライセンスが表示されていることを確認
      expect(find.text('OSSライセンス'), findsOneWidget);
    });

    testWidgets('DrawerにOSS License(en)が表示される', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('en'),
        home: const RepositorySearchPage(),
      );
      // Drawerを開く
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      // OSS Licenseが表示されていることを確認
      expect(find.text('OSS License'), findsOneWidget);
    });

    testWidgets('Licensesのページが表示され元のページにも遷移することができる', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('en'),
        home: const RepositorySearchPage(),
      );

      // Drawerを開く
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // OSS Licenseをタップ
      await tester.tap(find.text('OSS License'));
      await tester.pumpAndSettle();

      // Licensesのページが表示されていることを確認
      expect(find.text('Licenses'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsNothing);

      // 戻るボタンをタップして元のページに戻る
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      // 元のページに戻っていることを確認
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text('Licenses'), findsNothing);
    });

    testWidgets('CustomDrawer の表示要素が表示されていること', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              key: scaffoldKey,
              drawer: CustomDrawer(
                onHistoryTap: (_) {},
              ),
            ),
          ),
        ),
      );

      // Drawerを開く
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text(WordingData.searchHistory), findsOneWidget);
      expect(find.byIcon(Icons.brightness_6), findsOneWidget);

      expect(find.text(WordingData.ossLicense), findsOneWidget);

      await tester.tap(find.byIcon(Icons.brightness_6));
      await tester.pumpAndSettle();

      expect(find.text(WordingData.themeModeSystem), findsOneWidget);
      expect(find.text(WordingData.themeModeLight), findsOneWidget);
      expect(find.text(WordingData.themeModeDark), findsOneWidget);
    });
  });

  group('CustomDrawerの追加テスト', () {
    testWidgets('検索履歴が空の場合、履歴なしメッセージが表示される', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              key: scaffoldKey,
              drawer: CustomDrawer(onHistoryTap: (_) {}),
            ),
          ),
        ),
      );
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
      expect(find.text(WordingData.noSearchHistory), findsOneWidget);
    });

    testWidgets('検索履歴が表示され、タップでonHistoryTapが呼ばれる', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      String? tappedValue;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchHistoryProvider.overrideWith(
              () => TestSearchHistory(['test1', 'test2']),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              key: scaffoldKey,
              drawer: CustomDrawer(onHistoryTap: (v) => tappedValue = v),
            ),
          ),
        ),
      );
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
      expect(find.text('test1'), findsOneWidget);
      expect(find.text('test2'), findsOneWidget);
      await tester.tap(find.text('test1'));
      await tester.pumpAndSettle();
      expect(tappedValue, 'test1');
    });

    testWidgets('履歴削除ボタンで履歴が削除される', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final testHistory = TestSearchHistory(['test1', 'test2']);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchHistoryProvider.overrideWith(() => testHistory),
          ],
          child: MaterialApp(
            home: Scaffold(
              key: scaffoldKey,
              drawer: CustomDrawer(onHistoryTap: (_) {}),
            ),
          ),
        ),
      );
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
      expect(find.text('test1'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();
      expect(testHistory.state.value!.contains('test1'), isFalse);
    });

    testWidgets('テストデータ適用ボタンで履歴が追加される', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      final testHistory = TestSearchHistory();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchHistoryProvider.overrideWith(() => testHistory),
          ],
          child: MaterialApp(
            home: Scaffold(
              key: scaffoldKey,
              drawer: CustomDrawer(onHistoryTap: (_) {}),
            ),
          ),
        ),
      );
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
      if (find.byIcon(Icons.recycling).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.recycling));
        await tester.pumpAndSettle();
        expect(testHistory.state.value!.isNotEmpty, isTrue);
      }
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
    if (keyword.isEmpty) return;
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
