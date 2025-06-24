import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/owner_icon.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/repository_details_info_view.dart';

/// GitHubリポジトリ詳細表示ウィジェット
///
/// リポジトリの情報をカード形式で表示
/// レイアウトは画面幅に応じて縦横切り替え
class RepositoryDetailsCard extends StatelessWidget {
  const RepositoryDetailsCard({required this.repository, super.key});
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        // ヒーローアニメーションを使用してリポジトリの詳細を表示
        // 検索画面のリストビューと同一のタグを使用することで実現している
        transitionOnUserGestures: true,
        tag: 'repository-${repository.name}',
        child: SizedBox.expand(
          child: Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: SingleChildScrollView(
                child: _RepositoryInfo(repository: repository),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// リポジトリ情報を表示するウィジェット
///
/// 画面幅に応じて縦横のレイアウトを切り替える
/// - 横レイアウト: タイトルとオーナーアイコンを横並び
/// - 縦レイアウト: タイトルの下にオーナーアイコン
class _RepositoryInfo extends StatelessWidget {
  const _RepositoryInfo({required this.repository});
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return _RepositoryInfoHorizontalLayout(repository: repository);
        } else {
          return _RepositoryInfoVerticalLayout(repository: repository);
        }
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// リポジトリ情報の縦方向に長いレイアウト用のウィジェット
class _RepositoryInfoVerticalLayout extends StatelessWidget {
  const _RepositoryInfoVerticalLayout({
    required this.repository,
  });

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OwnerIcon(repository: repository, diameter: 80),
        const SizedBox(height: 12),
        _RepositoryTitle(repository: repository),
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

/// リポジトリ情報の横方向に長いレイアウト用のウィジェット
class _RepositoryInfoHorizontalLayout extends StatelessWidget {
  const _RepositoryInfoHorizontalLayout({
    required this.repository,
  });

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RepositoryTitle(repository: repository),
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

/// リポジトリのタイトルを表示するウィジェット
///
/// タイトルは太字で、最大2行まで表示
/// オーバーフロー時は省略記号を表示
/// テキストは中央揃え
class _RepositoryTitle extends StatelessWidget {
  const _RepositoryTitle({required this.repository});
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
