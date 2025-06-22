import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/extension/debounce_and_cancel_extension.dart';

/// デバウンス処理とキャンセル処理を実装したDioのFutureProvider
///
/// - params には以下のキーを含むMapを渡す必要があります:
///   - `duration`: デバウンスの遅延時間（Duration型）
///   - `dio`: オプションでDioインスタンスを指定できます（Dio型）
///   - `timerFactory`: オプションでTimerの生成方法を指定できます
///     （`Timer Function(Duration duration, void Function() callback)`型）
final FutureProviderFamily<Dio, Map<String, dynamic>> _debouncedDioProvider =
    FutureProvider.family<Dio, Map<String, dynamic>>((ref, params) {
      return ref.getDebouncedHttpClient(
        duration: params['duration'] as Duration?,
        dio: params['dio'] as Dio?,
        timerFactory:
            params['timerFactory']
                as Timer Function(Duration, void Function())?,
      );
    });

void main() {
  group('HTTPリクエストのデバウンス処理とキャンセル処理を実装したRef拡張のテスト', () {
    test('デバウンス後にDioが返る', () async {
      final container = ProviderContainer();
      var timerCalled = false;
      final dio = Dio();
      Timer timerFactory(Duration duration, void Function() callback) {
        timerCalled = true;
        return Timer(duration, callback);
      }

      final params = {
        'duration': const Duration(milliseconds: 10),
        'dio': dio,
        'timerFactory': timerFactory,
      };
      // Futureを取得してからdisposeする
      // これにより、デバウンス後にDioが返ることを確認する
      // また、timerFactoryが呼ばれたことも確認する
      final result = await container.read(_debouncedDioProvider(params).future);
      expect(result, equals(dio));
      expect(timerCalled, isTrue);
      // awaitの後にdisposeすることで、disposeによるキャンセル例外を回避
      container.dispose();
    });

    test('キャンセル時に例外が投げられる', () {
      final container = ProviderContainer();
      Timer timerFactory(Duration duration, void Function() callback) {
        return Timer(duration, callback);
      }

      final params = {
        'duration': const Duration(seconds: 1),
        'timerFactory': timerFactory,
      };
      // Futureを取得してからdisposeする
      // これにより、キャンセル時に例外が投げられることを確認する
      final future = container.read(_debouncedDioProvider(params).future);
      container.dispose();
      expect(future, throwsException);
    });

    test('デバウンス中にdisposeするとTimerがキャンセルされる', () {
      final container = ProviderContainer();
      var timerCancelled = false;
      _TestTimer timerFactory(Duration duration, void Function() callback) {
        return _TestTimer(
          duration,
          callback,
          onCancel: () {
            timerCancelled = true;
          },
        );
      }

      final params = {
        'duration': const Duration(seconds: 1),
        'timerFactory': timerFactory,
      };
      // Futureを取得してからdisposeする
      // これにより、タイマーがキャンセルされることを確認する
      final future = container.read(_debouncedDioProvider(params).future);
      container.dispose();
      expect(timerCancelled, isTrue);
      expect(future, throwsException);
    });
  });
}

/// テスト用のTimer実装
///
/// 実際のTimerではなく、Future.delayedを使用して非同期処理を模倣します。
class _TestTimer implements Timer {
  /// コンストラクタ
  ///
  /// - duration : タイマーの遅延時間
  /// - callback : タイマーが完了したときに呼び出されるコールバック関数
  /// - onCancel : タイマーがキャンセルされたときに呼び出されるコールバック関数
  ///
  /// デフォルトでは何もしません。
  _TestTimer(
    Duration duration,
    void Function() callback, {
    void Function()? onCancel,
  }) : _onCancel = onCancel ?? (() {}) {
    Future.delayed(duration, () {
      if (_isActive) {
        callback();
      }
    });
  }

  /// キャンセル時に呼ばれるコールバック
  final void Function() _onCancel;

  /// キャンセル状態を管理するフラグ
  var _isActive = true;

  /// Timerのキャンセル処理
  @override
  void cancel() {
    _isActive = false;
    _onCancel();
  }

  /// Timerの状態を確認するためのフラグ
  @override
  bool get isActive => _isActive;

  /// Timerの残り時間を取得するためのメソッド
  @override
  int get tick => 0;
}
