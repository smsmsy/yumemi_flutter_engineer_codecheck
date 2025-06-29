import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_flutter_engineer_codecheck/extension/debounce_and_cancel_extension.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/repository/git_hub_search_api_repository.dart';

part 'repository_providers.g.dart';

/// GitHubリポジトリの具象実装を提供するプロバイダー
///
/// DIコンテナとしてRiverpodを使用し、依存関係を管理します。
@Riverpod(keepAlive: true)
GitHubSearchApiRepository githubRepository(Ref ref, Dio dio) {
  return GitHubSearchApiRepository(dio: dio);
}

/// リポジトリ検索結果を提供するプロバイダー
///
/// ユーザーの検索クエリに基づいてリポジトリを取得します。
/// デバウンス機能付きHTTPクライアントを使用してAPI呼び出しを最適化します。
@riverpod
Future<List<Repository>> repositoriesSearchResult(Ref ref) async {
  final query = ref.watch(gitHubSearchQueryNotifierProvider);
  if (query.q.isEmpty) {
    return [];
  }
  final dio = await ref.getDebouncedHttpClient();
  final repository = ref.watch(githubRepositoryProvider(dio));
  return repository.searchRepositories(query);
}
