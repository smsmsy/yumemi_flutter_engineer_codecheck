import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'github_access_token_provider.g.dart';

@Riverpod(keepAlive: true)
class GithubAccessToken extends _$GithubAccessToken {
  @override
  String? build() {
    // 初期値はnull
    return null;
  }

  /// GitHubアクセストークンを更新するメソッド
  void update(String? token) {
    state = token;
  }
}
