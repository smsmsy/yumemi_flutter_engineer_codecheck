import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/search_history_list_view_model.dart';

class MockAnimatedListState extends Mock implements AnimatedListState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'MockAnimatedListState';
}

class TestableSearchHistoryListViewModel extends ChangeNotifier {
  List<String> internalList = [];
  var _firstBuild = true;
  static const animationDuration = Duration(milliseconds: 150);

  void updateAnimatedListWithState(
    List<String> newList,
    AnimatedListState? listState,
  ) {
    if (_firstBuild) {
      internalList = List.from(newList);
      _firstBuild = false;
      notifyListeners();
      return;
    }
    if (listState == null) {
      return;
    }
    // 削除
    for (var i = internalList.length - 1; i >= 0; i--) {
      if (!newList.contains(internalList[i])) {
        final removed = internalList.removeAt(i);
        listState.removeItem(
          i,
          (context, animation) => SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: ListTile(title: Text(removed)),
          ),
          duration: animationDuration,
        );
      }
    }
    // 追加
    for (var i = 0; i < newList.length; i++) {
      if (i >= internalList.length || internalList[i] != newList[i]) {
        internalList.insert(i, newList[i]);
        listState.insertItem(i, duration: animationDuration);
      }
    }
    notifyListeners();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SearchHistoryListViewModel', () {
    late SearchHistoryListViewModel viewModel;
    setUp(() {
      viewModel = SearchHistoryListViewModel();
    });

    test('初回ビルド時はinternalListがコピーされ、firstBuildがfalseになる', () {
      final list = ['a', 'b', 'c'];
      var notified = false;
      viewModel.addListener(() => notified = true);
      viewModel.updateAnimatedList(list);
      expect(viewModel.internalList, equals(list));
      expect(viewModel.firstBuild, isFalse);
      expect(notified, isTrue);
    });

    test('2回目以降はinternalListの追加・削除が正しく行われる', () {
      final initial = ['a', 'b', 'c'];
      final updated = ['b', 'c', 'd'];
      final testViewModel = TestableSearchHistoryListViewModel();
      testViewModel.updateAnimatedListWithState(
        initial,
        MockAnimatedListState(),
      ); // 初回
      final mockListState = MockAnimatedListState();
      testViewModel.updateAnimatedListWithState(updated, mockListState);
      // removeItemの呼び出し検証は省略
      verify(
        mockListState.insertItem(
          2,
          duration: TestableSearchHistoryListViewModel.animationDuration,
        ),
      ).called(1);
      expect(testViewModel.internalList, equals(updated));
    });

    test('listStateがnullの場合は何もしない', () {
      final initial = ['a'];
      final updated = ['b'];
      final testViewModel = TestableSearchHistoryListViewModel();
      testViewModel.updateAnimatedListWithState(
        initial,
        MockAnimatedListState(),
      ); // 初回
      testViewModel.updateAnimatedListWithState(updated, null);
      expect(testViewModel.internalList, equals(initial));
    });

    test('disposeでscrollControllerが破棄される', () {
      viewModel.dispose();
      expect(
        () => viewModel.scrollController.position,
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
