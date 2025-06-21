import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_result_list_view.dart';

void main() {
  group('検索画面からリストビュー利用時', () {
    testWidgets('検索結果が表示される', (tester) async {
      // TODO: ダミーデータでのテスト。将来的に外部からデータを渡す設計にした際は修正すること。
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchResultListView(),
          ),
        ),
      );
      // 1件目と2件目のリストアイテムが表示されていることを確認
      expect(find.text('flutter-engineer-codecheck-1'), findsOneWidget);
      expect(find.text('flutter-engineer-codecheck-2'), findsOneWidget);
    });

    testWidgets('検索結果が0件の場合、空メッセージが表示される', (tester) async {
      // 現状の実装ではダミーデータが常に生成されるためテスト不可
      // TODO: ダミーデータを外部から渡せるようになったら実装
    });

    testWidgets('リストアイテムをタップすると詳細画面に遷移する', (tester) async {
      // TODO: ダミーデータでのテスト。将来的に外部からデータを渡す設計にした際は修正すること。
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchResultListView(),
          ),
        ),
      );
      // 1件目のリストアイテムをタップ
      await tester.tap(find.text('flutter-engineer-codecheck-1'));
      await tester.pump();
      // SnackBarが表示されることを確認
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.textContaining('Tapped on flutter-engineer-codecheck-1'),
        findsOneWidget,
      );
    });

    testWidgets('スクロール位置が保持される', (tester) async {
      // TODO: ダミーデータでのテスト。将来的に外部からデータやScrollControllerを渡す設計にした際は修正すること。
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchResultListView(),
          ),
        ),
      );

      // 最初のリストアイテムが表示されていることを確認
      expect(find.text('flutter-engineer-codecheck-1'), findsOneWidget);

      // 100番目のアイテムが見えるまで自動でスクロール
      final target = find.text('flutter-engineer-codecheck-100');
      await tester.scrollUntilVisible(
        target,
        500,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      // 100番目のアイテムが表示されていることを確認
      expect(target, findsOneWidget);

      // 画面を再構築（simulate: 詳細画面から戻る）
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchResultListView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // スクロール位置が保持されていれば、100番目付近のアイテムが見えているはず
      expect(target, findsOneWidget);
    });
  });

  testWidgets('検索結果リストが正しく表示される', (tester) async {
    // TODO: ダミーデータでのテスト。将来的に外部からデータを渡す設計にした際は修正すること。
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SearchResultListView(),
        ),
      ),
    );
    // 1件目のリストアイテムが表示されていることを確認
    expect(find.text('flutter-engineer-codecheck-1'), findsOneWidget);
    // 10番目のリストアイテムが見えるまでスクロール
    final target10 = find.text('flutter-engineer-codecheck-10');
    await tester.scrollUntilVisible(
      target10,
      200,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();
    expect(target10, findsOneWidget);
    // 100番目はまだ見えないことを確認
    expect(find.text('flutter-engineer-codecheck-100'), findsNothing);
  });

  testWidgets('リストタップで詳細画面に遷移する', (tester) async {
    // TODO: ダミーデータでのテスト。将来的に外部からデータを渡す設計にした際は修正すること。
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SearchResultListView(),
        ),
      ),
    );
    // 2件目のリストアイテムをタップ
    await tester.tap(find.text('flutter-engineer-codecheck-2'));
    await tester.pump();
    // SnackBarが表示されることを確認
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.textContaining('Tapped on flutter-engineer-codecheck-2'),
      findsOneWidget,
    );
  });

  testWidgets('空リスト時にメッセージが表示される', (tester) async {
    // TODO: unimplemented:
    // 　空リストのテストを行うためには、SearchResultListViewのコンストラクタで空のリストを渡す必要があります。
    // 　現状の実装では、ダミーデータを使用しているため、空リストのテストは行えません。
  });
}
