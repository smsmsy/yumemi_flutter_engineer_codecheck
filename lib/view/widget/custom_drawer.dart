import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/show_oss_license_button.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/theme_mode_select_button.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
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
