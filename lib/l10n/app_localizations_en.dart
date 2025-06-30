// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yumemi Flutter Engineer Codecheck';

  @override
  String get searchPageTitle => 'Search Repository';

  @override
  String get ossLicense => 'OSS License';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeModeSelect => 'Select Theme Mode';

  @override
  String get searchRepositories => 'Search repositories';

  @override
  String get repoLanguage => 'Language';

  @override
  String get repoStars => 'Stars';

  @override
  String get repoWatchers => 'Watchers';

  @override
  String get repoForks => 'Forks';

  @override
  String get repoIssues => 'Issues';

  @override
  String get repoDetailsInfo => 'Repository Details Info';

  @override
  String get inputKeyword => 'Input search keyword';

  @override
  String get clearHistory => 'Clear search history';

  @override
  String get searchHistory => 'Search History';

  @override
  String get noSearchHistory => 'No search history.';

  @override
  String get noRepository => 'No repositories found.';

  @override
  String get searchQueryLength =>
      'Search query must be 256 characters or less.';

  @override
  String get searchQueryOperator => 'Up to 5 AND/OR/NOT operators are allowed.';

  @override
  String get moveToSearch => 'Move to Search Page';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get continueWithoutLogin => 'Continue without logging in';

  @override
  String get signInWithGitHub => 'Sign in with GitHub';

  @override
  String get githubAuth => 'GitHub Authentication';
}
