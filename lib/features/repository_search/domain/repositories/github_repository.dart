import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entities/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entities/search_query.dart';

/// GitHubリポジトリ検索のドメインリポジトリインターフェース
///
/// このインターフェースはドメイン層に属し、外部ライブラリに依存しない
/// 具体的な実装はインフラストラクチャ層で行う
abstract interface class GitHubRepository {
  /// 指定されたクエリでリポジトリを検索する
  ///
  /// [query] 検索クエリ
  /// 戻り値: 検索結果のRepositoryリスト
  /// 例外: 検索に失敗した場合は例外をスロー
  Future<List<Repository>> searchRepositories(GitHubSearchQuery query);
}
