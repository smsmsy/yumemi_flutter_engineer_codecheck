import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/owner.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/repository_details_page.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_details_card.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';

import '../../../../../test_util/test_util.dart';

void main() {
  group('RepositoryDetailsPage', () {
    testWidgets('AppBarタイトルと戻るボタン、RepositoryDetailsCardが表示される', (tester) async {
      const repository = Repository(
        name: 'test_repo',
        fullName: 'test_repo/test_repo',
        id: 1,
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

    group('ユーザー体験テスト', () {
      testWidgets(
        'ユーザーがリポジトリ詳細を表示した時、すべての重要情報が閲覧できる',
        (tester) async {
          // Given: 詳細なリポジトリ情報
          const repository = Repository(
            name: 'flutter-samples',
            fullName: 'flutter/flutter-samples',
            id: 123456,
            language: 'Dart',
            stargazersCount: 15000,
            watchersCount: 1000,
            forksCount: 3000,
            openIssuesCount: 42,
            owner: Owner(
              avatarUrl: 'https://example.com/avatar.png',
            ),
          );

          // When: ユーザーが詳細ページにアクセスする
          await pumpAppWithLocale(
            tester: tester,
            locale: const Locale('ja'),
            home: const RepositoryDetailsPage(repository: repository),
          );

          // Then: まず基本的な情報の存在を確認
          expect(
            find.text('flutter-samples'),
            findsOneWidget,
            reason: 'リポジトリ名が表示されるべき',
          );
          expect(
            find.text('Dart'),
            findsOneWidget,
            reason: 'プログラミング言語が表示されるべき',
          );

          // 日本語ロケールでのNumberFormat.compactフォーマットに合わせたテスト
          expect(
            find.text('1.5万'), // 15000 -> 1.5万（日本語ロケール）
            findsOneWidget,
            reason: 'スター数が表示されるべき',
          );
          expect(
            find.text('3000'), // 3000はそのまま
            findsOneWidget,
            reason: 'フォーク数が表示されるべき',
          );
          expect(
            find.text('42'),
            findsOneWidget,
            reason: '未解決Issue数が表示されるべき',
          );
          expect(
            find.byType(RepositoryDetailsCard),
            findsOneWidget,
            reason: '詳細カードが表示されるべき',
          );
        },
      );

      testWidgets(
        'ユーザーが戻るボタンを見つけることができる',
        (tester) async {
          // Given: リポジトリ詳細画面が表示されている
          const repository = Repository(
            name: 'test-repo',
            fullName: 'test-repo/test-repo',
            id: 1,
            language: 'JavaScript',
            stargazersCount: 100,
            watchersCount: 50,
            forksCount: 20,
            openIssuesCount: 5,
          );

          // When: 詳細ページが表示される
          await pumpAppWithLocale(
            tester: tester,
            locale: const Locale('ja'),
            home: const RepositoryDetailsPage(repository: repository),
          );

          // Then: 戻るボタンが存在し、ユーザーがタップできる状態になっている
          expect(
            find.byIcon(Icons.arrow_back),
            findsOneWidget,
            reason: '戻るボタンがユーザーに表示されるべき',
          );

          // And: AppBarが存在する
          expect(find.byType(AppBar), findsOneWidget, reason: 'AppBarが表示されるべき');
        },
      );

      testWidgets(
        '詳細表示に最小限の情報でも問題なく表示される',
        (tester) async {
          // Given: 最小限の情報を持つリポジトリ
          const minimalRepository = Repository(
            name: 'minimal-repo',
            fullName: 'minimal-repo/minimal-repo',
            id: 999999,
            // 言語は null
            stargazersCount: 0,
            watchersCount: 0,
            forksCount: 0,
            openIssuesCount: 0,
            // ownerもnull
          );

          // When: 詳細ページが表示される
          await pumpAppWithLocale(
            tester: tester,
            locale: const Locale('ja'),
            home: const RepositoryDetailsPage(repository: minimalRepository),
          );

          // Then: クラッシュせず、アクセス可能な情報が表示される
          expect(
            find.text('minimal-repo'),
            findsOneWidget,
            reason: 'リポジトリ名は必須情報として表示されるべき',
          );
          expect(
            find.textContaining('0'),
            findsWidgets,
            reason: '0のカウンタ値も適切に表示されるべき',
          );
          expect(
            find.byType(RepositoryDetailsCard),
            findsOneWidget,
            reason: '詳細カードは表示されるべき',
          );
        },
      );
    });
  });
}
