import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_details_card.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// リポジトリの詳細情報を表示するページウィジェット
///
/// 指定されたリポジトリの詳細情報を画面に表示します。
/// AppBarにはリポジトリ詳細のタイトルと戻るボタンが表示されます。
class RepositoryDetailsPage extends StatelessWidget {
  /// [repository]の詳細情報を表示するページのコンストラクタ
  ///
  /// [repository]には表示対象のリポジトリ情報を渡します。
  const RepositoryDetailsPage({required this.repository, super.key});

  /// 表示対象のリポジトリ情報
  ///
  /// 詳細カードやタイトル表示に利用されます。
  final Repository repository;

  @override
  /// リポジトリ詳細ページのウィジェットツリーを構築します。
  ///
  /// AppBarやリポジトリ詳細カードを含む画面全体のレイアウトを返します。
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)?.repoDetailsInfo ??
              WordingData.repoDetailsInfo,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: RepositoryDetailsCard(repository: repository),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}
