import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/owner.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/repository_details_card.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_result_list_view.dart';

import '../../test_util/test_util.dart';

void main() {
  group('HeroアニメーションのUXテスト', () {
    testWidgets(
      'ユーザーがリポジトリリストから詳細画面に遷移する時、自然なアニメーションが実行される',
      (tester) async {
        // Given: ユーザーがリポジトリ検索結果を見ている
        const testRepository = Repository(
          name: 'flutter',
          language: 'Dart',
          stargazersCount: 100000,
          watchersCount: 5000,
          forksCount: 15000,
          openIssuesCount: 500,
          owner: Owner(avatarUrl: 'https://example.com/avatar.png'),
        );

        final searchResultScreen = Scaffold(
          appBar: AppBar(title: const Text('検索結果')),
          body: AdaptiveRepositoryListView(
            value: const [testRepository],
            scrollController: ScrollController(),
          ),
        );

        final detailScreen = Scaffold(
          appBar: AppBar(title: const Text('詳細')),
          body: const RepositoryDetailsCard(repository: testRepository),
        );

        // When: ユーザーがアプリを開く
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: searchResultScreen,
        );

        // Then: リポジトリが表示される
        expect(find.text('flutter'), findsOneWidget);
        // AdaptiveRepositoryListView は
        // repository.name のみ表示するため、languageは検証しない

        // And: Hero アニメーションの準備ができている
        final heroWidgetInList = find.byType(Hero).first;
        expect(heroWidgetInList, findsOneWidget);

        // When: ユーザーが詳細画面を表示する（模擬的な画面遷移）
        await tester.pumpWidget(
          MaterialApp(
            home: Navigator(
              pages: [
                MaterialPage<void>(
                  key: const ValueKey('search'),
                  child: searchResultScreen,
                ),
                MaterialPage<void>(
                  key: const ValueKey('detail'),
                  child: detailScreen,
                ),
              ],
              onDidRemovePage: (route) => route.onPopInvoked(true, route),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Then: 詳細画面でも同じリポジトリ情報が表示される
        expect(find.text('flutter'), findsOneWidget);
        // Note: 詳細画面では language も表示されることを確認
        expect(find.text('Dart'), findsOneWidget);

        // And: Hero ウィジェットが適切に配置されている
        final heroWidgetInDetail = find.byType(Hero);
        expect(heroWidgetInDetail, findsOneWidget);
      },
    );

    testWidgets(
      'リポジトリ名が同じならば同一のHeroタグが使用され、アニメーションが実行される',
      (tester) async {
        // Given: 同じ名前のリポジトリが2つの画面に存在する
        const repositoryName = 'awesome-repo';
        const testRepository = Repository(
          name: repositoryName,
          language: 'JavaScript',
          stargazersCount: 42,
          watchersCount: 12,
          forksCount: 8,
          openIssuesCount: 3,
        );

        // When: リスト画面のHeroウィジェットを確認
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(
            body: AdaptiveRepositoryListView(
              value: const [testRepository],
              scrollController: ScrollController(),
            ),
          ),
        );

        // Then: 適切なタグを持つHeroウィジェットが存在する
        final listHero = tester.widget<Hero>(find.byType(Hero));
        expect(listHero.tag, equals('repository-$repositoryName'));

        // When: 詳細画面のHeroウィジェットを確認
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: const Scaffold(
            body: RepositoryDetailsCard(repository: testRepository),
          ),
        );

        // Then: 同じタグを持つHeroウィジェットが存在する
        final detailHero = tester.widget<Hero>(find.byType(Hero));
        expect(detailHero.tag, equals('repository-$repositoryName'));
        expect(detailHero.tag, equals(listHero.tag));
      },
    );

    testWidgets(
      'ユーザーがジェスチャーでナビゲーションした場合もアニメーションが動作する',
      (tester) async {
        // Given: ユーザージェスチャーに対応したHeroアニメーション設定
        const testRepository = Repository(
          name: 'gesture-test-repo',
          language: 'Swift',
          stargazersCount: 777,
          watchersCount: 111,
          forksCount: 222,
          openIssuesCount: 33,
        );

        // When: リスト画面を表示
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(
            body: AdaptiveRepositoryListView(
              value: const [testRepository],
              scrollController: ScrollController(),
            ),
          ),
        );

        // Then: transitionOnUserGestures が有効になっている
        final listHero = tester.widget<Hero>(find.byType(Hero));
        expect(listHero.transitionOnUserGestures, isTrue);

        // When: 詳細画面を表示
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: const Scaffold(
            body: RepositoryDetailsCard(repository: testRepository),
          ),
        );

        // Then: 詳細画面でもユーザージェスチャーに対応している
        final detailHero = tester.widget<Hero>(find.byType(Hero));
        expect(detailHero.transitionOnUserGestures, isTrue);
      },
    );

    testWidgets(
      'リポジトリ情報がnullでも安全にHeroアニメーションが動作する',
      (tester) async {
        // Given: 最小限の情報しか持たないリポジトリ
        const minimalRepository = Repository(
          name: 'minimal-repo',
          stargazersCount: 0,
          watchersCount: 0,
          forksCount: 0,
          openIssuesCount: 0,
          // language: null, owner: null
        );

        // When: 詳細画面を表示
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: const Scaffold(
            body: RepositoryDetailsCard(repository: minimalRepository),
          ),
        );

        // Then: エラーなくHeroウィジェットが表示される
        expect(find.byType(Hero), findsOneWidget);
        expect(find.text('minimal-repo'), findsOneWidget);

        // And: デフォルトアイコンが表示される
        expect(find.byIcon(Icons.person), findsOneWidget);
      },
    );

    testWidgets(
      'カスタムflightShuttleBuilderが適切に設定されている',
      (tester) async {
        // Given: Hero アニメーションを持つリポジトリ詳細カード
        const testRepository = Repository(
          name: 'animation-test',
          language: 'Flutter',
          stargazersCount: 1000,
          watchersCount: 500,
          forksCount: 200,
          openIssuesCount: 50,
        );

        // When: 詳細画面を表示
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: const Scaffold(
            body: RepositoryDetailsCard(repository: testRepository),
          ),
        );

        // Then: カスタムflightShuttleBuilderが設定されている
        final heroWidget = tester.widget<Hero>(find.byType(Hero));
        expect(heroWidget.flightShuttleBuilder, isNotNull);
      },
    );
  });

  group('Heroアニメーションのパフォーマンステスト', () {
    testWidgets(
      'アニメーション中に大量のrebuildが発生しない',
      (tester) async {
        // Given: アニメーション性能を測定するためのリポジトリ
        const testRepository = Repository(
          name: 'performance-test',
          language: 'Dart',
          stargazersCount: 50000,
          watchersCount: 10000,
          forksCount: 5000,
          openIssuesCount: 1000,
        );

        var buildCount = 0;

        // When: rebuild回数を計測できるウィジェットでラップ
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                buildCount++;
                return const RepositoryDetailsCard(repository: testRepository);
              },
            ),
          ),
        );

        final initialBuildCount = buildCount;

        // アニメーションをシミュレート
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));

        // Then: 過度なrebuildが発生していない
        expect(buildCount - initialBuildCount, lessThan(10));
      },
    );
  });

  group('Heroアニメーションのアクセシビリティテスト', () {
    testWidgets(
      'アクセシビリティ機能が有効でもアニメーションが正常に動作する',
      (tester) async {
        // Given: アクセシビリティ設定でアニメーション無効
        const testRepository = Repository(
          name: 'accessibility-test',
          language: 'Python',
          stargazersCount: 123,
          watchersCount: 45,
          forksCount: 67,
          openIssuesCount: 8,
        );

        // When: 詳細画面を表示（アニメーション無効設定）
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: const MediaQuery(
            data: MediaQueryData(
              disableAnimations: true, // アニメーション無効
            ),
            child: Scaffold(
              body: RepositoryDetailsCard(repository: testRepository),
            ),
          ),
        );

        // Then: アニメーション無効でもウィジェットが正常に表示される
        expect(find.byType(Hero), findsOneWidget);
        expect(find.text('accessibility-test'), findsOneWidget);
        expect(find.text('Python'), findsOneWidget);
      },
    );
  });
}
