import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/owner.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_details_card.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';

void main() {
  group('RepositoryDetailsCard', () {
    testWidgets('リポジトリ情報が正しく表示される', (tester) async {
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
          home: Scaffold(
            body: RepositoryDetailsCard(repository: repository),
          ),
        ),
      );
      expect(find.text('test_repo'), findsOneWidget);
      expect(find.text('Dart'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('オーナー情報がnullの場合はデフォルトアイコンが表示される', (tester) async {
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
          home: RepositoryDetailsCard(repository: repository),
        ),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('オーナー情報のavatarUrlが空の場合もデフォルトアイコンが表示される', (tester) async {
      const repository = Repository(
        name: 'test_repo',
        language: 'Dart',
        stargazersCount: 10,
        watchersCount: 5,
        forksCount: 2,
        openIssuesCount: 1,
        owner: Owner(avatarUrl: ''),
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: RepositoryDetailsCard(repository: repository),
        ),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('スター数などが大きい場合はNumberFormatで省略表示される', (tester) async {
      const repository = Repository(
        name: 'test_repo',
        language: 'Dart',
        stargazersCount: 12345,
        watchersCount: 67890,
        forksCount: 23456,
        openIssuesCount: 78901,
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: RepositoryDetailsCard(repository: repository),
        ),
      );
      // "12K"や"67K"など省略表記が含まれるか
      expect(find.textContaining('K'), findsWidgets);
    });

    testWidgets('画面幅600以上で横レイアウト、未満で縦レイアウト', (tester) async {
      const repository = Repository(
        name: 'test_repo',
        language: 'Dart',
        stargazersCount: 10,
        watchersCount: 5,
        forksCount: 2,
        openIssuesCount: 1,
      );
      // 横レイアウト
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(700, 800)),
            child: RepositoryDetailsCard(repository: repository),
          ),
        ),
      );
      expect(find.byType(Row), findsWidgets);
      // 縦レイアウト
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, 800)),
            child: RepositoryDetailsCard(repository: repository),
          ),
        ),
      );
      expect(find.byType(Column), findsWidgets);
    });
  });
}
