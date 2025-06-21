import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_api_repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';

import 'git_hub_search_api_repository_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('GitHubSearchApiRepository.fetch', () {
    late MockDio mockDio;
    late GitHubSearchApiRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = GitHubSearchApiRepository(dio: mockDio);
    });

    test('正常系: レスポンスがList<Repository>として返る', () async {
      const query = GitHubSearchQuery(q: 'flutter');
      final mockResponse = {
        'items': [
          {
            'id': 1,
            'name': 'repo1',
            'full_name': 'user/repo1',
            'owner': {'avatar_url': 'https://example.com/avatar1.png'},
            'language': 'Dart',
            'stargazers_count': 100,
            'watchers_count': 50,
            'forks_count': 10,
            'open_issues_count': 5,
          },
          {
            'id': 2,
            'name': 'repo2',
            'full_name': 'user/repo2',
            'owner': {'avatar_url': 'https://example.com/avatar2.png'},
            'language': 'Flutter',
            'stargazers_count': 200,
            'watchers_count': 80,
            'forks_count': 20,
            'open_issues_count': 2,
          },
        ],
      };
      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: query.toQueryParameters(),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await repository.fetch(query);
      expect(result, isA<List<Repository>>());
      expect(result.length, 2);
      expect(result[0].name, 'repo1');
      expect(result[1].name, 'repo2');
    });

    test('異常系: APIエラー時に例外が投げられる', () {
      const query = GitHubSearchQuery(q: 'flutter');
      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: query.toQueryParameters(),
          options: anyNamed('options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: 'error',
          type: DioExceptionType.badResponse,
        ),
      );

      expect(() => repository.fetch(query), throwsA(isA<Exception>()));
    });

    test('空リスト返却: itemsが空配列の場合', () async {
      const query = GitHubSearchQuery(q: 'flutter');
      final mockResponse = {'items': <Map<String, dynamic>>[]};
      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: query.toQueryParameters(),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );
      final result = await repository.fetch(query);
      expect(result, isA<List<Repository>>());
      expect(result, isEmpty);
    });

    test('itemsキーが存在しない場合は空リストを返す', () async {
      const query = GitHubSearchQuery(q: 'flutter');
      final mockResponse = <String, dynamic>{};
      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: query.toQueryParameters(),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );
      final result = await repository.fetch(query);
      expect(result, isA<List<Repository>>());
      expect(result, isEmpty);
    });

    test('items内の一部データが不正な場合は例外', ()  {
      const query = GitHubSearchQuery(q: 'flutter');
      final mockResponse = {
        'items': [
          {
            'id': 1,
            'name': 'repo1',
            'full_name': 'user/repo1',
            'owner': {'avatar_url': 'https://example.com/avatar1.png'},
            'language': 'Dart',
            'stargazers_count': 100,
            'watchers_count': 50,
            'forks_count': 10,
            'open_issues_count': 5,
          },
          {
            // 必須フィールド欠損
            'id': 2,
            'name': 'repo2',
          },
        ],
      };
      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: query.toQueryParameters(),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );
      expect(() => repository.fetch(query), throwsA(isA<Exception>()));
    });

    test('Dioのタイムアウト時に例外が投げられる', ()  {
      const query = GitHubSearchQuery(q: 'flutter');
      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: query.toQueryParameters(),
          options: anyNamed('options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      expect(() => repository.fetch(query), throwsA(isA<Exception>()));
    });

    test('APIのrate limit超過時(403)に例外が投げられる', ()  {
      const query = GitHubSearchQuery(q: 'flutter');
      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: query.toQueryParameters(),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: {},
          statusCode: 403,
          requestOptions: RequestOptions(),
        ),
      );
      expect(() => repository.fetch(query), throwsA(isA<Exception>()));
    });

    test('sort/orderをenumで指定した場合に正しく渡される', () async {
      const query = GitHubSearchQuery(
        q: 'flutter',
        sort: GitHubSearchSort.stars,
        order: GitHubSearchOrder.asc,
      );
      final mockResponse = {
        'items': [
          {
            'id': 1,
            'name': 'repo1',
            'full_name': 'user/repo1',
            'owner': {'avatar_url': 'https://example.com/avatar1.png'},
            'language': 'Dart',
            'stargazers_count': 100,
            'watchers_count': 50,
            'forks_count': 10,
            'open_issues_count': 5,
          },
        ],
      };
      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: {
            'q': 'flutter',
            'sort': 'stars',
            'order': 'asc',
          },
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );
      final result = await repository.fetch(query);
      expect(result, isA<List<Repository>>());
      expect(result.length, 1);
      expect(result[0].name, 'repo1');
    });
  });
}
