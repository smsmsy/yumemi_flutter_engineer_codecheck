import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/page/repository_details_page.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/repository_details_card.dart';

void main() {
  group('RepositoryDetailsPage', () {
    testWidgets('AppBarタイトルと戻るボタン、RepositoryDetailsCardが表示される', (tester) async {
      const repository = Repository(
        name: 'test_repo',
        language: 'Dart',
        stargazersCount: 10,
        watchersCount: 5,
        forksCount: 2,
        openIssuesCount: 1,
      );
      await tester.pumpWidget(
        const MaterialApp(
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
          home: RepositoryDetailsPage(repository: repository),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byType(RepositoryDetailsCard), findsOneWidget);
      expect(find.textContaining('リポジトリ'), findsWidgets);
    });
  });
}
