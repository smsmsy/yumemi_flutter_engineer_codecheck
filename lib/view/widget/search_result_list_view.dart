import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/number_data.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/widget/owner_icon.dart';

class SearchResultListView extends ConsumerStatefulWidget {
  const SearchResultListView({super.key});

  @override
  ConsumerState<SearchResultListView> createState() =>
      _SearchResultListViewState();
}

class _SearchResultListViewState extends ConsumerState<SearchResultListView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repositoriesAsyncValue = ref.watch(repositoriesSearchResultProvider);

    if (repositoriesAsyncValue.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (repositoriesAsyncValue.hasError) {
      return Center(
        child: Text(
          'エラーが発生しました: ${repositoriesAsyncValue.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    if (repositoriesAsyncValue.isRefreshing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final repositories = repositoriesAsyncValue.requireValue;

    if (repositories.isEmpty) {
      return const Center(
        child: Text('該当するリポジトリはありません'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount =
            (constraints.maxWidth / NumberData.textFieldConstraintWidth).ceil();
        final rowCount = (repositories.length / columnCount).ceil();

        return ListView.builder(
          controller: _scrollController,
          itemCount: rowCount,
          itemBuilder: (context, rowIndex) {
            return Row(
              children: List.generate(columnCount, (columnIndex) {
                final itemIndex = rowIndex * columnCount + columnIndex;
                if (itemIndex >= repositories.length) {
                  return const Expanded(child: SizedBox.shrink());
                }
                return Expanded(
                  child: _SearchResultListItem(
                    repository: repositories[itemIndex],
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}

class _SearchResultListItem extends StatelessWidget {
  const _SearchResultListItem({required this.repository});

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Hero(
      // ヒーローアニメーションを使用してリポジトリのリストを表示
      // 詳細画面のHeroと同一のタグを使用することでアニメーションを実現している
      transitionOnUserGestures: true,
      tag: 'repository-${repository.name}',

      child: Card(
        // リポジトリのカード
        elevation: 2,
        // カードの影の深さ
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: OwnerIcon(repository: repository, diameter: 20),
          title: Text(
            repository.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          onTap: () async {
            await GoRouter.of(
              context,
            ).pushNamed('details', extra: repository);
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}
