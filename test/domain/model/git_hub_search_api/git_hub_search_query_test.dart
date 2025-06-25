import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entities/search_query.dart';

void main() {
  group('GitHubSearchQuery.toQueryParameters', () {
    test('q, sort, order, perPage, pageが正しくエンコードされる', () {
      const query = GitHubSearchQuery(
        q: 'flutter test/テスト value',
        sort: GitHubSearchSort.helpWantedIssues,
        order: GitHubSearchOrder.asc,
        perPage: PerPage(42),
        page: PageNumber(3),
      );
      final params = query.toQueryParameters();
      expect(params['q'], Uri.encodeQueryComponent('flutter test/テスト value'));
      expect(params['sort'], Uri.encodeQueryComponent('help-wanted-issues'));
      expect(params['order'], Uri.encodeQueryComponent('asc'));
      expect(params['per_page'], Uri.encodeQueryComponent('42'));
      expect(params['page'], Uri.encodeQueryComponent('3'));
    });

    test('qのみ指定した場合も正しくエンコードされる', () {
      const query = GitHubSearchQuery(q: r'a b/c\d');
      final params = query.toQueryParameters();
      expect(params['q'], Uri.encodeQueryComponent(r'a b/c\d'));
      expect(params.containsKey('sort'), false);
      expect(params.containsKey('order'), false);
      expect(params.containsKey('per_page'), false);
      expect(params.containsKey('page'), false);
    });

    test('特殊文字が正しくエンコードされる（パラメタライズドテスト）', () {
      final testCases = <String, String>{
        'a b': Uri.encodeQueryComponent('a b'),
        r'a\b': Uri.encodeQueryComponent(r'a\b'), // バックスラッシュ2つで1つ分
        'a@b': Uri.encodeQueryComponent('a@b'),
        'a+b': Uri.encodeQueryComponent('a+b'),
        'a&b': Uri.encodeQueryComponent('a&b'),
        'a/b': Uri.encodeQueryComponent('a/b'),
        'a?b': Uri.encodeQueryComponent('a?b'),
        'a=b': Uri.encodeQueryComponent('a=b'),
        'a#b': Uri.encodeQueryComponent('a#b'),
        'a%20b': Uri.encodeQueryComponent('a%20b'),
        "a:;,.!~*'()": Uri.encodeQueryComponent("a:;,.!~*'()"),
      };
      testCases.forEach((input, expected) {
        final query = GitHubSearchQuery(q: input);
        final params = query.toQueryParameters();
        expect(params['q'], expected, reason: 'input: $input');
      });
    });
  });
}
