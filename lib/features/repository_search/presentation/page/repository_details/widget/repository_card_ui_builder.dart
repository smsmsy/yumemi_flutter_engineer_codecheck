import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/common/widget/common_repository_card.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_layout_strategy.dart';

/// リポジトリ詳細カードのUI構築を担うユーティリティ。
///
/// Stateクラスの肥大化を防ぎ、UI構築の責務を分離します。
/// アニメーション状態やリポジトリ情報に応じて柔軟にUIを生成します。
class RepositoryCardUIBuilder {
  /// [repository]の情報とHeroアニメーション状態を受け取り、UI構築に利用します。
  ///
  /// [repository]は表示対象のリポジトリ情報、
  /// [isHeroAnimationCompleted]・[isHeroAnimationInProgress]はアニメーション状態を示します。
  const RepositoryCardUIBuilder({
    required this.repository,
    required this.isHeroAnimationCompleted,
    required this.isHeroAnimationInProgress,
  });

  /// 表示するリポジトリ情報。
  final Repository repository;

  /// Heroアニメーションが完了しているかどうか。
  final bool isHeroAnimationCompleted;

  /// Heroアニメーションが進行中かどうか。
  final bool isHeroAnimationInProgress;

  /// カード全体のUIを構築します。
  ///
  /// リポジトリ情報をカード形式で表示し、アニメーション状態に応じて見た目を調整します。
  Widget buildCardContent(BuildContext context) {
    return SizedBox.expand(
      child: CommonRepositoryCard(
        repository: repository,
        useListTile: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: SingleChildScrollView(
            child: _RepositoryInfo(
              repository: repository,
              isHeroAnimationCompleted: isHeroAnimationCompleted,
              isHeroAnimationInProgress: isHeroAnimationInProgress,
            ),
          ),
        ),
      ),
    );
  }

  /// アニメーション中の装飾（影や角丸）を生成します。
  ///
  /// Heroアニメーションの進行度に応じて影や透明度を動的に変化させます。
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
}

/// リポジトリ情報を表示する内部ウィジェット。
///
/// アニメーション状態や画面サイズに応じてレイアウト戦略を切り替えます。
/// レイアウト戦略の選択はファクトリーパターンで実装されています。
class _RepositoryInfo extends StatelessWidget {
  /// リポジトリ情報を表示するウィジェット。
  ///
  /// [repository]は表示対象を示し、
  /// [isHeroAnimationCompleted]・[isHeroAnimationInProgress]はアニメーション状態を示します。
  const _RepositoryInfo({
    required this.repository,
    required this.isHeroAnimationCompleted,
    required this.isHeroAnimationInProgress,
  });

  /// 表示するリポジトリ情報。
  final Repository repository;

  /// Heroアニメーションが完了しているかどうか。
  final bool isHeroAnimationCompleted;

  /// Heroアニメーションが進行中かどうか。
  final bool isHeroAnimationInProgress;

  @override
  Widget build(BuildContext context) {
    /// レイアウト戦略を選択し、最適なUIを構築します。
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
