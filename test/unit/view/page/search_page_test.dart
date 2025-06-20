import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/page/search_page.dart';

import '../../../mock/mock_shared_preferences_async_plarform.dart';
import '../../../util/test_util.dart';

void main() {
  group('リポジトリ検索ページのテスト', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          MockSharedPreferencesAsyncPlatform();
    });
    testWidgets('タイトル表示(ja)', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('ja'),
        home: const SearchPage(),
      );
      expect(find.text('リポジトリ検索'), findsOneWidget);
    });
    testWidgets('タイトル表示(en)', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('en'),
        home: const SearchPage(),
      );
      expect(find.text('Search Repository'), findsOneWidget);
    });
    testWidgets('検索テキストボックスに入力した内容が表示される', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('ja'),
        home: const SearchPage(),
      );
      // テキストボックスに入力
      const inputText = 'Flutter';
      await tester.enterText(find.byType(TextField), inputText);
      await tester.pump();
      // 入力内容がTextFieldに表示されていること
      expect(find.text(inputText), findsOneWidget);
    });
    testWidgets('キャンセルボタン押下でテキストがクリアされる', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('ja'),
        home: const SearchPage(),
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
    });

    testWidgets('ロケール切り替えでlabelTextが切り替わる', (tester) async {
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('en'),
        home: const SearchPage(),
      );
      expect(find.text('Search repositories'), findsOneWidget);
      await pumpAppWithLocale(
        tester: tester,
        locale: const Locale('ja'),
        home: const SearchPage(),
      );
      expect(find.text('リポジトリを検索'), findsOneWidget);
    });
  });
}
