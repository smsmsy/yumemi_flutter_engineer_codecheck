import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/page/repository_search_page.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/custom_drawer.dart';

import '../../mock/mock_shared_preferences_async_platform.dart';
import '../../test_util/test_util.dart';

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
              drawer: const CustomDrawer(),
            ),
          ),
        ),
      );

      // Drawerを開く
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text(WordingData.applicationName), findsOneWidget);
      expect(find.byIcon(Icons.brightness_6), findsOneWidget);

      expect(find.text(WordingData.ossLicense), findsOneWidget);

      await tester.tap(find.byIcon(Icons.brightness_6));
      await tester.pumpAndSettle();

      expect(find.text(WordingData.themeModeSystem), findsOneWidget);
      expect(find.text(WordingData.themeModeLight), findsOneWidget);
      expect(find.text(WordingData.themeModeDark), findsOneWidget);
    });
  });
}
