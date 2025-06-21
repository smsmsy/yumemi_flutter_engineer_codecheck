import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/owner.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';

void main() {
  const response = Repository(
    name: 'flutter',
    owner: Owner(
      avatarUrl: 'https://avatars.githubusercontent.com/u/14101776?v=4',
    ),
    language: 'dart',
    stargazersCount: 3000,
    watchersCount: 2000,
    forksCount: 200,
    openIssuesCount: 350,
  );

  const json = {
    'name': 'flutter',
    'owner': {
      'avatar_url': 'https://avatars.githubusercontent.com/u/14101776?v=4',
    },
    'language': 'dart',
    'stargazers_count': 3000,
    'watchers_count': 2000,
    'forks_count': 200,
    'open_issues_count': 350,
  };

  group('GitHubリポジトリ検索APIのモデルに関するテスト', () {
    test('基本的な確認', () {
      expect(response.name, 'flutter');
      expect(
        response.owner.avatarUrl,
        'https://avatars.githubusercontent.com/u/14101776?v=4',
      );
      expect(response.language, 'dart');
      expect(response.stargazersCount, 3000);
      expect(response.watchersCount, 2000);
      expect(response.forksCount, 200);
      expect(response.openIssuesCount, 350);
    });
  });

  test('fromJsonの確認', () {
    final response = Repository.fromJson(json);

    expect(response.name, 'flutter');
    expect(
      response.owner.avatarUrl,
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
}
