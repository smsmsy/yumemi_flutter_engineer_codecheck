import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/owner.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_card_ui_builder.dart';

import '../../../../../../test_util/test_util.dart';

void main() {
  group('リポジトリカードUI構築 - ユーザー体験テスト', () {
    testWidgets(
      'ユーザーがカードを見た時、リポジトリ情報が適切に表示される',
      (tester) async {
        // Given: 豊富な情報を持つリポジトリ
        const repository = Repository(
          name: 'awesome-flutter-app',
          fullName: 'flutter/awesome-flutter-app',
          id: 123456,
          language: 'Dart',
          stargazersCount: 25000,
          watchersCount: 1500,
          forksCount: 4000,
          openIssuesCount: 125,
          owner: Owner(avatarUrl: 'https://example.com/avatar.png'),
        );

        const uiBuilder = RepositoryCardUIBuilder(
          repository: repository,
          isHeroAnimationCompleted: true,
          isHeroAnimationInProgress: false,
        );

        // When: UIビルダーでカードコンテンツを構築
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(
            body: Builder(
              builder: uiBuilder.buildCardContent,
            ),
          ),
        );

        // Then: ユーザーが重要な情報を確認できる
        expect(
          find.text('awesome-flutter-app'),
          findsOneWidget,
          reason: 'リポジトリ名が表示されるべき',
        );
        expect(find.text('Dart'), findsOneWidget, reason: 'プログラミング言語が表示されるべき');
        expect(
          find.text('2.5万'),
          findsOneWidget,
          reason: 'スター数が日本語フォーマットで表示されるべき',
        );
        expect(find.text('4000'), findsOneWidget, reason: 'フォーク数が表示されるべき');
        expect(find.text('125'), findsOneWidget, reason: 'イシュー数が表示されるべき');

        // And: カード構造が適切に表示される
        expect(
          find.byType(Card),
          findsWidgets,
          reason: 'リポジトリ情報を含むカード群が表示されるべき',
        );
      },
    );

    testWidgets(
      'アニメーション状態によってカードの見た目が変化する',
      (tester) async {
        // Given: 同じリポジトリデータで異なるアニメーション状態
        const repository = Repository(
          name: 'animation-test-repo',
          fullName: 'flutter/animation-test-repo',
          id: 789012,
          language: 'JavaScript',
          stargazersCount: 1000,
          watchersCount: 100,
          forksCount: 200,
          openIssuesCount: 10,
        );

        // When: アニメーション進行中の状態
        const inProgressBuilder = RepositoryCardUIBuilder(
          repository: repository,
          isHeroAnimationCompleted: false,
          isHeroAnimationInProgress: true,
        );

        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(
            body: Builder(
              builder: inProgressBuilder.buildCardContent,
            ),
          ),
        );

        // Then: アニメーション中でもコンテンツが表示される
        expect(
          find.text('animation-test-repo'),
          findsOneWidget,
          reason: 'アニメーション中でもリポジトリ名が表示されるべき',
        );
        expect(
          find.byType(Card),
          findsWidgets,
          reason: 'アニメーション中でもカード群が表示されるべき',
        );
      },
    );

    testWidgets(
      '最小限の情報でもクラッシュせずにUIが表示される',
      (tester) async {
        // Given: 最小限のリポジトリ情報
        const minimalRepository = Repository(
          name: 'minimal-info-repo',
          fullName: 'minimal/minimal-info-repo',
          id: 999999,
          // language, ownerは null
          stargazersCount: 0,
          watchersCount: 0,
          forksCount: 0,
          openIssuesCount: 0,
        );

        const uiBuilder = RepositoryCardUIBuilder(
          repository: minimalRepository,
          isHeroAnimationCompleted: true,
          isHeroAnimationInProgress: false,
        );

        // When: 最小限情報でカードを構築
        await pumpAppWithLocale(
          tester: tester,
          locale: const Locale('ja'),
          home: Scaffold(
            body: Builder(
              builder: uiBuilder.buildCardContent,
            ),
          ),
        );

        // Then: エラーなくUIが表示される
        expect(
          find.text('minimal-info-repo'),
          findsOneWidget,
          reason: 'リポジトリ名は必須として表示されるべき',
        );
        expect(find.text('0'), findsWidgets, reason: '0の値も適切に表示されるべき');
        expect(find.byType(Card), findsWidgets, reason: 'カードUI群は常に表示されるべき');
      },
    );

    test('アニメーション装飾の設定が適切に行われる', () {
      // Given: UIビルダーとアニメーションオブジェクト
      const repository = Repository(
        name: 'decoration-test',
        fullName: 'flutter/decoration-test',
        id: 1234567,
        stargazersCount: 100,
        watchersCount: 50,
        forksCount: 25,
        openIssuesCount: 5,
      );

      const uiBuilder = RepositoryCardUIBuilder(
        repository: repository,
        isHeroAnimationCompleted: false,
        isHeroAnimationInProgress: true,
      );

      // When: アニメーション進行中（animation.value <= 1.0）
      const mockAnimationInProgress = AlwaysStoppedAnimation<double>(0.5);
      final decorationInProgress = uiBuilder.buildAnimationDecoration(
        mockAnimationInProgress,
      );

      // Then: シャドウは付与されない
      expect(
        decorationInProgress.boxShadow,
        isEmpty,
        reason: 'アニメーション中はシャドウが消えるべき',
      );

      // When: アニメーション完了（animation.value > 1.0）
      const mockAnimationCompleted = AlwaysStoppedAnimation<double>(1.1);
      final decorationCompleted = uiBuilder.buildAnimationDecoration(
        mockAnimationCompleted,
      );

      // Then: シャドウが付与される
      expect(
        decorationCompleted.borderRadius,
        equals(BorderRadius.circular(16)),
        reason: '角丸16pxが設定されるべき',
      );
      expect(
        decorationCompleted.boxShadow,
        isNotEmpty,
        reason: 'アニメーション完了時はシャドウ効果が設定されるべき',
      );
      expect(
        decorationCompleted.boxShadow!.first.color.a,
        greaterThan(0),
        reason: 'シャドウに透明度が設定されるべき',
      );
    });
  });
}
