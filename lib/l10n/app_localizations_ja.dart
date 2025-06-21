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
}
