import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// リポジトリの詳細情報をカード形式で表示するウィジェット。
///
/// 言語・スター数・ウォッチャー数・フォーク数・オープンイシュー数をアイコン付きで一覧表示します。
class RepositoryDetailsInfoView extends StatelessWidget {
  /// [repository]の情報を受け取り、詳細情報カードを生成します。
  const RepositoryDetailsInfoView({required this.repository, super.key});

  /// 表示対象のリポジトリ情報。
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

  /// リポジトリ情報項目のリストを生成します。
  ///
  /// 各項目はアイコン・ラベル・値を持ち、言語・スター数・ウォッチャー数・フォーク数・オープンイシュー数の順で並びます。
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

  /// 数値をロケールに応じた省略表記に変換します。
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

/// リポジトリ情報項目のデータを保持するクラス。
///
/// アイコン・ラベル・値を1セットとして管理します。
class _InfoRowItem {
  /// [icon]・[label]・[value]を指定して情報項目を生成します。
  const _InfoRowItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  /// 表示用アイコン。
  final IconData icon;

  /// ラベルテキスト。
  final String label;

  /// 値テキスト。
  final String value;
}

/// リポジトリ情報項目を1行で表示するウィジェット。
///
/// アイコン・ラベル・値を横並びでカード内に表示します。
class _InfoRow extends StatelessWidget {
  /// [item]の内容を表示する行ウィジェットを生成します。
  const _InfoRow({required this.item});

  /// 表示する情報項目データ。
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
