// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Yumemi Flutter Engineer Codecheck';

  @override
  String get searchPageTitle => 'リポジトリ検索';

  @override
  String get ossLicense => 'OSSライセンス';

  @override
  String get themeModeSystem => 'システム';

  @override
  String get themeModeLight => 'ライト';

  @override
  String get themeModeDark => 'ダーク';

  @override
  String get themeModeSelect => 'テーマモードを選択';

  @override
  String get searchRepositories => 'リポジトリを検索';

  @override
  String get repoLanguage => '言語';

  @override
  String get repoStars => 'スター';

  @override
  String get repoWatchers => 'ウォッチ';

  @override
  String get repoForks => 'フォーク';

  @override
  String get repoIssues => 'イシュー';

  @override
  String get repoDetailsInfo => 'リポジトリ詳細';

  @override
  String get inputKeyword => '検索キーワードを入力してください';

  @override
  String get clearHistory => '検索履歴をクリアします';

  @override
  String get searchHistory => '検索履歴';

  @override
  String get noSearchHistory => '検索履歴はありません。';

  @override
  String get noRepository => '該当するリポジトリはありません。';

  @override
  String get searchQueryLength => '検索クエリは256文字以内で入力してください';

  @override
  String get searchQueryOperator => 'AND/OR/NOT演算子は合計5個までです';

  @override
  String get moveToSearch => '検索画面へ移動する';

  @override
  String get loginSuccess => 'ログイン成功しました！';

  @override
  String get continueWithoutLogin => 'ログインせずに続行する';

  @override
  String get signInWithGitHub => 'GitHubでサインイン';

  @override
  String get githubAuth => 'GitHub認証';
}
