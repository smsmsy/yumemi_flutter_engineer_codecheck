import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/number_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/custom_drawer.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_result_list_view.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/search_text_field.dart';

class RepositorySearchPage extends ConsumerStatefulWidget {
  const RepositorySearchPage({super.key});

  @override
  ConsumerState<RepositorySearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<RepositorySearchPage> {
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
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: NumberData.horizontalLayoutThreshold,
                ),
                child: SearchTextField(
                  controller: controller,
                  onChanged: (value) {
                    ref
                        .read(gitHubSearchQueryNotifierProvider.notifier)
                        .setQuery(q: value);
                  },
                  onSubmitted: (value) {
                    ref
                        .read(gitHubSearchQueryNotifierProvider.notifier)
                        .setQuery(q: value);
                  },
                  onCancelButtonPressed: () {
                    setState(controller.clear);
                    ref
                        .read(gitHubSearchQueryNotifierProvider.notifier)
                        .setQuery(q: '');
                  },
                  labelText:
                      AppLocalizations.of(context)?.searchRepositories ??
                      WordingData.searchRepositories,
                ),
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

    properties.add(
      DiagnosticsProperty<TextEditingController>('controller', controller),
    );
  }
}
