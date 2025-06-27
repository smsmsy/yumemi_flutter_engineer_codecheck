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
}
