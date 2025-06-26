import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/owner.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/common/widget/owner_icon.dart';

void main() {
  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  group('OwnerIcon', () {
    testWidgets('オーナーがnullの場合、デフォルトアイコンが表示される', (tester) async {
      const repository = Repository(
        name: 'repo',
        fullName: 'repo/repo',
        id: 1,
        stargazersCount: 0,
        watchersCount: 0,
        forksCount: 0,
        openIssuesCount: 0,
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: OwnerIcon(repository: repository),
        ),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('オーナーのavatarUrlが空文字の場合、デフォルトアイコンが表示される', (tester) async {
      const repository = Repository(
        name: 'repo',
        fullName: 'repo/repo',
        id: 1,
        stargazersCount: 0,
        watchersCount: 0,
        forksCount: 0,
        openIssuesCount: 0,
        owner: Owner(avatarUrl: ''),
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: OwnerIcon(repository: repository),
        ),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('オーナーのavatarUrlが有効な場合、Image.networkが表示される', (tester) async {
      const repository = Repository(
        name: 'repo',
        fullName: 'repo/repo',
        id: 1,
        stargazersCount: 0,
        watchersCount: 0,
        forksCount: 0,
        openIssuesCount: 0,
        owner: Owner(avatarUrl: 'https://example.com/avatar.png'),
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: OwnerIcon(repository: repository),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
