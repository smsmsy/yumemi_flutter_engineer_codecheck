import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/repository_layout_strategy.dart';

import '../../test_util/test_util.dart';

void main() {
  group('リポジトリレイアウト戦略 - ユーザー体験テスト', () {
    testWidgets(
      '画面幅に応じてユーザーが最適なレイアウトで情報を閲覧できる',
      (tester) async {
        // Given: 表示するリポジトリ情報
        const repository = Repository(
          name: 'layout-test-repo',
          language: 'TypeScript',
          stargazersCount: 5000,
          watchersCount: 500,
          forksCount: 1000,
          openIssuesCount: 50,
        );

        // When: 狭い画面でレイアウト戦略を適用
        await tester.binding.setSurfaceSize(const Size(400, 600)); // 狭い画面

        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(
            body: LayoutStrategyFactory.createStrategy(
              isAnimationInProgress: false,
              isAnimationCompleted: true,
              repository: repository,
            ),
          ),
        );

        // Then: コンテンツが適切に表示される
        expect(
          find.text('layout-test-repo'),
          findsOneWidget,
          reason: 'リポジトリ名が表示されるべき',
        );
        expect(
          find.text('TypeScript'),
          findsOneWidget,
          reason: 'プログラミング言語が表示されるべき',
        );
        expect(find.text('5000'), findsOneWidget, reason: 'スター数が表示されるべき');

        // And: レイアウトコンポーネントが存在する
        expect(
          find.byType(Column),
          findsWidgets,
          reason: 'レイアウト戦略でColumn構造が適用されるべき',
        );
      },
    );

    testWidgets(
      'アニメーション中でも安定したレイアウトが提供される',
      (tester) async {
        // Given: アニメーション進行中のシナリオ
        const repository = Repository(
          name: 'animation-layout-test',
          language: 'Go',
          stargazersCount: 2000,
          watchersCount: 200,
          forksCount: 300,
          openIssuesCount: 15,
        );

        // When: アニメーション進行中の戦略を適用
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(
            body: LayoutStrategyFactory.createStrategy(
              isAnimationInProgress: true,
              isAnimationCompleted: false,
              repository: repository,
            ),
          ),
        );

        // Then: アニメーション中でも情報が表示される
        expect(
          find.text('animation-layout-test'),
          findsOneWidget,
          reason: 'アニメーション中でもリポジトリ名が表示されるべき',
        );
        expect(
          find.text('Go'),
          findsOneWidget,
          reason: 'アニメーション中でも言語情報が表示されるべき',
        );

        // And: ウィジェットツリーが構築される
        expect(
          tester.allWidgets.isNotEmpty,
          true,
          reason: 'アニメーション中でもウィジェットが構築されるべき',
        );
      },
    );

    testWidgets(
      '様々な画面サイズで一貫したユーザー体験が提供される',
      (tester) async {
        // Given: テスト用リポジトリ
        const repository = Repository(
          name: 'responsive-test',
          language: 'Python',
          stargazersCount: 15000,
          watchersCount: 1000,
          forksCount: 2500,
          openIssuesCount: 100,
        );

        // Test Case 1: 非常に狭い画面
        await tester.binding.setSurfaceSize(const Size(300, 500));

        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(
            body: LayoutStrategyFactory.createStrategy(
              isAnimationInProgress: false,
              isAnimationCompleted: true,
              repository: repository,
            ),
          ),
        );

        expect(
          find.text('responsive-test'),
          findsOneWidget,
          reason: '狭い画面でもリポジトリ名が表示されるべき',
        );

        // Test Case 2: 広い画面
        await tester.binding.setSurfaceSize(const Size(800, 600));
        await tester.pumpAndSettle();

        expect(
          find.text('responsive-test'),
          findsOneWidget,
          reason: '広い画面でもリポジトリ名が表示されるべき',
        );
        expect(
          find.text('1.5万'),
          findsOneWidget,
          reason: '広い画面でもスター数が適切にフォーマットされるべき',
        );
      },
    );

    testWidgets(
      'ファクトリーパターンによるウィジェット生成が適切に動作する',
      (tester) async {
        // Given: ファクトリーメソッドのテスト
        const repository = Repository(
          name: 'factory-pattern-test',
          language: 'Rust',
          stargazersCount: 3000,
          watchersCount: 300,
          forksCount: 600,
          openIssuesCount: 25,
        );

        // When: 異なる状態でファクトリーを使用
        final strategyWidget = LayoutStrategyFactory.createStrategy(
          isAnimationInProgress: false,
          isAnimationCompleted: true,
          repository: repository,
        );

        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(body: strategyWidget),
        );

        // Then: ファクトリーで生成されたウィジェットが正常に動作
        expect(
          find.text('factory-pattern-test'),
          findsOneWidget,
          reason: 'ファクトリーで生成されたウィジェットが表示されるべき',
        );
        expect(
          find.text('Rust'),
          findsOneWidget,
          reason: 'ファクトリーで生成されたウィジェットに言語情報が含まれるべき',
        );
        expect(strategyWidget, isA<Widget>(), reason: 'ファクトリーは有効なウィジェットを返すべき');
      },
    );
  });
}
