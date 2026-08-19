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
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.pink)),
      home: const MyHomePage(title: 'Audiobookplayer'),
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

  // Source - https://stackoverflow.com/a/54775297
  // Posted by diegoveloper, modified by community. See post 'Timeline' for change history
  // Retrieved 2026-08-19, License - CC BY-SA 4.0

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
        print(
          "CHAPTER ${chapter.id}: ${chapterInfoTimeToMicros(chapter.startTime!)}, ${chapterInfoTimeToMicros(chapter.endTime!)}",
        );
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

  void seekChapter(ChapterInformation ch) {
    final micros = (Duration(
      microseconds: chapterInfoTimeToMicros(ch.startTime!),
    ));

    // TODO EXTRACT THIS
    if (player.state.playing) {
      player.seek(micros);
    } else {
      playPosition = micros;
      setState(() {});
    }
  }

  void playPause() {
    player.playOrPause();
  }

  void _seekPlayhead(double value) {
    final double chapterStartTime = chapterInfoTimeToMicros(
      currentChapter!.startTime!,
    ).toDouble();
    final double chapterEndTime = chapterInfoTimeToMicros(
      currentChapter!.endTime!,
    ).toDouble();

    final micros = Duration(
      microseconds:
          ((chapterEndTime - chapterStartTime) * value + chapterStartTime)
              .round(),
    );

    if (player.state.playing) {
      player.seek(micros);
    } else {
      playPosition = micros;
      setState(() {});
    }
  }

  double _getPlayheadPosition() {
    if (currentChapter == null) return 0.0;
    if (!player.state.playing) {
      return 0.0; 
    }
    final double chapterStartTime = chapterInfoTimeToMicros(
      currentChapter!.startTime!,
    ).toDouble();
    final double chapterEndTime = chapterInfoTimeToMicros(
      currentChapter!.endTime!,
    ).toDouble();
    final double positionMicros = playPosition.inMicroseconds.toDouble();

    final res =
        (positionMicros - chapterStartTime) /
        (chapterEndTime - chapterStartTime);
    if (res >= 0.0 || res <= 1.0) {
      return res;
    } else {
      return 0.0;
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
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Column(
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
                  _printDuration(playPosition),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                // playback controls
                Column(
                  mainAxisAlignment: .center,
                  children: [
                    Slider(
                      value: _getPlayheadPosition(),
                      min: 0,
                      max: 1.0,
                      onChanged: (value) => _seekPlayhead(value),
                    ),
                    Row(
                      mainAxisAlignment: .center,

                      children: [
                        TextButton(onPressed: seekBack, child: Text("10 Back")),
                        TextButton(
                          onPressed: playPause,
                          child: Text("Play/Pause"),
                        ),
                        TextButton(
                          onPressed: seekForward,
                          child: Text("10 Fwd"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: .center,
              children: chapters != null
                  ? [
                      Text(
                        "Chapters",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 500,
                            minHeight: 100,
                            maxWidth: 500,
                            minWidth: 100,
                          ),
                          child: ListView.builder(
                            itemCount: chapters!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(chapters![index].tags!["title"]),
                                trailing: Text(
                                  _printDuration(
                                    Duration(
                                      microseconds: (chapterInfoTimeToMicros(
                                        chapters![index].startTime!,
                                      )),
                                    ),
                                  ),
                                ),
                                onTap: () => {seekChapter(chapters![index])},
                              );
                            },
                          ),
                        ),
                      ),
                    ]
                  : [Text("oop")],
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
}
