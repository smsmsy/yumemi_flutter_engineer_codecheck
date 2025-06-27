import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/common/widget/owner_icon.dart';

/// 共通のリポジトリカードウィジェット。
///
/// リポジトリ情報をカード形式で表示するための汎用ウィジェットです。
/// ListTile形式またはカスタムchildを選択でき、リスト表示や詳細表示など様々な場面で利用できます。
class CommonRepositoryCard extends StatelessWidget {
  /// [repository]の情報を表示するカードを生成します。
  ///
  /// [repository]は表示対象のリポジトリ情報、[onTap]はタップ時のコールバック、
  /// [borderRadius]はカードの角丸、[margin]は外側余白、[showChevron]は右端の矢印アイコン表示、
  /// [useListTile]はListTile形式で表示するか、[child]はカスタムウィジェットを指定します。
  const CommonRepositoryCard({
    required this.repository,
    super.key,
    this.onTap,
    this.borderRadius = 16,
    this.margin = const EdgeInsets.all(8),
    this.showChevron = false,
    this.useListTile = true,
    this.child,
  });

  /// 表示対象のリポジトリ情報。
  final Repository repository;

  /// カードタップ時のコールバック。
  final VoidCallback? onTap;

  /// カードの角丸半径。
  final double borderRadius;

  /// カード外側の余白。
  final EdgeInsetsGeometry margin;

  /// 右端に矢印アイコンを表示するかどうか。
  final bool showChevron;

  /// ListTile形式で表示するかどうか。
  final bool useListTile;

  /// ListTileを使わずカスタムchildを表示したい場合に指定。
  final Widget? child;

  /// カードのウィジェットツリーを構築します。
  ///
  /// ListTile形式またはchildで内容を切り替えます。
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: margin,
      child:
          useListTile
              ? ListTile(
                leading: OwnerIcon(repository: repository, diameter: 20),
                title: Text(
                  repository.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: showChevron ? const Icon(Icons.chevron_right) : null,
                onTap: onTap,
              )
              : child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DoubleProperty('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin));
    properties.add(DiagnosticsProperty<bool>('showChevron', showChevron));
    properties.add(DiagnosticsProperty<bool>('useListTile', useListTile));
  }
}
