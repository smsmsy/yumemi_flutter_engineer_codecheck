import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:yumemi_flutter_engineer_codecheck/main.dart';

import 'mock/mock_shared_preferences_async_plarform.dart';

void main() {
  group('hoge', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          MockSharedPreferencesAsyncPlatform();
    });
    testWidgets('Counter increments smoke test', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });
  });
}
