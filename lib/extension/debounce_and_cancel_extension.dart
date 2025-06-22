import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// テストや共通設定のためにDioやTimerの注入を可能にした拡張
extension DebounceAndCancelExtension on Ref {
  /// デバウンス・キャンセル処理を実装した [Dio] を返します。
  ///
  /// [dio] でDioインスタンスを注入できます。未指定時は新規生成。
  /// [timerFactory] でTimerの生成方法を注入できます（テスト用）。
  ///
  /// - デバウンス処理とは、ユーザーが入力をやめてから一定時間後にリクエストを送信することです。<BR>
  ///   例えば、ユーザーがテキストボックスに入力している最中にリクエストを送信しないようにするために使用されます。<BR>
  ///   この処理により、ユーザーが入力を完了してから500ms経ったあとにリクエストが送信されます。<BR>
  ///   デフォルトの待機時間は500msです。一般的には 500ms 程度で十分とされていますが、必要に応じて変更可能です。<BR>
  ///
  /// - キャンセル処理とは、ユーザーがリクエスト中に値の監視をやめた場合にリクエストをキャンセルすることです。<BR>
  ///   例えば、ユーザーがテキストボックスに入力中にダイアログごと閉じた時などに発動します。<BR>
  ///   この処理により、ユーザーがリクエスト中に値の監視をやめた場合、リクエストはキャンセルされます。<BR>
  ///
  /// 参考 : https://riverpod.dev/docs/case_studies/cancel#going-further-doing-both-at-once
  Future<Dio> getDebouncedHttpClient({
    Duration? duration,
    Dio? dio,
    Timer Function(Duration duration, void Function() callback)? timerFactory,
  }) async {
    var didDispose = false;
    onDispose(() => didDispose = true);

    final completer = Completer<void>();
    final timer = (timerFactory ?? Timer.new)(
      duration ?? const Duration(milliseconds: 500),
      completer.complete,
    );
    onDispose(() {
      timer.cancel();
      if (!completer.isCompleted) {
        completer.completeError(Exception('Cancelled'));
      }
    });

    await completer.future;

    if (didDispose) {
      throw Exception('Cancelled');
    }

    final client = dio ?? Dio();
    onDispose(client.close);

    return client;
  }
}
