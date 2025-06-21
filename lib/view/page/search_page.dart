import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/custom_drawer.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_result_list_view.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_text_field.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
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
                // TODO : onChanged を使用すると、入力中にAPIを叩いてしまうため、現状は onSubmitted のみを使用する。
                // TODO : 例えば、Debounceを使用して、一定時間入力がない場合にAPIを叩くようにするなどして改善後にコメント解除する。
                // onChanged: (value) {
                //   setState(() {
                //     _text = value;
                //   });
                //   ref
                //       .read(gitHubSearchQueryNotifierProvider.notifier)
                //       .setQuery(q: _text);
                // },
                onSubmitted: (value) {
                  setState(() {
                    _text = value;
                  });
                  ref
                      .read(gitHubSearchQueryNotifierProvider.notifier)
                      .setQuery(q: _text);
                },
                onCancelButtonPressed: () {
                  setState(() {
                    _text = '';
                    controller.clear();
                  });
                  ref
                      .read(gitHubSearchQueryNotifierProvider.notifier)
                      .setQuery(q: '');
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
