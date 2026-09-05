// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get helloWorld => 'Hallo, Welt!';

  @override
  String get loading => 'Lade';

  @override
  String get menuOpen => 'Öffnen';

  @override
  String get menuOpenAccelerator => 'Strg+O';

  @override
  String get menuSettings => 'Einstellungen';

  @override
  String get menuSettingsAccelerator => 'Strg+,';

  @override
  String get menuAbout => 'Über Story Time';

  @override
  String get heroHintTitle => 'Höre Hörbücher';

  @override
  String get heroHintSubtitle => 'Unterstützte Dateiformate: .m4b, .m4a, .mp3';

  @override
  String get heroHintButtonLabel => 'Hörbuch öffnen';

  @override
  String get heroPlayerNowPLaying => 'Läuft gerade';

  @override
  String get lastPlayedListHint => 'Zuletzt gespielt';

  @override
  String artistLabel(String author) {
    return 'von $author';
  }

  @override
  String lastPlayedCardLastPlayed(String dateTimeLabel) {
    return 'zuletzt gespielt $dateTimeLabel';
  }

  @override
  String lastPlayedCardRemaining(String timeRemainingLabel) {
    return '$timeRemainingLabel verbleibend';
  }

  @override
  String lastPlayedCardLocate(String title) {
    return 'Finde $title';
  }

  @override
  String lastPlayedCardForget(String title) {
    return 'Vergiss $title';
  }

  @override
  String get lastPlayedCardReveal => 'In Dateisystem anzeigen';

  @override
  String get lastPlayedCardForgetButton => 'Aus Verlauf entfernen';

  @override
  String get dialogOk => 'Ok';

  @override
  String get dialogCancel => 'Abbrechen';

  @override
  String tooltipPlay(String title) {
    return '$title abspielen';
  }

  @override
  String tooltipOptions(String title) {
    return 'Optionen für $title';
  }

  @override
  String get fileNotAvailable => 'Datei nicht verfügbar. Ist das Laufwerk eingehängt?';

  @override
  String get tooltipTags => 'Zeige Medieninformationen';

  @override
  String get tooltipVolume => 'Lautstärke';

  @override
  String get tooltipSpeed => 'Abspielgeschwindigkeit';

  @override
  String get tooltipTimer => 'Wecker';

  @override
  String get tooltipTransportPlay => 'Abspielen';

  @override
  String get tooltipTransportPause => 'Pause';

  @override
  String get tooltipTransportskipChapterBack => 'zum letzten Kapitel';

  @override
  String get tooltipTransportskipChapterFwd => 'zum nächsten Kapitel';

  @override
  String get tooltipTransportskipBack => 'springe zurück';

  @override
  String get tooltipTransportskipFwd => 'springe nach vorn';

  @override
  String get unskipLabel => 'zurück';

  @override
  String get autoPauseOff => 'Aus';

  @override
  String autoPauseOffAt(String at) {
    return 'Aus $at';
  }

  @override
  String get autoPauseEndOfChapter => 'Ende des Kapitels';

  @override
  String get trayShow => 'Anzeigen';

  @override
  String get trayHide => 'Verstecken';

  @override
  String get trayExit => 'Programm beenden';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsPlayerSetting => 'Abspieleinstellungen';

  @override
  String get settingsSkipButtons => 'Überspringen-Tasten Dauer';

  @override
  String get settingsSkipButtonsSubLabel => 'Wieviel Zeit mit den Überspringen-Tasten übersprungen wird';

  @override
  String settingsSecLabel(int num) {
    return '$num Sekunden';
  }

  @override
  String settingsMinLabel(int num) {
    return '$num Minuten';
  }

  @override
  String get settingsUnskip => 'Zurück Anzeigedauer';

  @override
  String get settingsUnskipSubLabel => 'Wie lange der Zurückknopf angezeigt wird nachdem die Abspielposition geändert wurde';

  @override
  String get settingsPerformanceMode => 'Langsamer Computer Modus';

  @override
  String get settingsPerformanceModeSubLabel => 'Keine Weichzeichnereffekte. Für langsame Hardware';

  @override
  String get settingsSystem => 'System Integration';

  @override
  String get settingsSystemSubLabel => 'Integriere in die Desktopumgebung';

  @override
  String get settingsTray => 'In das Systemtray minimieren';

  @override
  String get settingsTraySubLabel => 'Den Player in das Systemtray minimieren statt das Programm zu beenden';

  @override
  String get settingsTrayAlways => 'Immer';

  @override
  String get settingsTrayWhenPlaying => 'Während Wiedergabe';

  @override
  String get settingsTrayNever => 'Nie';

  @override
  String get settingsDangerZone => 'Danger Zone';

  @override
  String get settingsDangerZoneSubLabel => 'Destruktive Akitionen, mit vorsicht benutzen';

  @override
  String get settingsClearCache => 'Bildcache leeren';

  @override
  String get settingsClearCacheSubLabel => 'Löscht gespeicherte Cover-Bilder';

  @override
  String get settingsClearCacheAlertTitle => 'Bildcache leeren';

  @override
  String get settingsClearCacheAlertBody => 'Bildcache wirklich leeren?';

  @override
  String get settingsDeleteHistory => 'Verlauf löschen';

  @override
  String get settingsDeleteHistorySubLabel => 'Löscht alle Abspielpositionen';

  @override
  String get settingsDeleteHistoryAlertTitle => 'Verlauf löschen';

  @override
  String get settingsDeleteHistoryAlertBody => 'Löscht alle Abspielpositionen. Löscht keine Dateien.';
}
