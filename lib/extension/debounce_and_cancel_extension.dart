import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension DebounceAndCancelExtension on Ref {
  /// デバウンス・キャンセル処理を実装した [Dio] を返します。
  ///
  /// - デバウンス処理とは、ユーザーが入力をやめてから一定時間後にリクエストを送信することです。
  ///   例えば、ユーザーがテキストボックスに入力している最中にリクエストを送信しないようにするために使用されます。
  ///   この処理により、ユーザーが入力を完了してから500ms経ったあとにリクエストが送信されます。
  ///   デフォルトの待機時間は500msです。一般的には 500ms 程度で十分とされていますが、必要に応じて変更可能です。
  ///
  /// - キャンセル処理とは、ユーザーがリクエスト中に値の監視をやめた場合にリクエストをキャンセルすることです。
  ///   例えば、ユーザーがテキストボックスに入力中にダイアログごと閉じた時などに発動します。
  ///   この処理により、ユーザーがリクエスト中に値の監視をやめた場合、リクエストはキャンセルされます。
  /// 
  /// 参考 : https://riverpod.dev/docs/case_studies/cancel#going-further-doing-both-at-once
  Future<Dio> getDebouncedHttpClient([Duration? duration]) async {
    var didDispose = false;
    onDispose(() => didDispose = true);

    final completer = Completer<void>();
    final timer = Timer(
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

    final dio = Dio();
    onDispose(dio.close);

    return dio;
  }
}
