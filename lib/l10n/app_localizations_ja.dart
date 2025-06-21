// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'フラッターデモ';

  @override
  String get homePageTitle => 'フラッターデモホームページ';

  @override
  String get counterText => 'ボタンを押した回数:';

  @override
  String get incrementTooltip => '増やす';

  @override
  String get ossLicense => 'OSSライセンス';
}
