import 'package:flutter/material.dart';

/// Hero アニメーションの状態を管理するクラス
///
/// Martin Fowler's Extract Class リファクタリングを適用
/// アニメーション状態の管理責任を単一のクラスに集約
class HeroAnimationState extends ChangeNotifier {
  AnimationStatus? _lastAnimationStatus;
  var _isMonitoring = false;
  var _isDisposed = false;

  /// アニメーションが完了しているかどうか
  bool get isCompleted => _lastAnimationStatus == AnimationStatus.completed;

  /// アニメーションが進行中かどうか
  bool get isInProgress =>
      _lastAnimationStatus == AnimationStatus.forward ||
      _lastAnimationStatus == AnimationStatus.reverse;

  /// アニメーションが初期状態かどうか
  bool get isDismissed => _lastAnimationStatus == AnimationStatus.dismissed;

  /// 現在の状態
  AnimationStatus? get currentStatus => _lastAnimationStatus;

  /// 監視中かどうか
  bool get isMonitoring => _isMonitoring;

  /// アニメーション状態を更新
  void updateStatus(AnimationStatus status) {
    if (_lastAnimationStatus != status) {
      _lastAnimationStatus = status;

      // build中の呼び出しを避けるため、フレーム後に通知を延期
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // dispose済みでない場合のみ通知
        if (!_isDisposed) {
          notifyListeners();
        }
      });
    }
  }

  /// 監視開始
  void startMonitoring() {
    _isMonitoring = true;

    // build中の呼び出しを避けるため、フレーム後に通知を延期
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // dispose済みでない場合のみ通知
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  /// 監視終了
  void stopMonitoring() {
    _isMonitoring = false;
    // build中の呼び出しを避けるため、フレーム後に通知を延期
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // dispose済みでない場合のみ通知
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  /// 状態をリセット
  void reset() {
    _lastAnimationStatus = null;
    _isMonitoring = false;
    // build中の呼び出しを避けるため、フレーム後に通知を延期
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // dispose済みでない場合のみ通知
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
