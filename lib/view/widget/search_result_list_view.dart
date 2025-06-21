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
    final repositoriesAsyncValue = ref.watch(repositiesSearchResultProvider);

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

    return ListView.builder(
      controller: _scrollController,
      itemCount: repositories.length,
      itemBuilder: (context, index) {
        final repository = repositories[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading:
                repository.owner == null
                    ? const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    )
                    : CircleAvatar(
                      backgroundColor: const Color(0x00000000),
                      backgroundImage: NetworkImage(
                        repository.owner!.avatarUrl,
                      ),
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
