import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'git_hub_search_query.g.dart';

/// GitHubのリポジトリ検索時のソート条件を表す列挙型です。
///
/// 検索結果の並び順を指定する際に利用します。
enum GitHubSearchSort { stars, forks, helpWantedIssues, updated }

/// GitHubのリポジトリ検索時の並び順（昇順・降順）を表す列挙型です。
///
/// 検索APIのorderパラメータに対応します。
enum GitHubSearchOrder { desc, asc }

/// GitHubSearchSortの拡張。APIパラメータ用の値を取得します。
///
/// APIリクエスト時に必要な文字列へ変換するために使用します。
extension GitHubSearchSortExtension on GitHubSearchSort {
  /// ソート条件をAPI用の文字列に変換します。
  ///
  /// 例: stars, forks, help-wanted-issues, updated
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

/// 1ページあたりの取得件数を表すクラスです。
///
/// 1〜100の範囲で指定可能です。APIのper_pageパラメータに対応します。
class PerPage {
  /// [value]でインスタンスを生成します。1〜100の範囲でなければなりません。
  const PerPage(this.value)
    : assert(value >= 1 && value <= 100, 'perPage must be between 1 and 100.');

  /// 1ページあたりの件数
  final int value;

  /// int値を文字列に変換します。
  @override
  String toString() => value.toString();
}

/// ページ番号を表すクラスです。
///
/// 1以上の整数で指定します。APIのpageパラメータに対応します。
class PageNumber {
  /// [value]でインスタンスを生成します。1以上でなければなりません。
  const PageNumber(this.value)
    : assert(value >= 1, 'page must be 1 or greater.');

  /// ページ番号
  final int value;

  /// int値を文字列に変換します。
  @override
  String toString() => value.toString();
}

/// GitHubSearchOrderの拡張。APIパラメータ用の値を取得します。
///
/// APIリクエスト時に必要な文字列へ変換するために使用します。
extension GitHubSearchOrderExtension on GitHubSearchOrder {
  /// 並び順をAPI用の文字列に変換します。
  String get value => toString().split('.').last;
}

/// GitHubのリポジトリ検索クエリを管理するRiverpodのNotifierクラスです。
///
/// 検索条件の状態管理や更新を行います。
@Riverpod(keepAlive: true)
class GitHubSearchQueryNotifier extends _$GitHubSearchQueryNotifier {
  /// デフォルト値でGitHubSearchQueryを生成します。
  @override
  GitHubSearchQuery build() {
    return const GitHubSearchQuery(q: '');
  }

  /// 検索クエリを更新します。
  ///
  /// 各パラメータを指定して新しい検索条件をセットします。
  void setQuery({
    required String q,
    GitHubSearchSort? sort,
    GitHubSearchOrder? order,
    PerPage? perPage,
    PageNumber? page,
  }) {
    state = GitHubSearchQuery(
      q: q,
      sort: sort,
      order: order,
      perPage: perPage,
      page: page,
    );
  }
}

/// GitHubのリポジトリ検索クエリを表すクラスです。
///
/// 検索ワードやソート条件、ページ情報などを保持し、APIリクエスト用のパラメータ生成も行います。
class GitHubSearchQuery {
  /// 各種パラメータを指定してインスタンスを生成します。
  const GitHubSearchQuery({
    required this.q,
    this.sort,
    this.order,
    this.perPage,
    this.page,
  });

  /// 検索ワード
  final String q;

  /// ソート条件
  final GitHubSearchSort? sort;

  /// 並び順
  final GitHubSearchOrder? order;

  /// 1ページあたりの件数
  final PerPage? perPage;

  /// ページ番号
  final PageNumber? page;

  /// APIリクエスト用のクエリパラメータを生成します。
  ///
  /// 各プロパティの値をエンコードしてMap形式で返します。
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
