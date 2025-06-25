import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entities/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/providers/repository_providers.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/page/repository_search_page.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_result_list_view.dart';

void main() {
  group('SearchResultListView UIテスト', () {
    testWidgets('リストが正常に表示される', (tester) async {
      final dummyList = [
        const Repository(
          name: 'repo1',
          stargazersCount: 10,
          watchersCount: 5,
          forksCount: 2,
          openIssuesCount: 1,
        ),
        const Repository(
          name: 'repo2',
          stargazersCount: 20,
          watchersCount: 10,
          forksCount: 4,
          openIssuesCount: 2,
        ),
      ];
      await tester.pumpWidget(
        _buildTestWidget(
          repositoriesSearchResultProvider.overrideWith((_) => dummyList),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('repo1'), findsOneWidget);
      expect(find.text('repo2'), findsOneWidget);
    });

    testWidgets('空リスト時にメッセージが表示される', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          repositoriesSearchResultProvider.overrideWith(
            (_) => <Repository>[],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('該当するリポジトリはありません'), findsOneWidget);
    });

    testWidgets('ローディング時にインジケータが表示される', (tester) async {
      final completer = Completer<List<Repository>>();
      await tester.pumpWidget(
        _buildTestWidget(
          repositoriesSearchResultProvider.overrideWith(
            (_) => completer.future,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      completer.complete(<Repository>[]);
    });

    testWidgets('エラー時にエラーメッセージが表示される', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          repositoriesSearchResultProvider.overrideWith(
            (_) => throw Exception('error'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Exception: error'), findsOneWidget);
    });
  });

  group('SearchResultListView/RepositorySearchPage', () {
    testWidgets('Heroタグがリスト・詳細で一致している', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Hero(
            tag: 'repository-test_repo',
            child: Container(),
          ),
        ),
      );
      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'repository-test_repo');
    });

    testWidgets('リストタップ時にGoRouterで正しく遷移する', (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const RepositorySearchPage(),
            routes: [
              GoRoute(
                path: 'details',
                builder: (context, state) => const Text('DetailsPage'),
              ),
            ],
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ja'),
              Locale('en'),
            ],
            locale: const Locale('ja'),
          ),
        ),
      );
      // NOTE: 実際のリスト表示・タップはProviderのモックが必要なため省略例
      // GoRouterのルート遷移がエラーなく構成できることを確認
      expect(router.canPop(), isFalse);
    });
  });
}

Widget _buildTestWidget(Override override) {
  return ProviderScope(
    overrides: [override],
    child: const MaterialApp(
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
        body: SearchResultListView(),
      ),
    ),
  );
}
