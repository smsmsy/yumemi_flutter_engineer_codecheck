import 'package:dio/dio.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';

class GitHubSearchApiRepository {
  GitHubSearchApiRepository({required this.dio});
  final Dio dio;

  Future<List<Repository>> fetch(GitHubSearchQuery query) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        'https://api.github.com/search/repositories',
        queryParameters: query.toQueryParameters(),
        options: Options(headers: {'accept': 'application/vnd.github+json'}),
      );
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
