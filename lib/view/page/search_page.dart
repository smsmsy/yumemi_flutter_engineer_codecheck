import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/custom_drawer.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_result_list_view.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _text = '';

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)?.searchPageTitle ??
                WordingData.searchPageTitle,
          ),
        ),
        drawer: const CustomDrawer(),
        body: Center(
          child: Column(
            children: [
              SearchTextField(
                controller: controller,
                onChanged: (value) {
                  // TODO: リポジトリ検索実行時の実装
                  setState(() {
                    _text = value;
                  });
                },
                onSubmitted: (value) {
                  // TODO: エンターキーや検索ボタンでの検索実行時の実装
                  setState(() {
                    _text = value;
                  });
                },
                onCancelButtonPressed: () {
                  // TODO: リポジトリ検索キャンセル時の実装
                  setState(() {
                    _text = '';
                    controller.clear();
                  });
                },
                labelText:
                    AppLocalizations.of(context)?.searchRepositories ??
                    WordingData.searchRepositories,
              ),
              const SizedBox(height: 8),
              const Expanded(
                child: SearchResultListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(StringProperty('text', _text));
    properties.add(
      DiagnosticsProperty<TextEditingController>('controller', controller),
    );
  }
}
