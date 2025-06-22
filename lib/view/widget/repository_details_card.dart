import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

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
        _OwnerIcon(repository: repository),
        const SizedBox(height: 12),
        _RepositoryTitle(repository: repository),
        const SizedBox(height: 16),
        _RepositoryDetailsInfoView(repository: repository),
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
            _OwnerIcon(repository: repository),
            const SizedBox(width: 24),
            Expanded(
              child: _RepositoryDetailsInfoView(repository: repository),
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

/// リポジトリのオーナーのアバター画像を表示するウィジェット
///
/// オーナーが設定されていない場合や画像の読み込みに失敗した場合はデフォルトのアイコンを表示
/// 読み込み中はCircularProgressIndicatorを表示
class _OwnerIcon extends StatelessWidget {
  const _OwnerIcon({required this.repository});
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = repository.owner?.avatarUrl;

    if (avatarUrl == null || avatarUrl.isEmpty) {
      return _buildDefaultAvatar(context);
    }

    return _DecoratedAvatarCircle(
      child: ClipOval(
        child: Image.network(
          avatarUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: _buildDefaultAvatar,
          loadingBuilder: _buildImageLoadingIndicator,
        ),
      ),
    );
  }

  /// デフォルトのアバターを構築する
  ///
  /// Ownerがセットされてなかったりエラー時に表示されるウィジェット
  Widget _buildDefaultAvatar(
    BuildContext context, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    return _DecoratedAvatarCircle(
      child: Icon(
        Icons.person,
        size: 40,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// ネットワーク画像のローディング表示を構築する
  ///
  /// 読み込み中はCircularProgressIndicatorを表示し、完了時は子ウィジェットをそのまま表示
  Widget _buildImageLoadingIndicator(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    // 読み込み完了時は子ウィジェットをそのまま表示
    if (loadingProgress == null) {
      return child;
    }

    // 読み込み進捗を計算
    final progress = _calculateLoadingProgress(loadingProgress);

    return _DecoratedAvatarCircle(
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 2,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  /// 読み込み進捗を計算する（0.0〜1.0の範囲）
  double? _calculateLoadingProgress(ImageChunkEvent loadingProgress) {
    final expectedTotalBytes = loadingProgress.expectedTotalBytes;
    if (expectedTotalBytes == null) {
      return null; // 不定進捗
    }

    return loadingProgress.cumulativeBytesLoaded / expectedTotalBytes;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// 飾りが施されたCircleAvatarウィジェット
///
/// 影と背景色を持つ円形のアバターを表示
class _DecoratedAvatarCircle extends StatelessWidget {
  const _DecoratedAvatarCircle({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.shadow.withAlpha((255 * 0.3).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: child,
      ),
    );
  }
}

/// リポジトリの詳細情報を表示するウィジェット
///
/// リポジトリの言語、スター数、ウォッチャー数、フォーク数、オープンイシュー数を表示
/// 情報はアイコンとラベル付きでカード形式で表示される
class _RepositoryDetailsInfoView extends StatelessWidget {
  const _RepositoryDetailsInfoView({required this.repository});

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      children:
          _buildInfoItems(
            context,
            AppLocalizations.of(context),
          ).map((item) => _InfoRow(item: item)).toList(),
    );
  }

  /// リポジトリ情報項目のリストを構築
  ///
  /// 各項目はアイコン、ラベル、値を持つ
  /// プロジェクト言語、スター数、ウォッチャー数、フォーク数、オープンイシュー数の順で表示
  List<_InfoRowItem> _buildInfoItems(
    BuildContext context,
    AppLocalizations? l10n,
  ) {
    return [
      _InfoRowItem(
        icon: Icons.code,
        label: l10n?.repoLanguage ?? WordingData.repoLanguage,
        value: repository.language ?? WordingData.unknownLanguage,
      ),
      _InfoRowItem(
        icon: Icons.star,
        label: l10n?.repoStars ?? WordingData.repoStars,
        value: _formatNumber(context, repository.stargazersCount),
      ),
      _InfoRowItem(
        icon: Icons.visibility,
        label: l10n?.repoWatchers ?? WordingData.repoWatchers,
        value: _formatNumber(context, repository.watchersCount),
      ),
      _InfoRowItem(
        icon: Icons.call_split,
        label: l10n?.repoForks ?? WordingData.repoForks,
        value: _formatNumber(context, repository.forksCount),
      ),
      _InfoRowItem(
        icon: Icons.error_outline,
        label: l10n?.repoIssues ?? WordingData.repoIssues,
        value: _formatNumber(context, repository.openIssuesCount),
      ),
    ];
  }

  String _formatNumber(BuildContext context, int number) {
    final localeString = Localizations.localeOf(context).toString();
    return NumberFormat.compact(locale: localeString).format(number);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// リポジトリ情報項目のデータクラス
class _InfoRowItem {
  const _InfoRowItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

/// リポジトリ情報項目を表示するウィジェット
///
/// アイコン、ラベル、値を横並びで表示
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final _InfoRowItem item;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              item.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_InfoRowItem>('item', item));
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
