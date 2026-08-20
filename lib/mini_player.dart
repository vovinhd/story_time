import 'package:fl_audiobook/playback_position_slider.dart';
import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import "globals.dart" as globals;

class MiniPlayer extends StatefulWidget {
  const new({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder(
          stream: globals.player.stream.playing,
          builder: (context, snapshotPlayPause) {
            return StreamBuilder(
              stream: globals.player.stream.position,
              builder: (context, snapshotPosition) {
                if (snapshotPosition.hasData) {
                  var currentChapter = globals.getChapterFor(
                    snapshotPosition.data!,
                  );

                  // Display the received data
                  return Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 16.0),
                      color: const Color.fromARGB(255, 76, 76, 76),
                      child: Row(
                        spacing: 8.0,

                        crossAxisAlignment: .center,
                        mainAxisAlignment: .start,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: globals.coverImage,
                          ),
                          IconButton(
                            onPressed: globals.player.playOrPause,
                            icon: snapshotPlayPause.data!
                                ? Icon(YaruIcons.media_pause)
                                : Icon(YaruIcons.media_play),
                          ),
                          CurrentPositionInChapterLabel(),
                          Expanded(
                            child: PlaybackPositionSlider(),
                          ),
                          EndLabel(),
                          IconButton(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            onPressed: () => {
                              if (mounted)
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (context) => PlayerPage(
                                        player: globals.player,
                                        chapters: globals.chapters!,
                                        tags: globals.tags!,
                                        cover: globals.coverImage,
                                      ),
                                    ),
                                  ),
                                },
                            },
                            icon: Icon(Icons.keyboard_arrow_right),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // This case might occur if the stream closes without sending data
                  // or initialData wasn't provided and no data has arrived yet.
                  return const SizedBox.shrink();
                }
              },
            );
          },
        ),
      ],
    );
  }
}
