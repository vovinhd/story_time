// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get loading => 'loading';

  @override
  String get menuOpen => 'Open';

  @override
  String get menuOpenAccelerator => 'Ctrl+O';

  @override
  String get menuSettings => 'Preferences';

  @override
  String get menuSettingsAccelerator => 'Ctrl+,';

  @override
  String get menuAbout => 'About fl_audiobook';

  @override
  String get heroHintTitle => 'Listen to audiobooks';

  @override
  String get heroHintSubtitle => 'supported file types: .m4b, .m4a, .mp3';

  @override
  String get heroHintButtonLabel => 'Open Audiobook';

  @override
  String get heroPlayerNowPLaying => 'Now Playing';

  @override
  String get lastPlayedListHint => 'Last Played';

  @override
  String artistLabel(String author) {
    return 'by $author';
  }

  @override
  String lastPlayedCardLastPlayed(String dateTimeLabel) {
    return 'last played $dateTimeLabel';
  }

  @override
  String lastPlayedCardRemaining(String timeRemainingLabel) {
    return '$timeRemainingLabel remaining';
  }

  @override
  String lastPlayedCardLocate(String title) {
    return 'Locate $title';
  }

  @override
  String lastPlayedCardForget(String title) {
    return 'Forget $title';
  }

  @override
  String get lastPlayedCardReveal => 'Show in file explorer';

  @override
  String get lastPlayedCardForgetButton => 'remove from history';

  @override
  String get dialogOk => 'Ok';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String tooltipPlay(String title) {
    return 'play $title';
  }

  @override
  String tooltipOptions(String title) {
    return 'options for $title';
  }

  @override
  String get fileNotAvailable => 'File not available, make sure to mount the device it\'s on!';

  @override
  String get tooltipTags => 'show media information';

  @override
  String get tooltipVolume => 'volume';

  @override
  String get tooltipSpeed => 'playback speed';

  @override
  String get tooltipTimer => 'timer';

  @override
  String get tooltipTransportPlay => 'Play';

  @override
  String get tooltipTransportPause => 'Pause';

  @override
  String get tooltipTransportskipChapterBack => 'skip to last chapter';

  @override
  String get tooltipTransportskipChapterFwd => 'skip to next chapter';

  @override
  String get tooltipTransportskipBack => 'skip back';

  @override
  String get tooltipTransportskipFwd => 'skip forwards';

  @override
  String get unskipLabel => 'go back';

  @override
  String get autoPauseOff => 'Off';

  @override
  String autoPauseOffAt(String at) {
    return 'Off $at';
  }

  @override
  String get autoPauseEndOfChapter => 'End Of Chapter';

  @override
  String get trayShow => 'Show';

  @override
  String get trayHide => 'Hide';

  @override
  String get trayExit => 'Exit';

  @override
  String get settingsTitle => 'Preferences';

  @override
  String get settingsPlayerSetting => 'Player Preferences';

  @override
  String get settingsSkipButtons => 'Skip buttons duration';

  @override
  String get settingsSkipButtonsSubLabel => 'How much time the skip buttons should seek the play position by';

  @override
  String settingsSecLabel(int num) {
    return '$num Seconds';
  }

  @override
  String settingsMinLabel(int num) {
    return '$num Minutes';
  }

  @override
  String get settingsUnskip => 'Unskip timeout';

  @override
  String get settingsUnskipSubLabel => 'how long the unskip button stays visible after seeking';

  @override
  String get settingsPerformanceMode => 'Low performance mode';

  @override
  String get settingsPerformanceModeSubLabel => 'Make the app less pretty for more fast';

  @override
  String get settingsSystem => 'System Integration';

  @override
  String get settingsSystemSubLabel => 'Integrate with the desktop environment';

  @override
  String get settingsTray => 'Minimize to systemtray';

  @override
  String get settingsTraySubLabel => 'Keep player in system tray instead of quitting when main window is closed';

  @override
  String get settingsTrayAlways => 'Always';

  @override
  String get settingsTrayWhenPlaying => 'When Playing';

  @override
  String get settingsTrayNever => 'Never';

  @override
  String get settingsDangerZone => 'Danger Zone';

  @override
  String get settingsDangerZoneSubLabel => 'Destructive actions';

  @override
  String get settingsClearCache => 'Clear cache';

  @override
  String get settingsClearCacheSubLabel => 'Deletes cached cover images';

  @override
  String get settingsClearCacheAlertTitle => 'Clear cache';

  @override
  String get settingsClearCacheAlertBody => 'Really delete cached coved images?';

  @override
  String get settingsDeleteHistory => 'Delete history';

  @override
  String get settingsDeleteHistorySubLabel => 'deletes all playback positions in your audiobooks';

  @override
  String get settingsDeleteHistoryAlertTitle => 'Delete history';

  @override
  String get settingsDeleteHistoryAlertBody => 'deletes all playback positions in your audiobooks. Leaves the files where they are.';
}
