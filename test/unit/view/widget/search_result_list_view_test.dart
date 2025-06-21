import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';
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
          repositiesSearchResultProvider.overrideWith((_) => dummyList),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('repo1'), findsOneWidget);
      expect(find.text('repo2'), findsOneWidget);
    });

    testWidgets('空リスト時にメッセージが表示される', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          repositiesSearchResultProvider.overrideWith(
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
          repositiesSearchResultProvider.overrideWith(
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
          repositiesSearchResultProvider.overrideWith(
            (_) => throw Exception('error'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('エラーが発生しました'), findsOneWidget);
    });

    testWidgets('リストタップでSnackBarが表示される', (tester) async {
      final dummyList = [
        const Repository(
          name: 'repo1',
          stargazersCount: 10,
          watchersCount: 5,
          forksCount: 2,
          openIssuesCount: 1,
        ),
      ];
      await tester.pumpWidget(
        _buildTestWidget(
          repositiesSearchResultProvider.overrideWith((_) => dummyList),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('repo1'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Tapped on repo1'), findsOneWidget);
    });
  });
}

Widget _buildTestWidget(Override override) {
  return ProviderScope(
    overrides: [override],
    child: const MaterialApp(
      home: Scaffold(
        body: SearchResultListView(),
      ),
    ),
  );
}
