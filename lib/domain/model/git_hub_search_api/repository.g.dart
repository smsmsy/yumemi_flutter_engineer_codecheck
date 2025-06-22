// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Repository _$RepositoryFromJson(Map<String, dynamic> json) => _Repository(
  name: json['name'] as String,
  stargazersCount: (json['stargazers_count'] as num).toInt(),
  watchersCount: (json['watchers_count'] as num).toInt(),
  forksCount: (json['forks_count'] as num).toInt(),
  openIssuesCount: (json['open_issues_count'] as num).toInt(),
  owner:
      json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
  language: json['language'] as String?,
);

Map<String, dynamic> _$RepositoryToJson(_Repository instance) =>
    <String, dynamic>{
      'name': instance.name,
      'stargazers_count': instance.stargazersCount,
      'watchers_count': instance.watchersCount,
      'forks_count': instance.forksCount,
      'open_issues_count': instance.openIssuesCount,
      'owner': instance.owner?.toJson(),
      'language': instance.language,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$repositiesSearchResultHash() =>
    r'29797e8b5ac305dce75aeb14fbd987012fc916ae';

/// See also [repositiesSearchResult].
@ProviderFor(repositiesSearchResult)
final repositiesSearchResultProvider =
    AutoDisposeFutureProvider<List<Repository>>.internal(
      repositiesSearchResult,
      name: r'repositiesSearchResultProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$repositiesSearchResultHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RepositiesSearchResultRef =
    AutoDisposeFutureProviderRef<List<Repository>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
