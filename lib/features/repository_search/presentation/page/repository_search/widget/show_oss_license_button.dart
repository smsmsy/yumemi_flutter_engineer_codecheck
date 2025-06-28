import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// OSSライセンスページを表示するボタンのウィジェットです。
///
/// このウィジェットはリストタイルとしてOSSライセンスページへの遷移ボタンを提供します。
class ShowOssLicenseButton extends StatelessWidget {
  /// ShowOssLicenseButtonのコンストラクタ。
  ///
  /// [key]はウィジェットの一意性を識別するために使用されます。
  const ShowOssLicenseButton({super.key});

  /// OSSライセンスページを表示するListTileを構築します。
  ///
  /// タップ時にOSSライセンスページへ遷移します。
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
        horizontal: VisualDensity.minimumDensity,
      ),
      leading: const Icon(Icons.info),
      title: Text(
        AppLocalizations.of(context)?.ossLicense ?? WordingData.ossLicense,
      ),
      onTap: () {
        showLicensePage(
          context: context,
          applicationName: WordingData.applicationName,
          applicationVersion: '1.0.0',
        );
      },
    );
  }
}
