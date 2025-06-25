/// GitHub検索のソート順enum
enum GitHubSearchSort { stars, forks, helpWantedIssues, updated }

/// GitHub検索の並び順enum
enum GitHubSearchOrder { desc, asc }

/// GitHubSearchSort の拡張メソッド
extension GitHubSearchSortExtension on GitHubSearchSort {
  String get value {
    switch (this) {
      case GitHubSearchSort.stars:
        return 'stars';
      case GitHubSearchSort.forks:
        return 'forks';
      case GitHubSearchSort.helpWantedIssues:
        return 'help-wanted-issues';
      case GitHubSearchSort.updated:
        return 'updated';
    }
  }
}

/// GitHubSearchOrder の拡張メソッド
extension GitHubSearchOrderExtension on GitHubSearchOrder {
  String get value => toString().split('.').last;
}

/// ページネーションの1ページあたりの件数を表すValue Object
class PerPage {
  const PerPage(this.value)
    : assert(value >= 1 && value <= 100, 'perPage must be between 1 and 100.');
  final int value;

  @override
  String toString() => value.toString();
}

/// ページネーションのページ番号を表すValue Object
class PageNumber {
  const PageNumber(this.value)
    : assert(value >= 1, 'page must be 1 or greater.');
  final int value;

  @override
  String toString() => value.toString();
}

/// GitHub検索クエリのドメインエンティティ
///
/// 検索に必要なパラメータを不変オブジェクトとして表現
/// ドメイン層の純粋なValue Objectとして外部ライブラリに依存しない
class GitHubSearchQuery {
  const GitHubSearchQuery({
    required this.q,
    this.sort,
    this.order,
    this.perPage,
    this.page,
  });

  final String q;
  final GitHubSearchSort? sort;
  final GitHubSearchOrder? order;
  final PerPage? perPage;
  final PageNumber? page;

  /// APIリクエスト用のクエリパラメータに変換
  Map<String, String> toQueryParameters() {
    return {
      'q': Uri.encodeQueryComponent(q),
      if (sort != null) 'sort': Uri.encodeQueryComponent(sort!.value),
      if (order != null) 'order': Uri.encodeQueryComponent(order!.value),
      if (perPage != null)
        'per_page': Uri.encodeQueryComponent(
          perPage!.value.toString(),
        ),
      if (page != null)
        'page': Uri.encodeQueryComponent(
          page!.value.toString(),
        ),
    };
  }
}
