import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entities/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/number_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/owner_icon.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/repository_details_info_view.dart';

/// レイアウト判定の戦略インターフェース
///
/// Flutter最適化されたStrategy Pattern を適用
/// StatelessWidgetベースで効率的なウィジェットツリーを構築
abstract class LayoutStrategyWidget extends StatelessWidget {
  const LayoutStrategyWidget({required this.repository, super.key});

  final Repository repository;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// MediaQuery ベースのレイアウト判定戦略
///
/// StatelessWidgetベースのStrategy Pattern
/// アニメーション中の安定した判定に特化
class MediaQueryLayoutStrategy extends LayoutStrategyWidget {
  const MediaQueryLayoutStrategy({required super.repository, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final availableWidth = screenWidth - 32; // マージンとパディングを考慮

    return _createLayoutWidget(screenWidth);
  }

  Widget _createLayoutWidget(double availableWidth) {
    if (availableWidth >= NumberData.horizontalLayoutThresholdWithoutPadding) {
      return RepositoryInfoHorizontalLayout(repository: repository);
    } else {
      return RepositoryInfoVerticalLayout(repository: repository);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// LayoutBuilder ベースのレイアウト判定戦略
///
/// StatelessWidgetベースのStrategy Pattern
/// アニメーション完了後の正確な判定に特化
class LayoutBuilderLayoutStrategy extends LayoutStrategyWidget {
  const LayoutBuilderLayoutStrategy({required super.repository, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _createLayoutWidget(constraints.maxWidth);
      },
    );
  }

  Widget _createLayoutWidget(double width) {
    if (width >= NumberData.horizontalLayoutThresholdWithoutPadding) {
      return RepositoryInfoHorizontalLayout(repository: repository);
    } else {
      return RepositoryInfoVerticalLayout(repository: repository);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// レイアウト戦略を管理するファクトリークラス
///
/// StatelessWidgetベースのFactory Method Pattern
/// アニメーション状態に応じて適切な戦略ウィジェットを生成
///
/// Note: このクラスは名前空間として機能し、インスタンス化を想定していません
mixin LayoutStrategyFactory {
  static LayoutStrategyWidget createStrategy({
    required bool isAnimationInProgress,
    required bool isAnimationCompleted,
    required Repository repository,
  }) {
    if (isAnimationInProgress) {
      return MediaQueryLayoutStrategy(repository: repository);
    } else {
      return LayoutBuilderLayoutStrategy(repository: repository);
    }
  }
}

/// リポジトリ情報の横方向に長いレイアウト用のウィジェット
///
/// Martin Fowler's Extract Class を適用
/// レイアウト責任を分離し、再利用性を向上
class RepositoryInfoHorizontalLayout extends StatelessWidget {
  const RepositoryInfoHorizontalLayout({required this.repository, super.key});
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepositoryTitle(repository: repository),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OwnerIcon(repository: repository, diameter: 80),
            const SizedBox(width: 24),
            Expanded(
              child: RepositoryDetailsInfoView(repository: repository),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// リポジトリ情報の縦方向に長いレイアウト用のウィジェット
///
/// Martin Fowler's Extract Class を適用
/// レイアウト責任を分離し、再利用性を向上
class RepositoryInfoVerticalLayout extends StatelessWidget {
  const RepositoryInfoVerticalLayout({required this.repository, super.key});
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OwnerIcon(repository: repository, diameter: 80),
        const SizedBox(height: 12),
        RepositoryTitle(repository: repository),
        const SizedBox(height: 16),
        RepositoryDetailsInfoView(repository: repository),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// リポジトリのタイトルを表示するウィジェット
///
/// Martin Fowler's Extract Class を適用
/// タイトル表示の責任を分離し、統一したスタイルを適用
///
/// テキストスタイル:
/// - 太字ヘッドライン
/// - 最大2行表示
/// - オーバーフロー時は省略記号
/// - 中央揃え
class RepositoryTitle extends StatelessWidget {
  const RepositoryTitle({required this.repository, super.key});
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      repository.name,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.center,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}
