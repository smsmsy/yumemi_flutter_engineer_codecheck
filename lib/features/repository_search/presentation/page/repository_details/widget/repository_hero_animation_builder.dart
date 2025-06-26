import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_card_ui_builder.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_monitor.dart';

/// Hero Animation Flight Shuttle の構築を担当するクラス
///
/// Heroアニメーション中の表示効果を管理する専用クラス
/// アニメーション構築の複雑なロジックを分離し、再利用可能にする
class RepositoryHeroAnimationBuilder {
  const RepositoryHeroAnimationBuilder({
    required this.uiBuilder,
    required this.animationMonitor,
  });

  final RepositoryCardUIBuilder uiBuilder;
  final HeroAnimationMonitor animationMonitor;

  /// Hero アニメーションのflightShuttleBuilderのコールバック
  ///
  /// 遷移前後のウィジェットを滑らかにブレンドするアニメーションを構築する
  ///
  /// 【Hero Animation の特徴】
  /// - 遷移開始時: fromHero（遷移元）のウィジェットから開始
  /// - 遷移途中: 両方のウィジェットをブレンド表示
  /// - 遷移完了時: toHero（遷移先）のウィジェットに変化
  ///
  /// 【実装のポイント】
  /// - アニメーション監視は build 処理後に遅延実行
  /// - CrossFadeTransition で遷移前後のウィジェットを滑らかに切り替え
  /// - Transform とDecorationで追加の視覚効果を演出
  Widget buildFlightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    // アニメーション状態の監視を開始
    animationMonitor.monitorFlightAnimation(animation, flightDirection);

    // 遷移前後のウィジェットを取得
    final fromHeroWidget = _extractWidgetFromContext(fromHeroContext);
    final toHeroWidget = _extractWidgetFromContext(toHeroContext);

    // カスタムHero Animation効果を適用
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return _buildAnimatedTransition(
          animation: animation,
          fromWidget: fromHeroWidget,
          toWidget: toHeroWidget,
          direction: flightDirection,
        );
      },
    );
  }

  /// コンテキストからウィジェットを抽出する
  ///
  /// HeroアニメーションのコンテキストからWidget情報を安全に取得する
  /// コンテキストが無効な場合は空のContainerを返す
  Widget _extractWidgetFromContext(BuildContext context) {
    try {
      final widget = context.widget;
      return widget is Hero ? widget.child : widget;
    } on Exception {
      // コンテキストが無効な場合の安全な代替
      return const SizedBox.shrink();
    }
  }

  /// アニメーション遷移効果を構築する
  ///
  /// 標準的なHeroアニメーションのクロスフェード効果を実現する
  ///
  /// 【標準的なHero Animation】
  /// - fromWidget と toWidget を同時に重ねて配置
  /// - アニメーション進行に応じて透明度を反転
  /// - fromWidget: opacity 1.0 → 0.0
  /// - toWidget: opacity 0.0 → 1.0
  /// - 微細なスケール効果で奥行き感を演出
  Widget _buildAnimatedTransition({
    required Animation<double> animation,
    required Widget fromWidget,
    required Widget toWidget,
    required HeroFlightDirection direction,
  }) {
    // 方向に応じて適切なアニメーションカーブを選択
    // push: easeOut - 最初速く、後でゆっくり（ユーザーの操作感を重視）
    // pop: easeIn - 最初ゆっくり、後で速く（戻る操作の自然さを重視）
    final curve =
        direction == HeroFlightDirection.push
            ? Curves.easeOutCubic
            : Curves.easeInCubic;
    final curvedValue = curve.transform(animation.value);

    // 遷移方向に応じた適切なスケール効果の修正
    // push: 詳細画面への移動 - 小さく始まって大きくなる (0.98 → 1.02)
    // pop: 検索画面への戻り - 大きく始まって小さくなる (1.02 → 0.98)
    final scaleValue =
        direction == HeroFlightDirection.push
            ? 0.98 +
                (0.04 * curvedValue) // push: 0.98 → 1.02
            : 1.02 - (0.04 * curvedValue); // pop: 1.02 → 0.98

    return Transform.scale(
      scale: scaleValue,
      child: DecoratedBox(
        decoration: uiBuilder.buildAnimationDecoration(animation),
        child: Stack(
          alignment: Alignment.center,
          children:
              direction == HeroFlightDirection.push
                  ? [
                    // push: 詳細画面へ - 検索画面のカードが下、詳細画面のカードが上
                    Opacity(
                      opacity: 1.0 - curvedValue,
                      child: fromWidget,
                    ),
                    Opacity(
                      opacity: curvedValue,
                      child: toWidget,
                    ),
                  ]
                  : [
                    // pop: 検索画面へ戻る - 詳細画面のカードが下、検索画面のカードが上
                    Opacity(
                      opacity: curvedValue,
                      child: fromWidget,
                    ),
                    Opacity(
                      opacity: 1.0 - curvedValue,
                      child: toWidget,
                    ),
                  ],
        ),
      ),
    );
  }
}
