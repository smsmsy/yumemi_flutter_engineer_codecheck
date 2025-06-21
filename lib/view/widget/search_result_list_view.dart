import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';

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
    // TODO: 検索結果のリストを引き取る実装
    // ここではダミーデータを使用しているため、実際のデータを取得するロジックを実装する必要があります。
    final repositories = List<Repository>.generate(
      1000,
      (index) => Repository(
        name: 'flutter-engineer-codecheck-${index + 1}',
        stargazersCount: 100,
        watchersCount: 50,
        forksCount: 20,
        openIssuesCount: 5,
      ),
    );

    if (repositories.isEmpty) {
      return const Center(
        child: Text('該当するリポジトリはありません'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: repositories.length,
      itemBuilder: (context, index) {
        final repository = repositories[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              // TODO: Image.network(repository.owner.avatarUrl) によるアイコンの実装
            ),
            title: Text(
              repository.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: () {
              // TODO: リポジトリ詳細画面への遷移実装
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tapped on ${repository.name}',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
