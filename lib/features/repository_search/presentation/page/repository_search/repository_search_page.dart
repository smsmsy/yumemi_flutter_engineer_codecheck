import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/custom_drawer.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/search_result_list_view.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/search_text_field.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/repository_providers.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/number_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// リポジトリ検索ページのウィジェットです。
///
/// このウィジェットは、GitHubリポジトリの検索機能を提供するページ全体の構成を担います。
class RepositorySearchPage extends ConsumerStatefulWidget {
  /// RepositorySearchPageのコンストラクタ。
  ///
  /// [key]はウィジェットの一意性を識別するために使用されます。
  const RepositorySearchPage({super.key});

  @override
  ConsumerState<RepositorySearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<RepositorySearchPage> {
  /// 検索テキストフィールドの入力内容を管理するコントローラーです。
  final controller = TextEditingController();

  /// リポジトリ検索ページのUIを構築します。
  ///
  /// 検索テキストフィールドや検索結果リストなど、ページ全体のレイアウトを定義します。
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
        drawer: CustomDrawer(
          onHistoryTap: (value) {
            controller.text = value;
            _setQuery(value);
          },
        ),
        body: Center(
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: NumberData.horizontalLayoutThreshold,
                ),
                child: SearchTextField(
                  controller: controller,
                  onChanged: _setQuery,
                  onSubmitted: _setQuery,
                  onCancelButtonPressed: () {
                    setState(controller.clear);
                    _setQuery('');
                  },
                  labelText:
                      AppLocalizations.of(context)?.searchRepositories ??
                      WordingData.searchRepositories,
                ),
              ),
              const SizedBox(height: NumberData.paddingSmall),
              const Expanded(
                child: SearchResultListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setQuery(String value) =>
      ref.read(gitHubSearchQueryNotifierProvider.notifier).setQuery(q: value);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      DiagnosticsProperty<TextEditingController>('controller', controller),
    );
  }
}
