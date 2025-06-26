import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/common/widget/owner_icon.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_details_info_view.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/number_data.dart';

/// レイアウト判定の戦略を表現する抽象クラスです。
///
/// Flutter向けのStrategyパターンを適用し、StatelessWidgetとして効率的なウィジェットツリー構築を実現します。
abstract class LayoutStrategyWidget extends StatelessWidget {
  /// [repository]を受け取り、レイアウト戦略ウィジェットを初期化します。
  ///
  /// [repository]はレイアウト判定や子ウィジェット生成に利用されます。
  const LayoutStrategyWidget({required this.repository, super.key});

  /// レイアウト判定対象のリポジトリ情報
  final Repository repository;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// MediaQueryを用いたレイアウト判定戦略を提供するウィジェットです。
///
/// アニメーション中の安定したレイアウト判定に特化しています。
class MediaQueryLayoutStrategy extends LayoutStrategyWidget {
  /// [repository]を受け取りMediaQueryベースのレイアウト戦略を初期化します。
  ///
  /// [repository]はレイアウト判定や子ウィジェット生成に利用されます。
  const MediaQueryLayoutStrategy({required super.repository, super.key});

  /// 画面幅に応じてレイアウトを切り替えます。
  ///
  /// MediaQueryから取得した画面幅をもとに、横レイアウトまたは縦レイアウトのウィジェットを返します。
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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

/// LayoutBuilderを用いたレイアウト判定戦略を提供するウィジェットです。
///
/// アニメーション完了後の正確なレイアウト判定に特化しています。
class LayoutBuilderLayoutStrategy extends LayoutStrategyWidget {
  /// [repository]を受け取りLayoutBuilderベースのレイアウト戦略を初期化します。
  ///
  /// [repository]はレイアウト判定や子ウィジェット生成に利用されます。
  const LayoutBuilderLayoutStrategy({required super.repository, super.key});

  /// LayoutBuilderの制約幅に応じてレイアウトを切り替えます。
  ///
  /// 制約幅が閾値以上なら横レイアウト、それ以外は縦レイアウトのウィジェットを返します。
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

/// レイアウト戦略を管理するファクトリーmixinです。
///
/// アニメーション状態に応じて適切なレイアウト戦略ウィジェットを生成します。
/// インスタンス化は想定していません。
mixin LayoutStrategyFactory {
  /// アニメーション状態に応じてレイアウト戦略ウィジェットを生成します。
  ///
  /// [isAnimationInProgress]がtrueの場合はMediaQueryベース、
  /// それ以外はLayoutBuilderベースの戦略を返します。
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

/// リポジトリ情報を横方向レイアウトで表示するウィジェットです。
///
/// レイアウト責任を分離し、再利用性を高めるためのクラスです。
class RepositoryInfoHorizontalLayout extends StatelessWidget {
  /// [repository]を受け取り横レイアウトウィジェットを初期化します。
  ///
  /// [repository]は横レイアウトの各子ウィジェット生成に利用されます。
  const RepositoryInfoHorizontalLayout({required this.repository, super.key});

  /// レイアウト判定対象のリポジトリ情報
  final Repository repository;

  /// 横方向レイアウトのウィジェットツリーを構築します。
  ///
  /// タイトル、アイコン、詳細情報を横並びで表示します。
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

/// リポジトリ情報を縦方向レイアウトで表示するウィジェットです。
///
/// レイアウト責任を分離し、再利用性を高めるためのクラスです。
class RepositoryInfoVerticalLayout extends StatelessWidget {
  /// [repository]を受け取り縦レイアウトウィジェットを初期化します。
  ///
  /// [repository]は縦レイアウトの各子ウィジェット生成に利用されます。
  const RepositoryInfoVerticalLayout({required this.repository, super.key});

  /// レイアウト判定対象のリポジトリ情報
  final Repository repository;

  /// 縦方向レイアウトのウィジェットツリーを構築します。
  ///
  /// アイコン、タイトル、詳細情報を縦並びで表示します。
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

/// リポジトリのタイトルを表示するウィジェットです。
///
/// タイトル表示の責任を分離し、統一したスタイルでリポジトリ名を表示します。
class RepositoryTitle extends StatelessWidget {
  /// [repository]を受け取りタイトル表示ウィジェットを初期化します。
  ///
  /// [repository]はタイトルテキストの内容に利用されます。
  const RepositoryTitle({required this.repository, super.key});

  /// 表示対象のリポジトリ情報
  final Repository repository;

  /// リポジトリ名をスタイル付きテキストで表示します。
  ///
  /// 太字・最大2行・中央揃え・省略記号付きで表示されます。
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
