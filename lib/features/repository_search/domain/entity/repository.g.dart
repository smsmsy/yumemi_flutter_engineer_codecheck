// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Repository _$RepositoryFromJson(Map<String, dynamic> json) => _Repository(
  name: json['name'] as String,
  fullName: json['full_name'] as String,
  id: (json['id'] as num).toInt(),
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
      'full_name': instance.fullName,
      'id': instance.id,
      'stargazers_count': instance.stargazersCount,
      'watchers_count': instance.watchersCount,
      'forks_count': instance.forksCount,
      'open_issues_count': instance.openIssuesCount,
      'owner': instance.owner?.toJson(),
      'language': instance.language,
    };
