import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';

part 'git_hub_search_api_repository.g.dart';

/// GitHubリポジトリ検索APIのリポジトリProviderです。
///
/// Riverpodの依存解決を利用してAPIリポジトリを提供します。
@Riverpod(keepAlive: true)
GitHubSearchApiRepository apiRepository(Ref ref, Dio dio) {
  return GitHubSearchApiRepository(dio: dio);
}

/// GitHubのリポジトリ検索APIへのアクセスを担当するリポジトリクラスです。
///
/// Dioを用いてGitHub APIと通信し、リポジトリ情報の取得を行います。
class GitHubSearchApiRepository {
  /// [dio]を利用してインスタンスを生成します。
  GitHubSearchApiRepository({required this.dio});

  /// API通信に利用するDioインスタンス
  final Dio dio;

  /// GitHubリポジトリを検索し、結果のリストを返します。
  ///
  /// [query]で指定した条件に基づきAPIリクエストを行い、該当するリポジトリ一覧を取得します。
  /// 検索ワードが空の場合は空リストを返します。
  Future<List<Repository>> searchRepositories(GitHubSearchQuery query) async {
    if (query.q.isEmpty) {
      return [];
    }
    final baseUri = Uri.parse('https://api.github.com/search/repositories');
    final uri = baseUri.replace(queryParameters: query.toQueryParameters());
    try {
      final response = await dio.getUri<Map<String, dynamic>>(uri);
      if (response.statusCode != 200) {
        throw Exception('GitHub API error: status ${response.statusCode}');
      }
      final items = response.data?['items'] as List<dynamic>? ?? [];
      return items
          .map((item) => Repository.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch repositories: $e');
    }
  }
}
