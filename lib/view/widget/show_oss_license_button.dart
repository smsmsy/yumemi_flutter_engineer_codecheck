import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

class ShowOssLicenseButton extends StatelessWidget {
  const ShowOssLicenseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
