import 'package:dio/dio.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entities/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entities/search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/repositories/github_repository.dart';

/// GitHub Search API を使用したリポジトリ検索の具象実装
///
/// インフラストラクチャ層に属し、外部API呼び出しの詳細を隠蔽する
/// ドメインインターフェースを実装し、技術的な詳細をカプセル化
class GitHubApiRepository implements GitHubRepository {
  GitHubApiRepository({required this.dio});

  final Dio dio;

  @override
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
