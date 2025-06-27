import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_card_ui_builder.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_monitor.dart';

/// HeroアニメーションのFlight Shuttle構築を担うユーティリティクラス。
///
/// アニメーションの視覚効果や遷移ロジックを分離し、再利用性と保守性を高めます。
class RepositoryHeroAnimationBuilder {
  /// [uiBuilder]と[animationMonitor]を受け取り、アニメーション構築に利用します。
  const RepositoryHeroAnimationBuilder({
    required this.uiBuilder,
    required this.animationMonitor,
  });

  /// UI構築用ユーティリティ。
  final RepositoryCardUIBuilder uiBuilder;

  /// アニメーション状態監視用ユーティリティ。
  final HeroAnimationMonitor animationMonitor;

  /// HeroアニメーションのflightShuttleBuilder用コールバック。
  ///
  /// 遷移前後のウィジェットを滑らかにブレンドし、視覚効果を付与します。
  /// アニメーション監視やクロスフェード、スケール効果を組み合わせて演出します。
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

  /// コンテキストからウィジェットを抽出します。
  ///
  /// HeroアニメーションのコンテキストからWidget情報を安全に取得します。
  /// コンテキストが無効な場合は空のSizedBoxを返します。
  Widget _extractWidgetFromContext(BuildContext context) {
    try {
      final widget = context.widget;
      return widget is Hero ? widget.child : widget;
    } on Exception {
      // コンテキストが無効な場合の安全な代替
      return const SizedBox.shrink();
    }
  }

  /// アニメーション遷移効果を構築します。
  ///
  /// fromWidget/toWidgetをクロスフェードし、スケール効果と装飾を付与します。
  /// 遷移方向に応じてアニメーションカーブや重なり順を調整します。
  Widget _buildAnimatedTransition({
    required Animation<double> animation,
    required Widget fromWidget,
    required Widget toWidget,
    required HeroFlightDirection direction,
  }) {
    // 方向に応じて適切なアニメーションカーブを選択
    final curve =
        direction == HeroFlightDirection.push
            ? Curves.easeOutCubic
            : Curves.easeInCubic;
    final curvedValue = curve.transform(animation.value);

    // 遷移方向に応じたスケール効果
    final scaleValue =
        direction == HeroFlightDirection.push
            ? 0.96 + (0.04 * curvedValue)
            : 1.00 - (0.04 * curvedValue);

    return Transform.scale(
      scale: scaleValue,
      child: DecoratedBox(
        decoration: uiBuilder.buildAnimationDecoration(animation),
        child: Stack(
          alignment: Alignment.center,
          children:
              direction == HeroFlightDirection.push
                  ? [
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
