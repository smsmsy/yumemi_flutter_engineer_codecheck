import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/page/repository_search_page.dart';

import '../../../mock/mock_shared_preferences_async_platform.dart';
import '../../../util/test_util.dart';

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
  });
}
