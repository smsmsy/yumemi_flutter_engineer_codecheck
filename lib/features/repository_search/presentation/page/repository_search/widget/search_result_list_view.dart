import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/common/widget/common_repository_card.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/repository_providers.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/search_history_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/number_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

/// 検索結果のリポジトリ一覧を表示するウィジェット
///
/// RiverpodのProviderから取得したリポジトリ一覧をリスト表示します。
class SearchResultListView extends ConsumerStatefulWidget {
  /// 検索結果リストビューのコンストラクタ
  ///
  /// 必要に応じてkeyを指定できます。
  const SearchResultListView({super.key});

  @override
  ConsumerState<SearchResultListView> createState() =>
      _SearchResultListViewState();
}

/// [SearchResultListView]の状態を管理するStateクラス
class _SearchResultListViewState extends ConsumerState<SearchResultListView> {
  /// 検索結果リストのスクロール制御用コントローラー
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  /// 検索結果の状態に応じてリストやエラー・ローディング表示を切り替えます。
  ///
  /// Providerから取得したリポジトリ一覧をリスト表示し、該当なしやエラー時はメッセージを表示します。
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _buildContent,
    );
  }

  Widget get _buildContent {
    final queryString = ref.watch(
      gitHubSearchQueryNotifierProvider.select((e) => e.q),
    );
    if (queryString.isEmpty) {
      return Center(
        key: const ValueKey('queryEmpty'),
        child: Text(
          AppLocalizations.of(context)?.inputKeyword ??
              WordingData.inputKeyword,
        ),
      );
    }

    final repositoriesAsyncValue = ref.watch(repositoriesSearchResultProvider);

    switch (repositoriesAsyncValue) {
      case AsyncError(:final error):
        return Center(
          key: const ValueKey('error'),
          child: Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      case AsyncData(:final value):
        if (value.isEmpty) {
          return Center(
            key: const ValueKey('listEmpty'),
            child: Text(
              AppLocalizations.of(context)?.noRepository ??
                  WordingData.noRepository,
            ),
          );
        }
        return AdaptiveRepositoryListView(
          key: const ValueKey('list'),
          value: value,
          scrollController: _scrollController,
        );
      case _:
        return const Center(
          key: ValueKey('loading'),
          child: CircularProgressIndicator(),
        );
    }
  }
}

/// レイアウト幅に応じてカラム数が変化するリポジトリ一覧リスト
///
/// 横幅に応じて1〜4カラムでリポジトリをグリッド状に表示します。
class AdaptiveRepositoryListView extends StatelessWidget {
  /// レスポンシブなリポジトリリストのコンストラクタ
  ///
  /// [value]は表示するリポジトリ一覧、[scrollController]はリストのスクロール制御に使用します。
  const AdaptiveRepositoryListView({
    required this.value,
    required this.scrollController,
    super.key,
  });

  /// 表示するリポジトリ一覧
  final List<Repository> value;

  /// リストのスクロール制御用コントローラー
  final ScrollController scrollController;

  @override
  /// レイアウト幅に応じてカラム数を調整し、リポジトリをグリッド状に表示します。
  ///
  /// 横幅に応じて1〜4カラムでリストを構築します。
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = (constraints.maxWidth /
                NumberData.horizontalLayoutThreshold)
            .floor()
            .clamp(1, 4);
        final rowCount = (value.length / columnCount).ceil();
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: NumberData.horizontalLayoutThreshold * columnCount,
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: rowCount,
            itemBuilder: (context, rowIndex) {
              return Row(
                children: List.generate(columnCount, (columnIndex) {
                  final itemIndex = rowIndex * columnCount + columnIndex;
                  if (itemIndex >= value.length) {
                    return const SizedBox.expand();
                  }
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: columnCount > 1 ? 8 : 0,
                      ),
                      child: _SearchResultListItem(
                        repository: value[itemIndex],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Repository>('value', value));
    properties.add(
      DiagnosticsProperty<ScrollController>(
        'scrollController',
        scrollController,
      ),
    );
  }
}

/// 検索結果リスト内のリポジトリアイテムを表示するウィジェット
///
/// リポジトリ名やオーナーアイコン、詳細画面への遷移アクションを含みます。
class _SearchResultListItem extends ConsumerWidget {
  /// 検索結果リストアイテムのコンストラクタ
  ///
  /// [repository]は表示対象のリポジトリ情報です。
  const _SearchResultListItem({required this.repository});

  /// 表示対象のリポジトリ情報
  final Repository repository;

  @override
  /// リポジトリアイテムのウィジェットツリーを構築します。
  ///
  /// ヒーローアニメーションや詳細画面への遷移を含むリストアイテムを返します。
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      // ヒーローアニメーションを使用してリポジトリのリストを表示
      // 詳細画面のHeroと同一のタグを使用することでアニメーションを実現している
      transitionOnUserGestures: true,
      tag: 'repository-${repository.id}-${repository.fullName}',

      child: CommonRepositoryCard(
        repository: repository,
        borderRadius: 8,
        margin: const EdgeInsets.symmetric(vertical: 6),
        showChevron: true,
        onTap: () async {
          if (!context.mounted || !ref.context.mounted) {
            return;
          }
          // 検索キーワードを履歴に追加
          final query = ref.read(gitHubSearchQueryNotifierProvider).q;
          if (query.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 1000), () async {
              await ref.read(searchHistoryProvider.notifier).add(query);
            });
          }
          await GoRouter.of(context).pushNamed('details', extra: repository);
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}
