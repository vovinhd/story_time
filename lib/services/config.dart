import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/services/player_service.dart';
import 'package:xdg_directories/xdg_directories.dart';

// ignore: non_constant_identifier_names
String CONFIG_PATH = "${dataHome.path}/${globals.APP_DIR}/config.json";

class ConfigProvider {
  static final ConfigProvider _singleton = ConfigProvider._internal();
  Config config = LoadConfig();
  static File configFile = File(CONFIG_PATH);
  factory ConfigProvider() {
    return _singleton;
  }

  final configStreamController = StreamController<Config>.broadcast();

  ConfigProvider._internal();

  Config get getConfig {
    return config;
  }

  // ignore: non_constant_identifier_names
  static Config LoadConfig() {
    if (!configFile.existsSync()) {
      configFile.createSync();
      Config defaultConfig = Config(
        volume: 1,
        playbackSpeed: 1,
        playbackStates: [],
        skipDuration: Duration(seconds: 30),
        unksipTimeout: Duration(seconds: 3),
        performanceMode: false,
        systemTrayUsage: SystemTrayUsage.whenPlaying,
        enableDBus: true,
      );
      configFile.writeAsStringSync(jsonEncode(defaultConfig));
    }

    try {
      String configJson = configFile.readAsStringSync();
      final configMap = jsonDecode(configJson) as Map<String, dynamic>;
      return Config.fromJson(configMap);
    } catch (e) {
      configFile.deleteSync();
      return LoadConfig();
    }
  }

  BookPlaybackState? getPlaybackStateForFile(String filename) {
    if (config.playbackStates.any(
      (value) => value.file == filename,
    )) {
      BookPlaybackState currentState = config.playbackStates.firstWhere(
        (value) => value.file == filename,
      );
      return currentState;
    } else {
      return null;
    }
  }

  // ignore: non_constant_identifier_names
  void SaveConfig() {
    final configMap = config.toJson();
    final configJson = jsonEncode(configMap);

    configFile.writeAsStringSync(configJson);
  }

  void notify() {
    configStreamController.sink.add(config);
  }

  double get volume {
    return config.volume;
  }

  double get playbackSpeed {
    return config.playbackSpeed;
  }

  List<BookPlaybackState> get playbackStates {
    return config.playbackStates;
  }

  set setVolume(double volume) {
    config.volume = volume;
    notify();
  }

  set setPlaybackSpeed(double playbackSpeed) {
    config.playbackSpeed = playbackSpeed;
    notify();
  }

  set setPlaybackStates(List<BookPlaybackState> states) {
    config.playbackStates = states;
    notify();
  }

  void updatePlaybackState() async {
    if (PlayerService().playingFile == null ||
        PlayerService().duration.inMicroseconds == 0) {
      return;
    }
    await Future.delayed(Duration(milliseconds: 100));
    final filename = PlayerService().playingFile!.name;
    final filepath = PlayerService().playingFile!.path;

    if (config.playbackStates.any(
      (value) => value.file == PlayerService().playingFile!.name,
    )) {
      BookPlaybackState currentState = config.playbackStates.firstWhere(
        (value) => value.file == PlayerService().playingFile!.name,
      );
      if (currentState.position == PlayerService().position.inMicroseconds) {
        return;
      }
    }

    final state = BookPlaybackState(
      file: filename,
      path: filepath,
      title: PlayerService().tags["title"],
      position: PlayerService().position.inMicroseconds,
      duration: PlayerService().duration.inMicroseconds,
      lastPlayed: DateTime.now(),
      author: PlayerService().tags["artist"],
    );

    config.playbackStates.removeWhere(
      (value) => value.path == PlayerService().playingFile!.path,
    );

    config.playbackStates.insert(0, state);

    SaveConfig();
    notify();
  }

  void removePlaybackState(String name) async {
    config.playbackStates.removeWhere((value) => value.file == name);
    SaveConfig();
    notify();
  }

  void deleteCache() {
    print("deleteCache not implemented");
  }

  void deleteHistory() {
    print("deleteHistory not implemented");
  }
}

enum SystemTrayUsage { always, whenPlaying, never }

SystemTrayUsage string2SystemTrayUsage(String str) {
  switch (str) {
    case "always":
      return SystemTrayUsage.always;
    case "whenPlaying":
      return SystemTrayUsage.whenPlaying;
    case "never":
      return SystemTrayUsage.never;
    default:
      print("malformed config, ${str} not an option for SystemTrayUsage");
      return SystemTrayUsage.whenPlaying;
  }
}

String systemTrayUsage2String(SystemTrayUsage stu) {
  switch (stu) {
    case SystemTrayUsage.always:
      return "always";
    case SystemTrayUsage.whenPlaying:
      return "whenPlaying";
    case SystemTrayUsage.never:
      return "never";
  }
}

class Config {
  // in player config
  double volume;
  double playbackSpeed;

  // settings page
  Duration skipDuration;
  Duration unksipTimeout;
  bool performanceMode;

  // system
  SystemTrayUsage systemTrayUsage;
  bool enableDBus;

  // books
  List<BookPlaybackState> playbackStates;

  Config({
    required this.volume,
    required this.playbackSpeed,
    required this.skipDuration,
    required this.unksipTimeout,
    required this.performanceMode,
    required this.systemTrayUsage,
    required this.enableDBus,
    required this.playbackStates,
  });

  Config.fromJson(Map<String, dynamic> json)
    : volume = json["volume"] as double,
      playbackSpeed = json["playback_speed"] as double,
      skipDuration = Duration(seconds: (json["skip_duration"]) as int),
      unksipTimeout = Duration(seconds: (json["unskip_timeout"]) as int),
      performanceMode = json["performance_mode"] as bool,
      systemTrayUsage = string2SystemTrayUsage(
        json["system_tray_usage"] as String,
      ),
      enableDBus = json["enable_dbus"] as bool,
      playbackStates = (json["playback_states"] as List<dynamic>)
          .map((value) => BookPlaybackState.fromJson(value))
          .toList();

  Map<String, dynamic> toJson() => {
    'volume': volume,
    'playback_speed': playbackSpeed,
    'skip_duration': skipDuration.inSeconds,
    'unskip_timeout': unksipTimeout.inSeconds,
    'performance_mode': performanceMode,
    'system_tray_usage': systemTrayUsage2String(systemTrayUsage),
    'enable_dbus': enableDBus,
    'playback_states': playbackStates,
  };
}

class BookPlaybackState {
  final String file;
  final String path;
  final String title;
  final String author;

  final int position;
  final int duration;
  final DateTime lastPlayed;

  BookPlaybackState({
    required this.file,
    required this.position,
    required this.lastPlayed,
    required this.duration,
    required this.path,
    required this.title,
    required this.author,
  });

  BookPlaybackState.fromJson(Map<String, dynamic> json)
    : file = json["file"] as String,
      path = json["path"] as String,
      title = json["title"] as String,
      author = json["author"] as String,

      position = json["position"] as int,
      duration = json["duration"] as int,

      lastPlayed = DateTime.fromMillisecondsSinceEpoch(
        json["last_played"] as int,
      );

  Map<String, dynamic> toJson() => {
    'file': file,
    'path': path,
    'title': title,
    'author': author,

    'position': position,
    'last_played': lastPlayed.millisecondsSinceEpoch,
    'duration': duration,
  };
}
