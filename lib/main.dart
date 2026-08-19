import 'package:fl_audiobook/home.dart';
import 'package:fl_audiobook/model.dart';
import 'package:fl_audiobook/my_home_page.dart';

import 'package:media_kit/media_kit.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:watch_it/watch_it.dart';

import 'package:yaru/yaru.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// Provides [Player], [Media], [Playlist] etc.
Future<void> main() async {
  MediaKit.ensureInitialized();
  await FFmpegKitExtended.initialize();
  await YaruWindowTitleBar.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();
  
  di
    ..registerLazySingleton<Connectivity>(Connectivity.new)
    ..registerLazySingleton<Model>(
      () => Model(di<Connectivity>()),
      dispose: (m) => m.dispose(),
    );

  await di<Model>().init();
  runApp(const ExampleHome());
}
