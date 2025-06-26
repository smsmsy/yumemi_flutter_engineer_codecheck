// ignore_for_file: invalid_annotation_target, document_ignores

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/owner.dart';

part 'repository.freezed.dart';
part 'repository.g.dart';

/// GitHub Search API のリポジトリエンティティ
///
/// Freezedを使用した不変データクラス
/// ドメイン層の純粋なエンティティとして外部ライブラリに依存しない
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
