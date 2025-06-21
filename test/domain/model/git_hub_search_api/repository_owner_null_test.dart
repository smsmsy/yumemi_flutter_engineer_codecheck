import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';

void main() {
  group('Repository.fromJson', () {
    test('ownerがnullでもパースできる', () {
      final json = {
        'name': 'test-repo',
        'owner': null,
        'language': 'Dart',
        'stargazers_count': 10,
        'watchers_count': 10,
        'forks_count': 1,
        'open_issues_count': 0,
      };
      final repo = Repository.fromJson(json);
      expect(repo.name, 'test-repo');
      expect(repo.owner, isNull);
      expect(repo.language, 'Dart');
      expect(repo.stargazersCount, 10);
      expect(repo.watchersCount, 10);
      expect(repo.forksCount, 1);
      expect(repo.openIssuesCount, 0);
    });

    test('languageがnullでもパースできる', () {
      final json = {
        'name': 'test-repo',
        'owner': null,
        'language': null,
        'stargazers_count': 10,
        'watchers_count': 10,
        'forks_count': 1,
        'open_issues_count': 0,
      };
      final repo = Repository.fromJson(json);
      expect(repo.name, 'test-repo');
      expect(repo.owner, isNull);
      expect(repo.language, isNull);
      expect(repo.stargazersCount, 10);
      expect(repo.watchersCount, 10);
      expect(repo.forksCount, 1);
      expect(repo.openIssuesCount, 0);
    });
  });
}
