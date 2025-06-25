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

    switch (repositoriesAsyncValue) {
      case AsyncError(:final error):
        return Center(
          child: Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      case AsyncData(:final value):
        if (value.isEmpty) {
          return const Center(
            child: Text('該当するリポジトリはありません'),
          );
        }
        return AdaptiveRepositoryListView(
          value: value,
          scrollController: _scrollController,
        );
      case _:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }
}

class AdaptiveRepositoryListView extends StatelessWidget {
  const AdaptiveRepositoryListView({
    required this.value,
    required this.scrollController,
    super.key,
  });

  final List<Repository> value;
  final ScrollController scrollController;

  @override
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
        // カードの影の深さ
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(vertical: 6),
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
