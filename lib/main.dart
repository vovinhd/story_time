import 'package:fl_audiobook/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';

// Provides [Player], [Media], [Playlist] etc.
void main() async {
  MediaKit.ensureInitialized();
  await FFmpegKitExtended.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.pink)),
      home: const MyHomePage(title: 'Audiobookplayer'),
    );
  }
}
