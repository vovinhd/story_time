import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:fl_audiobook/auto_pause_timer.dart';
import 'package:fl_audiobook/playback_position_slider.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:media_kit/media_kit.dart';
import 'package:yaru/yaru.dart';

import "globals.dart" as globals;

// Source - https://stackoverflow.com/a/54775297
// Posted by diegoveloper, modified by community. See post 'Timeline' for change history
// Retrieved 2026-08-19, License - CC BY-SA 4.0

final GlobalKey<_PlaybackControlsState> _playbackControlsState =
    GlobalKey(); // Create a key

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
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.space): () {
          globals.player.playOrPause();
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
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
                  child: Stack(
                    children: [
                      Container(
                        key: UniqueKey(),
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.all(16.0),
                        constraints: BoxConstraints.expand(),
                        child: widget.cover,
                      ),

                      StreamBuilder(
                        stream: AutoPauseTimer.autoPauseRunnningStream,
                        builder: (context, asyncSnapshot) {
                          bool show = false;
                          if (asyncSnapshot.hasData && asyncSnapshot.data!) {
                            show = true;
                          }
                          return AnimatedOpacity(
                            opacity: show ? 1 : 0,
                            duration: Duration(milliseconds: 400),
                            child: Align(
                              alignment: AlignmentGeometry.topCenter,
                              child: Container(
                                constraints: BoxConstraints.loose(
                                  Size(200, 100),
                                ),
                                margin: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 32,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: YaruColors.coolGrey,
                                  borderRadius: BorderRadius.circular(1000),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: Offset(
                                        0,
                                        3,
                                      ), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: .center,
                                  spacing: 8,
                                  children: [
                                    // Icon(YaruIcons.stopwatch, size: 30,weight: 4,),
                                    Icon(
                                      YaruIcons.clear_night,
                                      size: 30,
                                      weight: 4,
                                    ),

                                    StreamBuilder(
                                      stream: AutoPauseTimer.remainingStream,
                                      builder: (context, asyncSnapshot) {
                                        if (!asyncSnapshot.hasData)
                                          return Text(
                                            ":00",
                                            style: TextStyle(
                                              fontWeight: .bold,
                                              fontSize: 20,
                                            ),
                                          );
                                        final label = printDuration(
                                          asyncSnapshot.data!,
                                        );
                                        return Text(
                                          label,
                                          style: TextStyle(
                                            fontWeight: .bold,
                                            fontSize: 20,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      Align(
                        alignment: AlignmentGeometry.bottomCenter,
                        child: Row(
                          mainAxisAlignment: .center,
                          children: [
                            Container(
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: YaruColors.coolGrey,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: .bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: const .all(
                                      Radius.circular(1000),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                label: Text("unskip"),
                                icon: Icon(YaruIcons.arrow_left),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    PlaybackControls(key: _playbackControlsState),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum VolumeBracket { overamp, high, med, low, mute }

VolumeBracket fromVolume(double volume) {
  if (volume > 100.0) {
    return VolumeBracket.overamp;
  } else if (volume > 70) {
    return VolumeBracket.high;
  } else if (volume > 40) {
    return VolumeBracket.med;
  } else if (volume > 01) {
    return VolumeBracket.low;
  } else {
    return VolumeBracket.mute;
  }
}

class PlaybackControls extends StatefulWidget {
  const PlaybackControls({super.key});

  @override
  State<StatefulWidget> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
  var showVolumeOptions = false;
  var showRateOptions = false;
  var showTimerOptions = false;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: showVolumeOptions || showRateOptions || showTimerOptions,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            showVolumeOptions = false;
            showRateOptions = false;
            showTimerOptions = false;
          });
        },
      ),
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
                spacing: 8.0,
                children: [
                  PortalTarget(
                    visible: showVolumeOptions,
                    anchor: const Aligned(
                      follower: Alignment.bottomCenter,
                      target: Alignment.topCenter,
                      offset: Offset(0, -8),
                    ),
                    portalFollower: VolumeSlider(),

                    child: Tooltip(
                      message: "Volume",
                      child: YaruOptionButton(
                        onPressed: () {
                          setState(() {
                            showVolumeOptions = true;
                          });
                        },
                        child: VolumeIcon(),
                      ),
                    ),
                  ),
                  PortalTarget(
                    visible: showRateOptions,
                    anchor: const Aligned(
                      follower: Alignment.bottomLeft,
                      target: Alignment.topLeft,
                      offset: Offset(0, -8),
                    ),
                    portalFollower: RateOptions(),

                    child: Tooltip(
                      message: "playback speed",
                      child: SizedBox(
                        width: 64,
                        child: YaruOptionButton(
                          onPressed: () {
                            setState(() {
                              showRateOptions = true;
                            });
                          },
                          child: StreamBuilder(
                            stream: globals.player.stream.rate,
                            builder: (context, asyncSnapshot) {
                              double rate = globals.player.state.rate;
                              if (asyncSnapshot.hasData) {
                                rate = asyncSnapshot.data!;
                              }

                              var label = rate.toStringAsFixed(2);

                              return Text("${label}x", softWrap: false);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              TrackControls(),
              Row(
                children: [
                  SizedBox(width: 64),

                  PortalTarget(
                    visible: showTimerOptions,
                    anchor: const Aligned(
                      follower: Alignment.bottomRight,
                      target: Alignment.topRight,
                      offset: Offset(0, -8),
                    ),
                    portalFollower: TimerOptions(),

                    child: Tooltip(
                      message: "timer",
                      child: StreamBuilder(
                        stream: AutoPauseTimer.autoPauseRunnningStream,
                        builder: (context, asyncSnapshot) {
                          var runnning =
                              asyncSnapshot.hasData && asyncSnapshot.data!;
                          return YaruOptionButton(
                            style: runnning
                                ? ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                          YaruColors.adwaitaYellow,
                                        ),
                                    iconColor: WidgetStatePropertyAll<Color>(
                                      Colors.black,
                                    ),
                                  )
                                : ButtonStyle(),
                            onPressed: () {
                              setState(() {
                                showTimerOptions = true;
                              });
                            },
                            child: Icon(YaruIcons.stopwatch),
                          );
                        },
                      ),
                    ),
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

class TrackControls extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,

      children: [
        SizedBox(
          width: 60, // Custom width
          height: 60, // Custom height
          child: IconButton(
            tooltip: "skip to last chapter",

            padding: EdgeInsets.all(12), // Adjust padding to center the icon
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
            tooltip: "skip back",
            padding: EdgeInsets.all(12), // Adjust padding to center the icon
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
                  tooltip: asyncSnapshot.data! ? "pause" : "play",

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
            tooltip: "skip forwards",

            padding: EdgeInsets.all(12), // Adjust padding to center the icon
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
            tooltip: "skip to next chapter",

            padding: EdgeInsets.all(12), // Adjust padding to center the icon
            icon: Icon(
              YaruIcons.skip_forward,
              size: 30,
            ), // Larger icon to fill the space
            onPressed: globals.seekNextChapter,
          ),
        ),
      ],
    );
  }
}

class VolumeIcon extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globals.player.stream.volume,
      builder: (context, asyncSnapshot) {
        var icon = YaruIcons.speaker;
        if (asyncSnapshot.hasData) {
          final volumeBracket = fromVolume(asyncSnapshot.data!);
          switch (volumeBracket) {
            case (VolumeBracket.overamp):
              icon = YaruIcons.speaker_overamplified;
            case (VolumeBracket.high):
              icon = YaruIcons.speaker_high;
            case (VolumeBracket.med):
              icon = YaruIcons.speaker_medium;
            case (VolumeBracket.low):
              icon = YaruIcons.speaker_low;
            case (VolumeBracket.mute):
              icon = YaruIcons.speaker_muted;
          }
        }
        return Icon(icon);
      },
    );
  }
}

var popoverBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(17),
    topRight: Radius.circular(17),
    bottomLeft: Radius.circular(17),
    bottomRight: Radius.circular(17),
  ),
  color: YaruColors.inkstone,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      spreadRadius: 1,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],
);

class VolumeSlider extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 34,
      child: Container(
        decoration: popoverBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(YaruIcons.speaker),
              Flexible(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: StreamBuilder(
                    stream: globals.player.stream.volume,
                    builder: (context, asyncSnapshot) {
                      var volume = 1.0;
                      if (asyncSnapshot.hasData) {
                        volume = asyncSnapshot.data!;
                      } else {
                        volume = globals.player.state.volume;
                      }
                      return Slider(
                        value: volume,
                        min: 0,
                        max: 100.0,
                        onChanged: (value) {
                          globals.player.setVolume(value);
                        },
                      );
                    },
                  ),
                ),
              ),
              Icon(YaruIcons.speaker_muted),
            ],
          ),
        ),
      ),
    );
  }
}

class RateOptions extends StatelessWidget {
  const new({super.key});

  final List<double> speeds = const <double>[
    2,
    1.75,
    1.5,
    1.25,
    1.2,
    1.1,
    1,
    .9,
    0.75,
    0.5,
  ];
  final List<String> speedLabels = const <String>[
    "2x",
    "1.75x",
    "1.5x",
    "1.25x",
    "1.2x",
    "1.1x",
    "1x",
    "0.9x",
    "0.75x",
    "0.5x",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: popoverBoxDecoration,
      width: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: StreamBuilder(
          stream: globals.player.stream.rate,
          builder: (context, asyncSnapshot) {
            var currentRate = 1.0;
            if (asyncSnapshot.hasData) {
              currentRate = asyncSnapshot.data!;
            } else {
              currentRate = globals.player.state.rate;
            }

            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: speedLabels.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (currentRate == speeds[index]) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16,
                    ),
                    child: Text(
                      speedLabels[index],
                      textAlign: .start,
                      style: TextStyle(fontWeight: .bold),
                    ),
                  );
                } else {
                  return TextButton(
                    onPressed: () {
                      print("select rate: ${speeds[index]}");
                      globals.player.setRate(speeds[index]);
                    },
                    child: Align(
                      alignment: .centerStart,
                      child: Text(speedLabels[index], textAlign: .start),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
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

    player.seek(micros + Duration(milliseconds: 1));
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
                            onTap: () {
                              widget._seekChapter(widget.chapters[index]);
                              Navigator.pop(context);
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
