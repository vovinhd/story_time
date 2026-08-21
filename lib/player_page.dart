import 'dart:math';
import 'dart:ui';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:fl_audiobook/playback_position_slider.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:popover/popover.dart';
import 'package:yaru/yaru.dart';

import "globals.dart" as globals;

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
  try {
    return (double.parse(timestamp) * 1_000_000).round();
  } catch (error) {
    print(error); 
    return 0; 
  }
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: YaruWindowTitleBar(
        onShowMenu: (p0) => {},
        border: BorderSide.none,
        leading: YaruBackButton(),
        title: Text("Player"),
        actions: [],
      ),

      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: .spaceAround,
          spacing: 16.0,
          children: [
            Expanded(
              child: Container(
                key: UniqueKey(),
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(16.0),
                constraints: BoxConstraints.expand(),
                child: widget.cover,
              ),
            ),
            Column(
              spacing: 8.0,
              crossAxisAlignment: .start,
              children: [
                StreamBuilder(
                  stream: globals.player.stream.position,
                  builder: (context, snapshotPosition) {
                    Duration pos;
                    if (snapshotPosition.hasData) {
                      pos = snapshotPosition.data!;
                    } else {
                      pos = globals.player.state.position;
                    }
                    return ChapterListButton(
                      chapters: widget.chapters,
                      currentChapter: globals.getChapterFor(pos),
                      player: widget.player,
                    );
                  },
                ),
                PlaybackControls(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlaybackControls extends StatefulWidget {
  const PlaybackControls({super.key});

  @override
  State<StatefulWidget> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.space): () {
          print("SPACE");
          globals.player.playOrPause();
        },
      },
      child: Column(
        mainAxisAlignment: .center,
        children: [
          PlaybackPositionSlider(),
          Row(
            spacing: 8,
            mainAxisAlignment: .spaceBetween,
            children: [
              CurrentPositionInChapterLabel(),
              CurrentPositionLabel(),
              EndLabel(),
            ],
          ),
          Row(
            mainAxisAlignment: .spaceBetween,

            children: [
              Row(
                children: [
                  YaruOptionButton(
                    onPressed: () {

                    showPopover(
                      context: context,
                      bodyBuilder: (context) => const VolumeSlider(),
                      onPop: () => print('Popover was popped!'),
                      direction: PopoverDirection.bottom,
                      backgroundColor: YaruColors.coolGrey,
                      width: 50,
                      height: 200,
                      arrowHeight: 0,
                      arrowWidth: 0,
                    );

                    },
                    child: Icon(YaruIcons.speaker),
                  ),
                  YaruOptionButton(
                    onPressed: () => {},
                    child: Text("1x"),
                  ),
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
                        YaruIcons.skip_backward,
                        size: 30,
                      ), // Larger icon to fill the space
                      onPressed: globals.seekLastChapter,
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
                        YaruIcons.fast_backward,
                        size: 30,
                      ), // Larger icon to fill the space
                      onPressed: globals.seekBack,
                    ),
                  ),

                  SizedBox(
                    width: 80, // Custom width
                    height: 80, // Custom height
                    child: StreamBuilder(
                      stream: globals.player.stream.playing,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          return IconButton(
                            padding: EdgeInsets.all(
                              12,
                            ), // Adjust padding to center the icon
                            icon: Icon(
                              asyncSnapshot.data!
                                  ? YaruIcons.media_pause
                                  : YaruIcons.media_play,
                              size: 48,
                            ), // Larger icon to fill the space
                            onPressed: globals.player.playOrPause,
                          );
                        }
                        return IconButton(
                          padding: EdgeInsets.all(
                            12,
                          ), // Adjust padding to center the icon
                          icon: Icon(
                            globals.player.state.playing
                                ? YaruIcons.media_pause
                                : YaruIcons.media_play,
                            size: 48,
                          ), // Larger icon to fill the space
                          onPressed: globals.player.playOrPause,
                        );
                      },
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
                      onPressed: globals.seekForward,
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
                        YaruIcons.skip_forward,
                        size: 30,
                      ), // Larger icon to fill the space
                      onPressed: globals.seekNextChapter,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 34,),
                  YaruOptionButton(
                    onPressed: () => {},
                    child: Icon(YaruIcons.stopwatch),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VolumeSlider extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      RotatedBox(
        quarterTurns: 1, child: Slider(value: 0.0, onChanged: (value) {})
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
          StreamBuilder(
            stream: globals.player.stream.position,
            builder: (context, asyncSnapshot) {
              Duration pos;
              if (asyncSnapshot.hasData) {
                pos = asyncSnapshot.data!;
              } else {
                pos = globals.player.state.position;
              }
              return Text(globals.getChapterFor(pos).tags!["title"]);
            },
          ),
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
