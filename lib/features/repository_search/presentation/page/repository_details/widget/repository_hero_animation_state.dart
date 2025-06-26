import 'package:flutter/material.dart';

/// Heroアニメーションの状態を管理するクラス。
///
/// アニメーションの進行状況や監視状態を一元的に管理し、通知機能を提供します。
class HeroAnimationState extends ChangeNotifier {
  AnimationStatus? _lastAnimationStatus;
  var _isMonitoring = false;
  var _isDisposed = false;

  /// アニメーションが完了しているかどうかを返します。
  bool get isCompleted => _lastAnimationStatus == AnimationStatus.completed;

  /// アニメーションが進行中かどうかを返します。
  bool get isInProgress =>
      _lastAnimationStatus == AnimationStatus.forward ||
      _lastAnimationStatus == AnimationStatus.reverse;

  /// アニメーションが初期状態かどうかを返します。
  bool get isDismissed => _lastAnimationStatus == AnimationStatus.dismissed;

  /// 現在のアニメーション状態を返します。
  AnimationStatus? get currentStatus => _lastAnimationStatus;

  /// 監視中かどうかを返します。
  bool get isMonitoring => _isMonitoring;

  /// アニメーション状態を更新します。
  ///
  /// 状態が変化した場合のみリスナーに通知します。
  void updateStatus(AnimationStatus status) {
    if (_lastAnimationStatus != status) {
      _lastAnimationStatus = status;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) {
          notifyListeners();
        }
      });
    }
  }

  /// 監視を開始します。
  void startMonitoring() {
    _isMonitoring = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  /// 監視を終了します。
  void stopMonitoring() {
    _isMonitoring = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  /// 状態をリセットします。
  void reset() {
    _lastAnimationStatus = null;
    _isMonitoring = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
