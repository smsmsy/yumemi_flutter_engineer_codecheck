import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/show_oss_license_button.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/theme_mode_select_button.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// アプリケーションのカスタムドロワーメニューを表示するウィジェット
///
/// テーマ切り替えやOSSライセンス表示などのメニュー項目を含みます。
class CustomDrawer extends ConsumerWidget {
  /// カスタムドロワーのコンストラクタ
  ///
  /// 必要に応じてkeyを指定できます。
  const CustomDrawer({super.key});

  @override
  /// ドロワーメニューのウィジェットツリーを構築します。
  ///
  /// アプリ名のヘッダーやテーマ切り替え、OSSライセンス表示ボタンを含むリストを返します。
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            duration: Duration.zero,
            child: Text(
              WordingData.applicationName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const ThemeModeSelectButton(),
          const ShowOssLicenseButton(),
        ],
      ),
    );
  }
}
