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

  final streamController = StreamController<Config>.broadcast();

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

  void updatePlaybackState() async {
    if (PlayerService().playingFile == null ||
        PlayerService().duration.inMicroseconds == 0) {
      return;
    }
    await Future.delayed(Duration(milliseconds: 100));
    final filename = PlayerService().playingFile!.name;
    final filepath = PlayerService().playingFile!.path;

    if (config.playbackStates.any(
      (value) => value.path == PlayerService().playingFile!.path,
    )) {
      BookPlaybackState currentState = config.playbackStates.firstWhere(
        (value) => value.path == PlayerService().playingFile!.path,
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

  void removePlaybackState(String path) async {
    config.playbackStates.removeWhere((value) => value.path == path);
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
