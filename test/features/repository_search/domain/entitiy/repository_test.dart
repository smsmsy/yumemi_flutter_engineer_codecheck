import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/owner.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';

void main() {
  group('GitHubリポジトリ検索APIのモデルに関するテスト', () {
    const response = Repository(
      name: 'flutter',
      fullName: 'flutter/flutter',
      id: 123456,
      owner: Owner(
        avatarUrl: 'https://avatars.githubusercontent.com/u/14101776?v=4',
      ),
      language: 'dart',
      stargazersCount: 3000,
      watchersCount: 2000,
      forksCount: 200,
      openIssuesCount: 350,
    );

    final json = {
      'name': 'flutter',
      'full_name': 'flutter/flutter',
      'id': 123456,
      'owner': {
        'avatar_url': 'https://avatars.githubusercontent.com/u/14101776?v=4',
      },
      'language': 'dart',
      'stargazers_count': 3000,
      'watchers_count': 2000,
      'forks_count': 200,
      'open_issues_count': 350,
    };
    test('基本的な確認', () {
      expect(response.name, 'flutter');
      expect(response.owner, isNotNull);
      expect(
        response.owner!.avatarUrl,
        'https://avatars.githubusercontent.com/u/14101776?v=4',
      );
      expect(response.language, 'dart');
      expect(response.stargazersCount, 3000);
      expect(response.watchersCount, 2000);
      expect(response.forksCount, 200);
      expect(response.openIssuesCount, 350);
    });
    test('fromJsonの確認', () {
      final response = Repository.fromJson(json);

      expect(response.name, 'flutter');
      expect(response.fullName, 'flutter/flutter');
      expect(response.id, 123456);
      expect(response.owner, isNotNull);
      expect(
        response.owner!.avatarUrl,
        'https://avatars.githubusercontent.com/u/14101776?v=4',
      );
      expect(response.language, 'dart');
      expect(response.stargazersCount, 3000);
      expect(response.watchersCount, 2000);
      expect(response.forksCount, 200);
      expect(response.openIssuesCount, 350);
    });

    test('toJsonの確認', () {
      final jsonResponse = response.toJson();
      expect(jsonResponse['name'], 'flutter');
      expect(
        (jsonResponse['owner'] as Map<String, dynamic>)['avatar_url'],
        'https://avatars.githubusercontent.com/u/14101776?v=4',
      );
      expect(jsonResponse['language'], 'dart');
      expect(jsonResponse['stargazers_count'], 3000);
      expect(jsonResponse['watchers_count'], 2000);
      expect(jsonResponse['forks_count'], 200);
      expect(jsonResponse['open_issues_count'], 350);
    });
  });
  group('Repository.fromJsonのnull値に関するテスト', () {
    test('ownerがnullでもパースできる', () {
      final json = {
        'name': 'test-repo',
        'full_name': 'test-repo/test-repo',
        'id': 1,
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
        'full_name': 'test-repo/test-repo',
        'id': 1,
        'owner': null,
        'language': null,
        'stargazers_count': 10,
        'watchers_count': 10,
        'forks_count': 1,
        'open_issues_count': 0,
      };
      final repo = Repository.fromJson(json);
      expect(repo.name, 'test-repo');
      expect(repo.fullName, 'test-repo/test-repo');
      expect(repo.id, 1);
      expect(repo.owner, isNull);
      expect(repo.language, isNull);
      expect(repo.stargazersCount, 10);
      expect(repo.watchersCount, 10);
      expect(repo.forksCount, 1);
      expect(repo.openIssuesCount, 0);
    });

    test('toJsonでownerがnullの場合も正しく出力される', () {
      const repo = Repository(
        name: 'test-repo',
        fullName: 'test-repo/test-repo',
        id: 1,
        language: 'Dart',
        stargazersCount: 10,
        watchersCount: 10,
        forksCount: 1,
        openIssuesCount: 0,
      );
      final json = repo.toJson();
      expect(json['name'], 'test-repo');
      expect(json['owner'], isNull);
      expect(json['language'], 'Dart');
      expect(json['stargazers_count'], 10);
      expect(json['watchers_count'], 10);
      expect(json['forks_count'], 1);
      expect(json['open_issues_count'], 0);
    });

    test('toJsonでlanguageがnullの場合も正しく出力される', () {
      const repo = Repository(
        name: 'test-repo',
        fullName: 'test-repo/test-repo',
        id: 1,
        stargazersCount: 10,
        watchersCount: 10,
        forksCount: 1,
        openIssuesCount: 0,
      );
      final json = repo.toJson();
      expect(json['name'], 'test-repo');
      expect(json['owner'], isNull);
      expect(json['language'], isNull);
      expect(json['stargazers_count'], 10);
      expect(json['watchers_count'], 10);
      expect(json['forks_count'], 1);
      expect(json['open_issues_count'], 0);
    });
  });
}
