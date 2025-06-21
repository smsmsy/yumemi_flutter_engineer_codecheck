import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/page/search_page.dart';

import '../mock/mock_shared_preferences_async_plarform.dart';

void main() {
  group('MyHomePage Drawer', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          MockSharedPreferencesAsyncPlatform();
    });

    Future<void> pumpApp(WidgetTester tester, Locale locale) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ja'),
            ],
            home: const SearchPage(),
          ),
        ),
      );
    }

    testWidgets('DrawerにOSSライセンス(ja)が表示される', (tester) async {
      await pumpApp(tester, const Locale('ja'));
      // Drawerを開く
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      // OSSライセンスが表示されていることを確認
      expect(find.text('OSSライセンス'), findsOneWidget);
    });

    testWidgets('DrawerにOSS License(en)が表示される', (tester) async {
      await pumpApp(tester, const Locale('en'));
      // Drawerを開く
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      // OSS Licenseが表示されていることを確認
      expect(find.text('OSS License'), findsOneWidget);
    });

    testWidgets('Licensesのページが表示され元のページにも遷移することができる', (tester) async {
      await pumpApp(tester, const Locale('en'));

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
  });
}
