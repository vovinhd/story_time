import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_audiobook/globals.dart' as globals;
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

  final streamController = StreamController<Config>();

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
      );
      configFile.writeAsStringSync(jsonEncode(defaultConfig));
    }
    String configJson = configFile.readAsStringSync();
    final configMap = jsonDecode(configJson) as Map<String, dynamic>;
    return Config.fromJson(configMap);
  }

  // ignore: non_constant_identifier_names
  void SaveConfig() {
    final configMap = config.toJson();
    final configJson = jsonEncode(configMap);

    configFile.writeAsStringSync(configJson);
  }

  void notify() {
    streamController.sink.add(config);
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

  void updatePlaybackState() {
    if (globals.playingFile == null) return;
    final filename = globals.playingFile!.name;
    final state = BookPlaybackState(
      file: filename,
      path: globals.playingFile!.path!,
      title: globals.tags!["title"],
      position: globals.player.state.position.inMicroseconds,
      duration: globals.player.state.duration.inMicroseconds,
      lastPlayed: DateTime.now(),
    );

    config.playbackStates.removeWhere((value) => value.file == filename);
    config.playbackStates.insert(0, state);

    SaveConfig();
    notify();
  }
}

class Config {
  double volume;
  double playbackSpeed;

  List<BookPlaybackState> playbackStates;

  Config({
    required this.volume,
    required this.playbackSpeed,
    required this.playbackStates,
  });

  Config.fromJson(Map<String, dynamic> json)
    : volume = json["volume"] as double,
      playbackSpeed = json["playback_speed"] as double,
      playbackStates = (json["playback_states"] as List<dynamic>)
          .map((value) => BookPlaybackState.fromJson(value))
          .toList();

  Map<String, dynamic> toJson() => {
    'volume': volume,
    'playback_speed': playbackSpeed,
    'playback_states': playbackStates,
  };
}

class BookPlaybackState {
  final String file;
  final String path;
  final String title;
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
  });

  BookPlaybackState.fromJson(Map<String, dynamic> json)
    : file = json["file"] as String,
      path = json["path"] as String,
      title = json["title"] as String,
      position = json["position"] as int,
      duration = json["duration"] as int,

      lastPlayed = DateTime.fromMillisecondsSinceEpoch(
        json["last_played"] as int,
      );

  Map<String, dynamic> toJson() => {
    'file': file,
    'path': path,
    'title': title,

    'position': position,
    'last_played': lastPlayed.millisecondsSinceEpoch,
    'duration': duration,
  };
}
