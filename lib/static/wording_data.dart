/// アプリ内で使用する文言（ラベルやタイトルなど）を一元管理するクラスです。
///
/// 画面タイトルやボタンラベルなど、UIで表示するテキスト定数をまとめています。
class WordingData {
  /// アプリケーション名。各種画面やタイトルバーで利用されます。
  static const applicationName = 'Yumemi Flutter Engineer Codecheck';

  /// アプリのタイトル。画面上部やAppBarなどで利用されます。
  static const appTitle = 'Yumemi Flutter Engineer Codecheck';

  /// 検索画面のタイトル。検索ページのAppBarタイトルなどで利用されます。
  static const searchPageTitle = 'Search Repository';

  /// OSSライセンス画面のタイトル。OSSライセンス情報表示画面で利用されます。
  static const ossLicense = 'OSS License';

  /// テーマモード「システム」。テーマ選択ダイアログなどで利用されます。
  static const themeModeSystem = 'System';

  /// テーマモード「ライト」。テーマ選択ダイアログなどで利用されます。
  static const themeModeLight = 'Light';

  /// テーマモード「ダーク」。テーマ選択ダイアログなどで利用されます。
  static const themeModeDark = 'Dark';

  /// テーマモード選択ラベル。テーマ選択ダイアログのタイトルなどで利用されます。
  static const themeModeSelect = 'Select Theme Mode';

  /// リポジトリ検索ボタンやラベル。検索画面のボタンや見出しで利用されます。
  static const searchRepositories = 'Search repositories';

  /// リポジトリの言語ラベル。リポジトリ詳細やリスト表示で利用されます。
  static const repoLanguage = 'Language';

  /// リポジトリのスター数ラベル。リポジトリ詳細やリスト表示で利用されます。
  static const repoStars = 'Stars';

  /// リポジトリのウォッチャー数ラベル。リポジトリ詳細やリスト表示で利用されます。
  static const repoWatchers = 'Watchers';

  /// リポジトリのフォーク数ラベル。リポジトリ詳細やリスト表示で利用されます。
  static const repoForks = 'Forks';

  /// リポジトリのイシュー数ラベル。リポジトリ詳細やリスト表示で利用されます。
  static const repoIssues = 'Issues';

  /// 言語未設定時の表示用ラベル。リポジトリの言語が不明な場合に利用されます。
  static const unknownLanguage = 'N/A';

  /// リポジトリ詳細情報の見出し。詳細画面のセクションタイトルなどで利用されます。
  static const repoDetailsInfo = 'Repository Details Info';

  /// 未検索状態の表示用ラベル。リポジトリがまだ検索されていない場合に利用されます。
  static const inputKeyword = 'Input search keyword';

  /// 検索履歴クリアボタンのツールチップ。検索履歴を削除する際に利用されます。
  static const clearHistory = 'Clear search history';

  /// 検索履歴セクションのタイトル。ドロワーや履歴表示で利用されます。
  static const searchHistory = 'Search History';

  /// 検索履歴が空の場合の表示文言。検索履歴が存在しない場合に利用されます。
  static const noSearchHistory = 'No search history.';

  /// 検索結果が空の場合の表示用ラベル。該当するリポジトリがない場合に利用されます。
  static const noRepository = 'No repositories found.';

  /// 検索クエリが256文字を超えた場合のエラーメッセージ。
  static const searchQueryLength =
      'Search query must be 256 characters or less.';

  /// AND/OR/NOT演算子が合計5個を超えた場合のエラーメッセージ。
  static const searchQueryOperator =
      'Up to 5 AND/OR/NOT operators are allowed.';

  /// 検索画面へ移動するボタンのラベル。認証後の遷移ボタンなどで利用されます。
  static const moveToSearch = 'Move to Search Page';

  /// ログイン成功時のメッセージ。認証完了時のダイアログや画面で利用されます。
  static const loginSuccess = 'Login successful!';

  /// ログインせずに続行するボタンのラベル。認証画面などで利用されます。
  static const continueWithoutLogin = 'Continue without logging in';

  /// GitHubでサインインボタンのラベル。認証画面などで利用されます。
  static const signInWithGitHub = 'Sign in with GitHub';

  /// GitHub認証画面のタイトル。AppBarやダイアログタイトルで利用されます。
  static const githubAuth = 'GitHub Authentication';
}
