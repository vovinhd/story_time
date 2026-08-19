import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late final player = Player();

  Image coverImage = (Image.asset(
    "images/cover_default.png",
    key: UniqueKey(),
  ));
  PlatformFile? file;
  String title = "";
  String author = "";

  List<ChapterInformation>? chapters;
  Map<String, dynamic>? tags;

  String chapterTitle = "";
  ChapterInformation? currentChapter;
  Duration playPosition = Duration(seconds: 0);

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  int chapterInfoTimeToMicros(String timestamp) {
    return (double.parse(timestamp) * 1_000_000).round();
  }

  ChapterInformation? _getChapterFor(Duration position) {



    if (chapters != null) {
      for (var chapter in chapters!) {

        final chapterStartTime = chapterInfoTimeToMicros(chapter.startTime!); 
        final chapterEndTime = chapterInfoTimeToMicros(chapter.endTime!); 
        final positionMicros = position.inMicroseconds; 
        if (chapterStartTime < positionMicros &&
            positionMicros <= chapterEndTime) {
          return chapter;
        }
      }
    }
    return chapters!.first;
  }

  void _setCurrentChapter(ChapterInformation chapter) {
    chapterTitle = chapter.tags?["title"];


    currentChapter = chapter;
  }

  void _updateState(Timer timer) {
    if (player.state.playing) {
      playPosition = player.state.position;
      ChapterInformation? playbackChapter = _getChapterFor(playPosition);
      if (playbackChapter != null) {
        _setCurrentChapter(playbackChapter);
      }
      setState(() {});
    }
  }

  void _openFile() async {
    PlatformFile? file = await FilePicker.pickFile();

    if (file != null) {
      // print(file.name);
      // print(await file.length());
      final media = Media(file.path!);
      // print(media.toString());
      player.open(media, play: true);

      final canonicalPath = "\"${file.path!}\"";

      final session = FFprobeKit.getMediaInformation(canonicalPath);
      final info = session.getMediaInformation();
      print(info?.chapters);
      chapters = info?.chapters;

      for (var chapter in chapters!) {
        print("CHAPTER ${chapter.id}: ${chapterInfoTimeToMicros(chapter.startTime!)}, ${chapterInfoTimeToMicros(chapter.endTime!)}");
      }

      tags = info?.tags;
      print(info?.tags);

      title = info?.tags?["album"];
      author = info?.tags?["artist"];
      chapterTitle = info?.chapters[0].tags?["title"];

      final coverPath = "/tmp/${file.name}.jpg";
      final coverSess = FFmpegKit.execute(
        "-y -i $canonicalPath -an -vcodec copy \"$coverPath\"",
      );
      // print(coverSess.getReturnCode());
      coverImage = Image.file(File(coverPath), key: UniqueKey());
      setState(() {});
    } else {
      // User canceled the picker
      print("User canceled the picker");
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (timer) => _updateState(timer));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            Text(author, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(width: 250, height: 250, child: coverImage),
            Text(
              chapterTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              playPosition.toString(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            // playback controls
            Row(
              mainAxisAlignment: .center,

              children: [
                TextButton(onPressed: seekBack, child: Text("10 Back")),
                TextButton(onPressed: playPause, child: Text("PlayPause")),
                TextButton(onPressed: seekForward, child: Text("10 Fwd")),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFile(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void seekBack() {
    seekOffset(-10);
  }

  void seekForward() {
    seekOffset(10);
  }

  void seekOffset(int seconds) {
    final currentPos = player.state.position;
    final newPos = currentPos.inSeconds + seconds;

    seek(Duration(seconds: max(0, newPos)));
  }

  void seek(Duration duration) {
    player.seek(duration);
  }

  void playPause() {
    player.playOrPause();
  }
}
