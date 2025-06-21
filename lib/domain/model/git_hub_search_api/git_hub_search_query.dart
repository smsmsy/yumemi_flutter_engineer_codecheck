import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'git_hub_search_query.g.dart';

enum GitHubSearchSort { stars, forks, helpWantedIssues, updated }

enum GitHubSearchOrder { desc, asc }

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

class PerPage {
  const PerPage(this.value)
    : assert(value >= 1 && value <= 100, 'perPage must be between 1 and 100.');
  final int value;

  @override
  String toString() => value.toString();
}

class PageNumber {
  const PageNumber(this.value)
    : assert(value >= 1, 'page must be 1 or greater.');
  final int value;

  @override
  String toString() => value.toString();
}

extension GitHubSearchOrderExtension on GitHubSearchOrder {
  String get value => toString().split('.').last;
}

@riverpod
class GitHubSearchQueryNotifier extends _$GitHubSearchQueryNotifier {
  @override
  GitHubSearchQuery build() {
    return const GitHubSearchQuery(q: '');
  }

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

  Map<String, String> toQueryParameters() {
    return {
      'q': q,
      if (sort != null) 'sort': sort!.value,
      if (order != null) 'order': order!.value,
      if (perPage != null) 'per_page': perPage!.value.toString(),
      if (page != null) 'page': page!.value.toString(),
    };
  }
}
