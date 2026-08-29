import 'dart:ui';

import 'package:fl_audiobook/auto_pause_timer.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:fl_audiobook/tray.dart' as tray;
import 'package:fl_audiobook/widgets/cover_image.dart';
import 'package:fl_audiobook/widgets/player/chapter_list_button.dart';
import 'package:fl_audiobook/widgets/player/playback_controls.dart';
import 'package:fl_audiobook/widgets/player/tag_info.dart';
import 'package:fl_audiobook/widgets/player/unskip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:yaru/yaru.dart';

// Source - https://stackoverflow.com/a/54775297
// Posted by diegoveloper, modified by community. See post 'Timeline' for change history
// Retrieved 2026-08-19, License - CC BY-SA 4.0

// Create a key

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
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool showBookInfo = false;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.space): () {
          PlayerService().playOrPause();
        },
      },
      child: Scaffold(
        appBar: YaruWindowTitleBar(
          heroTag: "appbar",

          onClose: (p0) {
            tray.hideOrClose();
          },
          backgroundColor: Colors.transparent,
          onShowMenu: (p0) => {},
          border: BorderSide.none,
          leading: YaruBackButton(),
          title: Text("Player"),
          actions: [
            PortalTarget(
              visible: showBookInfo,
              anchor: const Aligned(
                follower: Alignment.topRight,
                target: Alignment.bottomRight,
                offset: Offset(0, 8),
              ),
              portalFollower: TagInfo(),

              child: Tooltip(
                message: "playback speed",
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      showBookInfo = true;
                    });
                  },
                  icon: Icon(YaruIcons.information),
                ),
              ),
            ),
          ],
        ),

        body: Focus(
          autofocus: true,
          child: PortalTarget(
            visible: showBookInfo,
            portalFollower: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  showBookInfo = false;
                });
              },
            ),

            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Image(
                    fit: .fill,
                    image: PlayerService().coverImage.image,
                    height: double.infinity,
                    width: double.infinity,
                    repeat: .noRepeat,
                  ),
                ),

                Positioned.fill(
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(color: const Color(0xFF000000)),
                  ),
                ),

                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(
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
                                child: Hero(
                                  tag:
                                      PlayerService()
                                          .playingFile
                                          ?.name
                                          .hashCode ??
                                      "",
                                  child: CoverImage(),
                                ),
                              ),

                              StreamBuilder(
                                stream: AutoPauseTimer.autoPauseRunnningStream,
                                builder: (context, asyncSnapshot) {
                                  bool show = false;
                                  if (asyncSnapshot.hasData &&
                                      asyncSnapshot.data!) {
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
                                          borderRadius: BorderRadius.circular(
                                            1000,
                                          ),
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
                                              stream: AutoPauseTimer
                                                  .remainingStream,
                                              builder:
                                                  (context, asyncSnapshot) {
                                                    if (!asyncSnapshot
                                                        .hasData) {
                                                      return Text(
                                                        ":00",
                                                        style: TextStyle(
                                                          fontWeight: .bold,
                                                          fontSize: 20,
                                                        ),
                                                      );
                                                    }
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
                                child: UnskipButton(),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          spacing: 8.0,
                          crossAxisAlignment: .start,
                          children: [
                            ChapterListButton(
                            ),

                            PlaybackControls(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
