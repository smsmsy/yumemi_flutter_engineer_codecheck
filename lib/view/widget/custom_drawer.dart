import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            title: Text(
              AppLocalizations.of(context)?.ossLicense ??
                  WordingData.ossLicense,
            ),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: WordingData.applicationName,
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}
