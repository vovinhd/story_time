import 'dart:ui';

import 'package:fl_audiobook/widgets/player/playback_position_slider.dart';
import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yaru/yaru.dart';

class HeroPlayer extends StatefulWidget {
  const new({
    super.key, required this.file,
  });
  final BookFile file; 
  @override
  State<HeroPlayer> createState() => _HeroPlayerState();
}

class _HeroPlayerState extends State<HeroPlayer> {
  void _pushPlayerRoute() {
    if (mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (context) => PlayerPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pushPlayerRoute();
      },
      child: Material(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            // vertical: 32.0,
            // horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Text("Now Playing", textAlign: .start),
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child:
                          Image(
                                fit: .fill,
                                image: PlayerService()
                                    .coverImage
                                    .image,
                                height: double.infinity,
                                width: double.infinity,
                                repeat: .noRepeat,
                              )
                              .animate(
                                key: Key(widget.file.name),
                              )
                              .fade(),
                    ),
                    Positioned.fill(
                      child: Opacity(
                        opacity: .4,
                        child: Container(color: Color(0xFF000000)),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 100,
                        sigmaY: 100,
                      ),
    
                      child: (Container(
                        padding: EdgeInsets.all(32),
    
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: Colors.white,
                          //   width: .1,
                          //   strokeAlign: BorderSide.strokeAlignInside,
                          // ),
                          // borderRadius: BorderRadius.circular(32),
                        ),
    
                        child: Row(
                          children: [
                            Hero(
                              tag: widget.file.name.hashCode,
                              child: PlayerService().coverImage,
                            ),
    
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  mainAxisAlignment: .spaceBetween,
                                  // spacing: 16,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                      child: Column(
                                        crossAxisAlignment: .start,
    
                                        children: [
                                          Text(
                                            "Now Playing",
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            PlayerService()
                                                .tags["title"],
                                            style: TextStyle(
                                              fontSize: 32,
                                            ),
                                          ),
                                          Text(
                                            PlayerService()
                                                .tags["artist"],
                                            style: TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: PlayerService()
                                              .playOrPause,
                                          icon: StreamBuilder(
                                            stream: PlayerService()
                                                .isPlayingStream,
                                            builder:
                                                (
                                                  context,
                                                  asyncSnapshot,
                                                ) {
                                                  var playing = PlayerService()
                                                      .isPlaying;
                                                  if (asyncSnapshot
                                                      .hasData) {
                                                    playing =
                                                        asyncSnapshot
                                                            .data!;
                                                  }
                                                  return Icon(
                                                    playing
                                                        ? YaruIcons
                                                              .media_pause
                                                        : YaruIcons
                                                              .media_play,
                                                  );
                                                },
                                          ),
                                        ),
                                        CurrentPositionInChapterLabel(),
                                        Expanded(
                                          child:
                                              PlaybackPositionSlider(),
                                        ),
                                        EndLabel(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   width: 60, // Custom width
                            //   height: 60, // Custom height
    
                            //   child: Icon(
                            //     Icons.keyboard_arrow_right,
                            //     size: 30,
                            //   ),
                            // ),
                          ],
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
