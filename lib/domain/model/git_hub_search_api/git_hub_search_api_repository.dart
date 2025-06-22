import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';

part 'git_hub_search_api_repository.g.dart';

@Riverpod(keepAlive: true)
GitHubSearchApiRepository apiRepository(Ref ref, Dio dio) {
  return GitHubSearchApiRepository(dio: dio);
}

class GitHubSearchApiRepository {
  GitHubSearchApiRepository({required this.dio});
  final Dio dio;

  Future<List<Repository>> fetch(GitHubSearchQuery query) async {
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
