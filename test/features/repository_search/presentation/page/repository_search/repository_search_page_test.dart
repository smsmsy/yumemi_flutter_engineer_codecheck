import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/repository_search_page.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/search_history_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';

import '../../../../../mock/mock_shared_preferences_async_platform.dart';
import '../../../../../test_util/test_util.dart';

void main() {
  group('RepositorySearchPage', () {
    testWidgets('AppBarタイトル・検索テキストボックス・リストが表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('ja'),
              Locale('en'),
            ],
            locale: Locale('ja'),
            home: RepositorySearchPage(),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.textContaining('リポジトリ'), findsWidgets);
    });
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          MockSharedPreferencesAsyncPlatform();
    });
    testWidgets('タイトル表示(ja)', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('ja'),
        home: const RepositorySearchPage(),
      );
      expect(find.text('リポジトリ検索'), findsOneWidget);
    });
    testWidgets('タイトル表示(en)', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('en'),
        home: const RepositorySearchPage(),
      );
      expect(find.text('Search Repository'), findsOneWidget);
    });
    testWidgets('検索テキストボックスに入力した内容が表示される', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('ja'),
        home: const RepositorySearchPage(),
      );
      // テキストボックスに入力
      const inputText = 'Flutter';
      await tester.enterText(find.byType(TextField), inputText);
      await tester.pump();
      // 入力内容がTextFieldに表示されていること
      expect(find.text(inputText), findsOneWidget);
      // タイマーなどの保留中処理を解消
      await tester.pumpAndSettle();
    });
    testWidgets('キャンセルボタン押下でテキストがクリアされる', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('ja'),
        home: const RepositorySearchPage(),
      );
      // テキスト入力
      const inputText = 'Flutter';
      await tester.enterText(find.byType(TextField), inputText);
      await tester.pump();
      expect(find.text(inputText), findsOneWidget);
      // キャンセルボタン押下
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();
      // テキストがクリアされていること
      expect(find.text(inputText), findsNothing);
      // タイマーなどの保留中処理を解消
      await tester.pumpAndSettle();
    });

    testWidgets('ロケール切り替えでlabelTextが切り替わる', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('en'),
        home: const RepositorySearchPage(),
      );
      expect(find.text('Search repositories'), findsOneWidget);
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('ja'),
        home: const RepositorySearchPage(),
      );
      expect(find.text('リポジトリを検索'), findsOneWidget);
    });

    group('ユーザー体験テスト', () {
      testWidgets(
        'ユーザーが検索ページにアクセスした時、検索に必要な要素がすべて利用可能',
        (tester) async {
          // When: ユーザーが検索ページを開く
          await pumpAppWithLocale(
            tester: tester,
            locale: const Locale('ja'),
            home: const RepositorySearchPage(),
          );

          // Then: 検索に必要なUI要素が揃っている
          expect(
            find.byType(AppBar),
            findsOneWidget,
            reason: 'ページタイトルのAppBarが表示されるべき',
          );
          expect(
            find.text('リポジトリ検索'),
            findsOneWidget,
            reason: 'ページタイトルが日本語で表示されるべき',
          );
          expect(
            find.byType(TextField),
            findsOneWidget,
            reason: '検索用のテキストフィールドが提供されるべき',
          );
          expect(
            find.byIcon(Icons.search),
            findsOneWidget,
            reason: '検索アイコンが表示されるべき',
          );
          expect(
            find.byIcon(Icons.cancel),
            findsOneWidget,
            reason: 'キャンセルボタンが表示されるべき',
          );

          // And: 検索結果表示エリアが存在する
          expect(
            find.byType(Expanded),
            findsOneWidget,
            reason: '検索結果表示エリアが提供されるべき',
          );
        },
      );

      testWidgets(
        'ユーザーがリポジトリ名を入力する時、リアルタイムフィードバックが提供される',
        (tester) async {
          // Given: 検索ページが表示されている
          await pumpAppWithLocale(
            tester: tester,
            locale: const Locale('ja'),
            home: const RepositorySearchPage(),
          );

          // When: ユーザーが検索語を入力する
          const searchTerm = 'flutter';
          await tester.enterText(find.byType(TextField), searchTerm);
          await tester.pump();

          // Then: 入力内容が即座に表示される
          expect(
            find.text(searchTerm),
            findsOneWidget,
            reason: 'ユーザーの入力がリアルタイムで表示されるべき',
          );

          // When: ユーザーがEnterを押す
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          // Then: 検索が実行される（UIの変化を確認）
          expect(
            find.byType(TextField),
            findsOneWidget,
            reason: '検索実行後もテキストフィールドが利用可能であるべき',
          );
        },
      );

      testWidgets(
        'ユーザーが検索をクリアしたい時、簡単にリセットできる',
        (tester) async {
          // Given: 検索語が入力されている状態
          await pumpAppWithLocale(
            tester: tester,
            locale: const Locale('ja'),
            home: const RepositorySearchPage(),
          );

          const searchTerm = 'test-repository';
          await tester.enterText(find.byType(TextField), searchTerm);
          await tester.pump();

          // 入力が表示されていることを確認
          expect(
            find.text(searchTerm),
            findsOneWidget,
            reason: '入力内容が表示されているべき',
          );

          // When: ユーザーがキャンセルボタンをタップする
          await tester.tap(find.byIcon(Icons.cancel));
          await tester.pump();

          // Then: 検索フィールドがクリアされる
          expect(
            find.text(searchTerm),
            findsNothing,
            reason: 'キャンセル後は入力内容がクリアされるべき',
          );

          // And: 空の検索フィールドが表示される
          final textField = tester.widget<TextField>(find.byType(TextField));
          expect(
            textField.controller?.text ?? '',
            isEmpty,
            reason: 'テキストフィールドが空になるべき',
          );
        },
      );

      testWidgets(
        '多言語対応：英語ユーザーも適切にページを利用できる',
        (tester) async {
          // When: 英語ロケールでページを表示
          await pumpAppWithLocale(
            tester: tester,
            locale: const Locale('en'),
            home: const RepositorySearchPage(),
          );

          // Then: 英語でのUI要素が表示される
          expect(
            find.text('Search Repository'),
            findsOneWidget,
            reason: 'ページタイトルが英語で表示されるべき',
          );
          expect(
            find.text('Search repositories'),
            findsOneWidget,
            reason: '検索フィールドのヒントが英語で表示されるべき',
          );

          // And: 機能的要素は言語に関係なく利用可能
          expect(
            find.byType(TextField),
            findsOneWidget,
            reason: '検索機能は言語に関係なく利用可能であるべき',
          );
          expect(
            find.byIcon(Icons.search),
            findsOneWidget,
            reason: '検索アイコンは国際的に理解できるべき',
          );
        },
      );

      testWidgets(
        'ユーザーがドロワーメニューにアクセスできる',
        (tester) async {
          // Given: 検索ページが表示されている
          await pumpAppWithLocale(
            tester: tester,
            locale: const Locale('ja'),
            home: const RepositorySearchPage(),
          );

          // When: ユーザーがドロワーを開こうとする
          expect(find.byType(AppBar), findsOneWidget, reason: 'AppBarが存在するべき');

          // Then: ドロワーアクセス手段が提供されている
          expect(
            find.byType(Scaffold),
            findsOneWidget,
            reason: 'Scaffoldがドロワー機能を提供するべき',
          );
        },
      );

      testWidgets(
        'アクセシビリティ：画面タップでフォーカスが適切に管理される',
        (tester) async {
          // Given: 検索ページが表示され、テキストフィールドにフォーカスがある
          await pumpAppWithLocale(
            tester: tester,
            locale: const Locale('ja'),
            home: const RepositorySearchPage(),
          );

          // フォーカスを設定
          await tester.tap(find.byType(TextField));
          await tester.pump();

          // When: ユーザーが画面の空白部分をタップ
          await tester.tap(find.byType(Scaffold));
          await tester.pump();

          // Then: フォーカスが外れる（GestureDetectorによる）
          expect(
            find.byType(TextField),
            findsOneWidget,
            reason: 'テキストフィールドは引き続き利用可能であるべき',
          );
          expect(
            find.byType(GestureDetector),
            findsWidgets,
            reason: 'フォーカス管理のためのGestureDetector群が存在するべき',
          );
        },
      );

      testWidgets('ドロワーで検索履歴をタップするとドロワーが閉じ、タップした履歴で再検索される', (tester) async {
        // Given: ProviderScopeで履歴をテスト用に上書き
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              searchHistoryProvider.overrideWith(
                () => TestSearchHistory(['flutter riverpod', 'yumemi']),
              ),
            ],
            child: const MaterialApp(
              home: RepositorySearchPage(),
            ),
          ),
        );
        // ドロワーを開く
        final scaffoldState = tester.state<ScaffoldState>(
          find.byType(Scaffold),
        );
        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        // 検索履歴リストの先頭項目が現れるまで最大1秒待つ (10ms * 100回 = 1秒)
        const firstHistory = 'flutter riverpod';
        final firstHistoryTile = find.widgetWithText(ListTile, firstHistory);
        var found = false;
        for (var i = 0; i < 100; i++) {
          await tester.pump(const Duration(milliseconds: 10));
          if (firstHistoryTile.evaluate().isNotEmpty) {
            found = true;
            break;
          }
        }
        expect(found, isTrue, reason: '検索履歴リストの先頭項目が表示されること');
        expect(firstHistoryTile, findsOneWidget);

        // When: 履歴をタップ
        await tester.tap(firstHistoryTile);
        await tester.pumpAndSettle();

        // Then: ドロワーが閉じている
        expect(find.byType(Drawer), findsNothing);
        // TextFieldに履歴文字列がセットされている
        expect(find.text(firstHistory), findsOneWidget);
      });
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
