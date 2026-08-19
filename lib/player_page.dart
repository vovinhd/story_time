import 'dart:math';
import 'dart:ui';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:yaru/yaru.dart';

// Source - https://stackoverflow.com/a/54775297
// Posted by diegoveloper, modified by community. See post 'Timeline' for change history
// Retrieved 2026-08-19, License - CC BY-SA 4.0

String printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

int chapterInfoTimeToMicros(String timestamp) {
  return (double.parse(timestamp) * 1_000_000).round();
}

double lastPos = 0.0;

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    super.key,
    required this.player,
    required this.chapters,
    required this.tags,
    required this.cover,
  });

  final Player player;
  final List<ChapterInformation> chapters;
  final Map<String, dynamic> tags;
  final Image cover;

  ChapterInformation _getChapterFor(Duration position) {
    for (var chapter in chapters) {
      final chapterStartTime = chapterInfoTimeToMicros(chapter.startTime!);
      final chapterEndTime = chapterInfoTimeToMicros(chapter.endTime!);
      final positionMicros = position.inMicroseconds;
      if (chapterStartTime < positionMicros &&
          positionMicros <= chapterEndTime) {
        return chapter;
      }
    }

    return chapters.first;
  }

  @override
  State<PlayerPage> createState() => _PlayerPageState();

  void _openChapterActionSheet() {
    print("TODO!");
  }
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: .spaceAround,
        spacing: 16.0,
        children: [
          Container(
            key: UniqueKey(),
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(16.0),
            height: 300,
            width: 300,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(8.0)),
              child: widget.cover,
            ),
          ),
          StreamBuilder(
            stream: widget.player.stream.playing,
            builder: (context, snapshotPlayPause) {
              return StreamBuilder(
                stream: widget.player.stream.position,
                builder: (context, snapshotPosition) {
                  if (snapshotPosition.hasData) {
                    var currentChapter = widget._getChapterFor(
                      snapshotPosition.data!,
                    );

                    // Display the received data
                    return Column(
                      spacing: 8.0,
                      crossAxisAlignment: .start,
                      children: [
                        ChapterListButton(
                          chapters: widget.chapters,
                          currentChapter: currentChapter,
                          player: widget.player,
                        ),

                        PlaybackControls(
                          player: widget.player,
                          currentChapter: currentChapter,
                          position: snapshotPosition.data!,
                          isPlaying: snapshotPlayPause.data!,
                        ),
                      ],
                    );
                  } else {
                    // This case might occur if the stream closes without sending data
                    // or initialData wasn't provided and no data has arrived yet.
                    return CircularProgressIndicator();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class PlaybackControls extends StatefulWidget {
  final Duration position;
  final bool isPlaying;
  final Player player;
  final ChapterInformation currentChapter;

  const PlaybackControls({
    super.key,
    required this.player,
    required this.currentChapter,
    required this.position,
    required this.isPlaying,
  });

  void seekBack() {
    seekOffset(-10);
  }

  void seekForward() {
    seekOffset(10);
  }

  void seekOffset(int seconds) {
    final currentPos = position;
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

    player.seek(micros);
  }

  void _seekPlayhead(double value) {
    final double chapterStartTime = chapterInfoTimeToMicros(
      currentChapter.startTime!,
    ).toDouble();
    final double chapterEndTime = chapterInfoTimeToMicros(
      currentChapter.endTime!,
    ).toDouble();

    final micros = Duration(
      microseconds:
          ((chapterEndTime - chapterStartTime) * value + chapterStartTime)
              .round(),
    );
    player.seek(micros);
  }

  double _getPlayheadPosition(Duration duration) {
    if (!isPlaying) {
      return lastPos;
    }
    final double chapterStartTime = chapterInfoTimeToMicros(
      currentChapter.startTime!,
    ).toDouble();
    final double chapterEndTime = chapterInfoTimeToMicros(
      currentChapter.endTime!,
    ).toDouble();
    final double positionMicros = duration.inMicroseconds.toDouble();

    final res =
        (positionMicros - chapterStartTime) /
        (chapterEndTime - chapterStartTime);
    if (res >= 0.0 || res <= 1.0) {
      lastPos = res;
      return res;
    } else {
      return lastPos;
    }
  }

  @override
  State<StatefulWidget> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Slider(

              value: widget._getPlayheadPosition(widget.position),
              min: 0,
              max: 1.0,
              onChanged: (value) => widget._seekPlayhead(value),
            ), 
        Row(
          spacing: 8,
          mainAxisAlignment: .spaceBetween,
          children: [
            Text("00:00:00"),
            Text("00:00:00"),
            Text("00:00:00"),
          ],
        ),
        Row(
          mainAxisAlignment: .center,

          children: [
            SizedBox(
              width: 60, // Custom width
              height: 60, // Custom height
              child: IconButton(
                padding: EdgeInsets.all(
                  12,
                ), // Adjust padding to center the icon
                icon: Icon(
                  YaruIcons.fast_backward,
                  size: 30,
                ), // Larger icon to fill the space
                onPressed: widget.seekBack,
              ),
            ),
            SizedBox(
              width: 80, // Custom width
              height: 80, // Custom height
              child: IconButton(
                padding: EdgeInsets.all(
                  12,
                ), // Adjust padding to center the icon
                icon: Icon(
                  widget.isPlaying
                      ? YaruIcons.media_pause
                      : YaruIcons.media_play,
                  size: 48,
                ), // Larger icon to fill the space
                onPressed: widget.player.playOrPause,
              ),
            ),
            SizedBox(
              width: 60, // Custom width
              height: 60, // Custom height
              child: IconButton(
                padding: EdgeInsets.all(
                  12,
                ), // Adjust padding to center the icon
                icon: Icon(
                  YaruIcons.fast_forward,
                  size: 30,
                ), // Larger icon to fill the space
                onPressed: widget.seekForward,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ChapterListButton extends StatefulWidget {
  const ChapterListButton({
    super.key,
    required this.chapters,
    required this.currentChapter,
    required this.player,
  });

  final List<ChapterInformation> chapters;
  final ChapterInformation currentChapter;
  final Player player;
  @override
  State<ChapterListButton> createState() => _ChapterListButtonState();

  void _seekChapter(ChapterInformation chapterInformation) {
    final micros = (Duration(
      microseconds: chapterInfoTimeToMicros(chapterInformation.startTime!),
    ));

    player.seek(micros);
  }
}

class _ChapterListButtonState extends State<ChapterListButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(alignment: .centerLeft),
      child: Row(
        children: [
          Icon(YaruIcons.unordered_list),
          Text(widget.currentChapter.tags!["title"]),
        ],
      ),
      onPressed: () {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          useSafeArea: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
            maxWidth: 650,
          ),
          builder: (BuildContext context) {
            return SizedBox(
              child: Center(
                child: Column(
                  mainAxisAlignment: .center,
                  mainAxisSize: .min,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.9,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 4,
                        ),
                        itemCount: widget.chapters.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(widget.chapters[index].tags!["title"]),
                            trailing: Text(
                              printDuration(
                                Duration(
                                  microseconds: (chapterInfoTimeToMicros(
                                    widget.chapters[index].startTime!,
                                  )),
                                ),
                              ),
                            ),
                            onTap: () => {
                              widget._seekChapter(widget.chapters[index]),
                            },
                          );
                        },
                      ),
                    ),

                    // ElevatedButton(
                    //   child: const Text('Close BottomSheet'),
                    //   onPressed: () => Navigator.pop(context),
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
