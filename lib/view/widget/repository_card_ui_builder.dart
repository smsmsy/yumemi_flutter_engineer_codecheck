import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entities/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/repository_layout_strategy.dart';

/// Repository Details Card のUI構築を担当するクラス
///
/// カードの見た目と構造を管理する専用クラス
/// UI構築の責任を分離し、メインのStateクラスをシンプルに保つ
class RepositoryCardUIBuilder {
  const RepositoryCardUIBuilder({
    required this.repository,
    required this.isHeroAnimationCompleted,
    required this.isHeroAnimationInProgress,
  });

  final Repository repository;
  final bool isHeroAnimationCompleted;
  final bool isHeroAnimationInProgress;

  /// カードコンテンツの構築
  ///
  /// リポジトリ情報を表示するカードウィジェットを作成する
  ///
  /// 【構成要素】
  /// - SizedBox.expand: 利用可能な全領域を使用
  /// - Card: マテリアルデザインのカード
  /// - 内容: リポジトリ情報とレイアウト戦略による表示切替
  Widget buildCardContent(BuildContext context) {
    return SizedBox.expand(
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: _buildCardShape(),
        color: _determineCardColor(context),
        child: _buildCardBody(),
      ),
    );
  }

  /// アニメーション時のDecoration構築
  ///
  /// Heroアニメーション中に表示される装飾効果を作成する
  ///
  /// 【効果】
  /// - ボーダー: 角丸16pxの四角形
  /// - 影: アニメーション進行に応じて濃さ・ぼかし・広がりが変化
  /// - 色: 黒色ベース、透明度は animation.value * 0.3
  BoxDecoration buildAnimationDecoration(Animation<double> animation) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3 * animation.value),
          blurRadius: 10 * animation.value,
          spreadRadius: 2 * animation.value,
        ),
      ],
    );
  }

  /// カードの形状を決定
  ///
  /// 角丸16pxの四角形カードを作成する
  /// 統一されたデザインを保つため、角丸値は固定
  RoundedRectangleBorder _buildCardShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
  }

  /// アニメーション状態に応じたカード色を決定
  ///
  /// アニメーションの進行状況によってカードの透明度を調整する
  ///
  /// 【色の変化】
  /// - 完了時: テーマのカード色をそのまま使用
  /// - 進行中: テーマのカード色を80%の透明度で表示
  Color _determineCardColor(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;

    return isHeroAnimationCompleted
        ? cardColor
        : cardColor.withAlpha((255 * 0.8).round());
  }

  /// カード本体の構築
  ///
  /// カード内に表示するコンテンツを作成する
  ///
  /// 【構成】
  /// - Padding: 左右18px、上下18pxの余白
  /// - SingleChildScrollView: 内容が溢れた場合のスクロール対応
  /// - _RepositoryInfo: 実際のリポジトリ情報表示ウィジェット
  Widget _buildCardBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: SingleChildScrollView(
        child: _RepositoryInfo(
          repository: repository,
          isHeroAnimationCompleted: isHeroAnimationCompleted,
          isHeroAnimationInProgress: isHeroAnimationInProgress,
        ),
      ),
    );
  }
}

/// リポジトリ情報を表示するウィジェット
///
/// 画面サイズとアニメーション状態に応じてレイアウト戦略を切り替える
///
/// 【レイアウト戦略】
/// - アニメーション中: MediaQueryで判定（安定性重視）
/// - アニメーション完了後: LayoutBuilderで判定（精度重視）
///
/// 【表示パターン】
/// - 横レイアウト: タイトル上部、左にアイコン、右に詳細情報
/// - 縦レイアウト: アイコン上部、その下にタイトルと詳細情報
class _RepositoryInfo extends StatelessWidget {
  const _RepositoryInfo({
    required this.repository,
    required this.isHeroAnimationCompleted,
    required this.isHeroAnimationInProgress,
  });

  final Repository repository;
  final bool isHeroAnimationCompleted;
  final bool isHeroAnimationInProgress;

  @override
  Widget build(BuildContext context) {
    // アニメーション状態に基づいてレイアウト戦略ウィジェットを選択
    // StatelessWidgetベースのファクトリーパターンで効率的なウィジェットツリーを構築
    return LayoutStrategyFactory.createStrategy(
      isAnimationInProgress: isHeroAnimationInProgress,
      isAnimationCompleted: isHeroAnimationCompleted,
      repository: repository,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
    properties.add(
      DiagnosticsProperty<bool>(
        'isHeroAnimationCompleted',
        isHeroAnimationCompleted,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'isHeroAnimationInProgress',
        isHeroAnimationInProgress,
      ),
    );
  }
}
