import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// リポジトリの詳細情報を表示するウィジェット
///
/// リポジトリの言語、スター数、ウォッチャー数、フォーク数、オープンイシュー数を表示
/// 情報はアイコンとラベル付きでカード形式で表示される
class RepositoryDetailsInfoView extends StatelessWidget {
  const RepositoryDetailsInfoView({required this.repository, super.key});

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
