import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// The title of the application.
  ///
  /// In en, this message translates to:
  /// **'Yumemi Flutter Engineer Codecheck'**
  String get appTitle;

  /// The title of the home page.
  ///
  /// In en, this message translates to:
  /// **'Search Repository'**
  String get searchPageTitle;

  /// The license information for the app.
  ///
  /// In en, this message translates to:
  /// **'OSS License'**
  String get ossLicense;

  /// The label for system theme mode.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// The label for light theme mode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// The label for dark theme mode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// The label for selecting theme mode.
  ///
  /// In en, this message translates to:
  /// **'Select Theme Mode'**
  String get themeModeSelect;

  /// The label for searching repositories.
  ///
  /// In en, this message translates to:
  /// **'Search repositories'**
  String get searchRepositories;

  /// The programming language of the repository.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get repoLanguage;

  /// The number of stars of the repository.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get repoStars;

  /// The number of watchers of the repository.
  ///
  /// In en, this message translates to:
  /// **'Watchers'**
  String get repoWatchers;

  /// The number of forks of the repository.
  ///
  /// In en, this message translates to:
  /// **'Forks'**
  String get repoForks;

  /// The number of open issues of the repository.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get repoIssues;

  /// The title for the repository details page.
  ///
  /// In en, this message translates to:
  /// **'Repository Details Info'**
  String get repoDetailsInfo;

  /// Label for prompting user to input search keyword.
  ///
  /// In en, this message translates to:
  /// **'Input search keyword'**
  String get inputKeyword;

  /// Tooltip for clearing search history.
  ///
  /// In en, this message translates to:
  /// **'Clear search history'**
  String get clearHistory;

  /// The title for the search history section.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get searchHistory;

  /// Message shown when there is no search history.
  ///
  /// In en, this message translates to:
  /// **'No search history.'**
  String get noSearchHistory;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
