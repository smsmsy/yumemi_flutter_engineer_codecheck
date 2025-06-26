import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_state.dart';

/// Hero アニメーション監視の責任を担うクラス
///
/// Martin Fowler's Extract Class と Strategy Pattern を適用
/// アニメーション監視のロジックを分離し、再利用可能にする
class HeroAnimationMonitor {
  HeroAnimationMonitor(this._state);

  final HeroAnimationState _state;

  /// Hero flight アニメーションの監視を開始
  ///
  /// HeroアニメーションのFlightの監視を開始
  ///
  /// Extract Method リファクタリングを適用
  /// 複雑な監視ロジックを単一の責任を持つメソッドに分離
  void monitorFlightAnimation(
    Animation<double> animation,
    HeroFlightDirection direction,
  ) {
    _state.startMonitoring();

    // 現在の状態を遅延実行で反映（build中の呼び出しを避ける）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _state.updateStatus(animation.status);
    });

    _attachStatusListener(animation);
    _attachValueListener(animation);
  }

  /// コントローラーアニメーションの監視を開始
  void monitorControllerAnimation(AnimationController controller) {
    _attachStatusListener(controller);
    _attachValueListener(controller);
  }

  /// 状態変化リスナーの追加
  ///
  /// Extract Method リファクタリングを適用
  /// リスナー追加の重複コードを統合
  void _attachStatusListener(Animation<double> animation) {
    animation.addStatusListener(_state.updateStatus);
  }

  /// 値変化リスナーの追加
  ///
  /// Extract Method リファクタリングを適用
  /// 必要に応じて拡張可能な構造に変更
  void _attachValueListener(Animation<double> animation) {
    animation.addListener(() {
      // 値の変化に応じた処理（必要に応じて拡張）
      _onAnimationValueChanged(animation.value, animation.status);
    });
  }

  /// アニメーション値変化時の処理
  ///
  /// Template Method パターンの適用ポイント
  /// サブクラスでオーバーライド可能
  void _onAnimationValueChanged(double value, AnimationStatus status) {
    // デフォルトでは何もしない
    // 必要に応じてサブクラスで実装
  }

  /// 監視を停止
  void stopMonitoring() {
    _state.stopMonitoring();
  }

  /// 状態をリセット
  void reset() {
    _state.reset();
  }
}
