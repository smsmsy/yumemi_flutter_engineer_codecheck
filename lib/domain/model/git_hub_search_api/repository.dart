// ignore_for_file: invalid_annotation_target, document_ignores

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_api_repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/owner.dart';

part 'repository.freezed.dart';
part 'repository.g.dart';

@riverpod
Future<List<Repository>> repositiesSearchResult(Ref ref) {
  final repository = ref.watch(apiRepositoryProvider);
  final query = ref.watch(gitHubSearchQueryNotifierProvider);
  return repository.fetch(query);
}

/// GitHub Search API のレスポンスモデル
@freezed
sealed class Repository with _$Repository {
  @JsonSerializable(explicitToJson: true)
  const factory Repository({
    required String name,
    @JsonKey(name: 'stargazers_count') required int stargazersCount,
    @JsonKey(name: 'watchers_count') required int watchersCount,
    @JsonKey(name: 'forks_count') required int forksCount,
    @JsonKey(name: 'open_issues_count') required int openIssuesCount,
    Owner? owner,
    String? language,
  }) = _Repository;

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);
}
