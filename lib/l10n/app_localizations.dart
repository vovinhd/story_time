import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get loading;

  /// No description provided for @menuOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get menuOpen;

  /// No description provided for @menuOpenAccelerator.
  ///
  /// In en, this message translates to:
  /// **'Ctrl+O'**
  String get menuOpenAccelerator;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get menuSettings;

  /// No description provided for @menuSettingsAccelerator.
  ///
  /// In en, this message translates to:
  /// **'Ctrl+,'**
  String get menuSettingsAccelerator;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About fl_audiobook'**
  String get menuAbout;

  /// No description provided for @heroHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Listen to audiobooks'**
  String get heroHintTitle;

  /// No description provided for @heroHintSubtitle.
  ///
  /// In en, this message translates to:
  /// **'supported file types: .m4b, .m4a, .mp3'**
  String get heroHintSubtitle;

  /// No description provided for @heroHintButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Open Audiobook'**
  String get heroHintButtonLabel;

  /// No description provided for @heroPlayerNowPLaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get heroPlayerNowPLaying;

  /// No description provided for @lastPlayedListHint.
  ///
  /// In en, this message translates to:
  /// **'Last Played'**
  String get lastPlayedListHint;

  /// No description provided for @artistLabel.
  ///
  /// In en, this message translates to:
  /// **'by {author}'**
  String artistLabel(String author);

  /// No description provided for @lastPlayedCardLastPlayed.
  ///
  /// In en, this message translates to:
  /// **'last played {dateTimeLabel}'**
  String lastPlayedCardLastPlayed(String dateTimeLabel);

  /// No description provided for @lastPlayedCardRemaining.
  ///
  /// In en, this message translates to:
  /// **'{timeRemainingLabel} remaining'**
  String lastPlayedCardRemaining(String timeRemainingLabel);

  /// No description provided for @lastPlayedCardLocate.
  ///
  /// In en, this message translates to:
  /// **'Locate {title}'**
  String lastPlayedCardLocate(String title);

  /// No description provided for @lastPlayedCardForget.
  ///
  /// In en, this message translates to:
  /// **'Forget {title}'**
  String lastPlayedCardForget(String title);

  /// No description provided for @lastPlayedCardReveal.
  ///
  /// In en, this message translates to:
  /// **'Show in file explorer'**
  String get lastPlayedCardReveal;

  /// No description provided for @lastPlayedCardForgetButton.
  ///
  /// In en, this message translates to:
  /// **'remove from history'**
  String get lastPlayedCardForgetButton;

  /// No description provided for @dialogOk.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get dialogOk;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @tooltipPlay.
  ///
  /// In en, this message translates to:
  /// **'play {title}'**
  String tooltipPlay(String title);

  /// No description provided for @tooltipOptions.
  ///
  /// In en, this message translates to:
  /// **'options for {title}'**
  String tooltipOptions(String title);

  /// No description provided for @fileNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'File not available, make sure to mount the device it\'s on!'**
  String get fileNotAvailable;

  /// No description provided for @tooltipTags.
  ///
  /// In en, this message translates to:
  /// **'show media information'**
  String get tooltipTags;

  /// No description provided for @tooltipVolume.
  ///
  /// In en, this message translates to:
  /// **'volume'**
  String get tooltipVolume;

  /// No description provided for @tooltipSpeed.
  ///
  /// In en, this message translates to:
  /// **'playback speed'**
  String get tooltipSpeed;

  /// No description provided for @tooltipTimer.
  ///
  /// In en, this message translates to:
  /// **'timer'**
  String get tooltipTimer;

  /// No description provided for @tooltipTransportPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get tooltipTransportPlay;

  /// No description provided for @tooltipTransportPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get tooltipTransportPause;

  /// No description provided for @tooltipTransportskipChapterBack.
  ///
  /// In en, this message translates to:
  /// **'skip to last chapter'**
  String get tooltipTransportskipChapterBack;

  /// No description provided for @tooltipTransportskipChapterFwd.
  ///
  /// In en, this message translates to:
  /// **'skip to next chapter'**
  String get tooltipTransportskipChapterFwd;

  /// No description provided for @tooltipTransportskipBack.
  ///
  /// In en, this message translates to:
  /// **'skip back'**
  String get tooltipTransportskipBack;

  /// No description provided for @tooltipTransportskipFwd.
  ///
  /// In en, this message translates to:
  /// **'skip forwards'**
  String get tooltipTransportskipFwd;

  /// No description provided for @unskipLabel.
  ///
  /// In en, this message translates to:
  /// **'go back'**
  String get unskipLabel;

  /// No description provided for @autoPauseOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get autoPauseOff;

  /// No description provided for @autoPauseOffAt.
  ///
  /// In en, this message translates to:
  /// **'Off {at}'**
  String autoPauseOffAt(String at);

  /// No description provided for @autoPauseEndOfChapter.
  ///
  /// In en, this message translates to:
  /// **'End Of Chapter'**
  String get autoPauseEndOfChapter;

  /// No description provided for @trayShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get trayShow;

  /// No description provided for @trayHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get trayHide;

  /// No description provided for @trayExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get trayExit;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsTitle;

  /// No description provided for @settingsPlayerSetting.
  ///
  /// In en, this message translates to:
  /// **'Player Preferences'**
  String get settingsPlayerSetting;

  /// No description provided for @settingsSkipButtons.
  ///
  /// In en, this message translates to:
  /// **'Skip buttons duration'**
  String get settingsSkipButtons;

  /// No description provided for @settingsSkipButtonsSubLabel.
  ///
  /// In en, this message translates to:
  /// **'How much time the skip buttons should seek the play position by'**
  String get settingsSkipButtonsSubLabel;

  /// No description provided for @settingsSecLabel.
  ///
  /// In en, this message translates to:
  /// **'{num} Seconds'**
  String settingsSecLabel(int num);

  /// No description provided for @settingsMinLabel.
  ///
  /// In en, this message translates to:
  /// **'{num} Minutes'**
  String settingsMinLabel(int num);

  /// No description provided for @settingsUnskip.
  ///
  /// In en, this message translates to:
  /// **'Unskip timeout'**
  String get settingsUnskip;

  /// No description provided for @settingsUnskipSubLabel.
  ///
  /// In en, this message translates to:
  /// **'how long the unskip button stays visible after seeking'**
  String get settingsUnskipSubLabel;

  /// No description provided for @settingsPerformanceMode.
  ///
  /// In en, this message translates to:
  /// **'Low performance mode'**
  String get settingsPerformanceMode;

  /// No description provided for @settingsPerformanceModeSubLabel.
  ///
  /// In en, this message translates to:
  /// **'Make the app less pretty for more fast'**
  String get settingsPerformanceModeSubLabel;

  /// No description provided for @settingsSystem.
  ///
  /// In en, this message translates to:
  /// **'System Integration'**
  String get settingsSystem;

  /// No description provided for @settingsSystemSubLabel.
  ///
  /// In en, this message translates to:
  /// **'Integrate with the desktop environment'**
  String get settingsSystemSubLabel;

  /// No description provided for @settingsTray.
  ///
  /// In en, this message translates to:
  /// **'Minimize to systemtray'**
  String get settingsTray;

  /// No description provided for @settingsTraySubLabel.
  ///
  /// In en, this message translates to:
  /// **'Keep player in system tray instead of quitting when main window is closed'**
  String get settingsTraySubLabel;

  /// No description provided for @settingsTrayAlways.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get settingsTrayAlways;

  /// No description provided for @settingsTrayWhenPlaying.
  ///
  /// In en, this message translates to:
  /// **'When Playing'**
  String get settingsTrayWhenPlaying;

  /// No description provided for @settingsTrayNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get settingsTrayNever;

  /// No description provided for @settingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get settingsDangerZone;

  /// No description provided for @settingsDangerZoneSubLabel.
  ///
  /// In en, this message translates to:
  /// **'Destructive actions'**
  String get settingsDangerZoneSubLabel;

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get settingsClearCache;

  /// No description provided for @settingsClearCacheSubLabel.
  ///
  /// In en, this message translates to:
  /// **'Deletes cached cover images'**
  String get settingsClearCacheSubLabel;

  /// No description provided for @settingsClearCacheAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get settingsClearCacheAlertTitle;

  /// No description provided for @settingsClearCacheAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Really delete cached coved images?'**
  String get settingsClearCacheAlertBody;

  /// No description provided for @settingsDeleteHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete history'**
  String get settingsDeleteHistory;

  /// No description provided for @settingsDeleteHistorySubLabel.
  ///
  /// In en, this message translates to:
  /// **'deletes all playback positions in your audiobooks'**
  String get settingsDeleteHistorySubLabel;

  /// No description provided for @settingsDeleteHistoryAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete history'**
  String get settingsDeleteHistoryAlertTitle;

  /// No description provided for @settingsDeleteHistoryAlertBody.
  ///
  /// In en, this message translates to:
  /// **'deletes all playback positions in your audiobooks. Leaves the files where they are.'**
  String get settingsDeleteHistoryAlertBody;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
