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
  });
}
