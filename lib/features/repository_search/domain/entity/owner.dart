// ignore_for_file: invalid_annotation_target, document_ignores

import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner.freezed.dart';
part 'owner.g.dart';

/// GitHubリポジトリオーナーの情報を表すドメインエンティティ
///
/// Freezedを使用した不変データクラス
/// ドメイン層の純粋なエンティティとして外部ライブラリに依存しない
@freezed
sealed class Owner with _$Owner {
  const factory Owner({
    @JsonKey(name: 'avatar_url') required String avatarUrl,
  }) = _Owner;

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
}
