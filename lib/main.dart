import 'dart:io';

import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/home.dart';
import 'package:fl_audiobook/model.dart';

import 'package:media_kit/media_kit.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:watch_it/watch_it.dart';
import 'package:xdg_directories/xdg_directories.dart';

import 'package:yaru/yaru.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// Provides [Player], [Media], [Playlist] etc.
Future<void> main() async {
  MediaKit.ensureInitialized();
  await FFmpegKitExtended.initialize();
  await YaruWindowTitleBar.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();
  await Directory("${dataHome.path}/${globals.APP_DIR}").create(recursive: true);
  di
    ..registerLazySingleton<Connectivity>(Connectivity.new)
    ..registerLazySingleton<Model>(
      () => Model(di<Connectivity>()),
      dispose: (m) => m.dispose(),
    );

  await di<Model>().init();
  runApp(const ExampleHome());
}
