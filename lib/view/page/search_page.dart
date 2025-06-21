import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/custom_drawer.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/theme_mode_select_button.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.searchPageTitle ??
              WordingData.searchPageTitle,
        ),
        actions: const [
          ThemeModeSelectButton(),
        ],
      ),
      drawer: const CustomDrawer(),
    );
  }
}
