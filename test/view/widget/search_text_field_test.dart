import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_text_field.dart';

void main() {
  group('SearchTextField', () {
    testWidgets('labelTextが表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchTextField(labelText: '検索'),
          ),
        ),
      );
      expect(find.text('検索'), findsOneWidget);
    });

    testWidgets('onChangedが呼ばれる', (tester) async {
      String? value;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchTextField(
              onChanged: (v) => value = v,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'abc');
      expect(value, 'abc');
    });

    testWidgets('onCancelButtonPressedが呼ばれる', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchTextField(
              onCancelButtonPressed: () => pressed = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.cancel));
      expect(pressed, isTrue);
    });

    testWidgets('テキスト入力時にTextFieldに表示される', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchTextField(
              controller: controller,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Flutter');
      // pumpでUI更新を反映
      await tester.pump();
      expect(controller.text, 'Flutter');
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('onSubmittedが呼ばれる', (tester) async {
      String? submittedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchTextField(
              onSubmitted: (v) => submittedValue = v,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Dart');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submittedValue, 'Dart');
    });
  });
}
