import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_api_repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';

import 'git_hub_search_api_repository_query_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('GitHubSearchApiRepository.fetch (with GitHubSearchQuery)', () {
    late MockDio mockDio;
    late GitHubSearchApiRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = GitHubSearchApiRepository(dio: mockDio);
    });

    test('クエリパラメータが正しく渡される', () async {
      const query = GitHubSearchQuery(
        q: 'flutter',
        sort: GitHubSearchSort.stars,
        order: GitHubSearchOrder.desc,
        perPage: PerPage(50),
        page: PageNumber(2),
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
        mockDio.getUri<Map<String, dynamic>>(
          any,
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
