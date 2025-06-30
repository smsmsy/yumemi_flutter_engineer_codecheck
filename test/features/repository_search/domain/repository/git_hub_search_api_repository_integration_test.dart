@Skip('外部APIを叩くためCIでは実行しません')
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/repository/git_hub_search_api_repository.dart';

void main() {
  group('GitHubSearchApiRepository Integration', () {
    late GitHubSearchApiRepository repository;
    final logger =
        SimpleLogger()..setLevel(Level.INFO, includeCallerInfo: true);

    setUp(() {
      repository = GitHubSearchApiRepository(dio: Dio());
    });

    test('q: flutter でリポジトリ一覧が取得できる', () async {
      const query = GitHubSearchQuery(q: 'flutter');
      final result = await repository.searchRepositories(query, null);
      expect(result, isNotEmpty);
      logger.info('First repo: \\${result.first}');
    });
    test('q: flutter, perPage: 10 ででリポジトリ一覧が取得できる', () async {
      const query = GitHubSearchQuery(q: 'flutter', page: PageNumber(10));
      final result = await repository.searchRepositories(query, null);
      expect(result, isNotEmpty);
      logger.info('First repo: \\${result.first}');
    });
    test('q: flutter, order: desc でリポジトリ一覧が取得できる', () async {
      const query = GitHubSearchQuery(
        q: 'flutter',
        order: GitHubSearchOrder.desc,
      );
      final result = await repository.searchRepositories(query, null);
      expect(result, isNotEmpty);
      logger.info('First repo: \\${result.first}');
    });

    test('q: dart, sort: stars でスター数順にリポジトリ一覧が取得できる', () async {
      const query = GitHubSearchQuery(q: 'dart', sort: GitHubSearchSort.stars);
      final result = await repository.searchRepositories(query, null);
      expect(result, isNotEmpty);
      logger.info('First repo: \\${result.first}');
    });

    test('q: riverpod, perPage: 5 で最大5件のリポジトリが取得できる', () async {
      const query = GitHubSearchQuery(q: 'riverpod', perPage: PerPage(5));
      final result = await repository.searchRepositories(query, null);
      expect(result.length, lessThanOrEqualTo(5));
      logger.info('Repos: \\${result.map((e) => e.name).toList()}');
    });
  });
}
