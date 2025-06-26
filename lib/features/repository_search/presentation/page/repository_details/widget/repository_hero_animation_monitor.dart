import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_state.dart';

/// Heroアニメーションの監視・管理を担うユーティリティクラス。
///
/// アニメーションの状態監視やリスナー管理を分離し、再利用性と保守性を高めます。
class HeroAnimationMonitor {
  /// [_state]を受け取り、アニメーション監視の状態管理に利用します。
  HeroAnimationMonitor(this._state);

  /// アニメーション状態を管理する内部状態クラス。
  final HeroAnimationState _state;

  /// Heroアニメーションのflightアニメーション監視を開始します。
  ///
  /// アニメーションの状態変化や値変化を監視し、必要に応じて状態を更新します。
  void monitorFlightAnimation(
    Animation<double> animation,
    HeroFlightDirection direction,
  ) {
    _state.startMonitoring();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _state.updateStatus(animation.status);
    });
    _attachStatusListener(animation);
    _attachValueListener(animation);
  }

  /// AnimationControllerによるアニメーション監視を開始します。
  void monitorControllerAnimation(AnimationController controller) {
    _attachStatusListener(controller);
    _attachValueListener(controller);
  }

  /// アニメーションの状態変化リスナーを追加します。
  void _attachStatusListener(Animation<double> animation) {
    animation.addStatusListener(_state.updateStatus);
  }

  /// アニメーションの値変化リスナーを追加します。
  void _attachValueListener(Animation<double> animation) {
    animation.addListener(() {
      _onAnimationValueChanged(animation.value, animation.status);
    });
  }

  /// アニメーション値変化時の処理。
  ///
  /// 必要に応じてサブクラスでオーバーライドして拡張可能です。
  void _onAnimationValueChanged(double value, AnimationStatus status) {
    // デフォルトでは何もしません。
  }

  /// 監視を停止します。
  void stopMonitoring() {
    _state.stopMonitoring();
  }

  /// 状態をリセットします。
  void reset() {
    _state.reset();
  }
}
