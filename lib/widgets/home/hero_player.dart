import 'dart:ui';

import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/widgets/player/playback_position_slider.dart';
import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:marquee/marquee.dart';
import 'package:yaru/yaru.dart';

class HeroPlayer extends StatefulWidget {
  const new({super.key, required this.file});
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
              StreamBuilder(
                stream: ConfigProvider().configStreamController.stream,
                builder: (context, asyncSnapshot) {
                  var performanceMode = ConfigProvider().config.performanceMode;
                  if (asyncSnapshot.hasData) {
                    performanceMode = asyncSnapshot.data!.performanceMode;
                  }

                  return SizedBox(
                    height: 235,
                    child: Stack(
                      children: [
                        if (performanceMode)
                          SizedBox()
                        else
                          Positioned.fill(
                            child: Image(
                              fit: .fill,
                              image: PlayerService().coverImage.image,
                              height: double.infinity,
                              width: double.infinity,
                              repeat: .noRepeat,
                            ).animate(key: Key(widget.file.name)).fade(),
                          ),
                        if (performanceMode)
                          SizedBox()
                        else
                          Positioned.fill(
                            child: Opacity(
                              opacity: .4,
                              child: Container(color: Color(0xFF000000)),
                            ),
                          ),
                        if (performanceMode)
                          HeroPlayerMain(widget: widget)
                        else
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),

                            child: (HeroPlayerMain(widget: widget)),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroPlayerMain extends StatelessWidget {
  const new({super.key, required this.widget});

  final HeroPlayer widget;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                // spacing: 16,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: .start,

                      children: [
                        Text("Now Playing", style: TextStyle(fontSize: 10)),
                        if (PlayerService().title.length > 20) 
                        ConstrainedBox(constraints: BoxConstraints( maxHeight: 60), child: _TitleMarquee()) else _TitleLabel(),
                        Text(
                          PlayerService().tags["artist"],
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  _PlayStatus(),
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
    );
  }
}

class _PlayStatus extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      
      children: [
        IconButton(
          onPressed: PlayerService().playOrPause,
          icon: StreamBuilder(
            stream: PlayerService().isPlayingStream,
            builder: (context, asyncSnapshot) {
              var playing = PlayerService().isPlaying;
              if (asyncSnapshot.hasData) {
                playing = asyncSnapshot.data!;
              }
              return Icon(
                playing
                    ? YaruIcons.media_pause
                    : YaruIcons.media_play,
              );
            },
          ),
        ),
        Expanded(child: LinearProgressIndicator(value: PlayerService().position.inMicroseconds / PlayerService().duration.inMicroseconds,)),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CurrentPositionLabel(),
        ),
      ],
    );
  }
}

class _TitleLabel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      PlayerService().tags["title"],
      style: TextStyle(fontSize: 32, overflow: .fade),
      softWrap: true,
    );
  }
}

class _TitleMarquee extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Marquee(
      text: PlayerService().tags["title"],
      style: TextStyle(fontSize: 32, overflow: .fade),
      pauseAfterRound: Duration(seconds: 5),
            showFadingOnlyWhenScrolling: false,
      // fadingEdgeStartFraction: 0.1,
      fadingEdgeEndFraction: 0.1,
      // startPadding: 20,
      blankSpace: 20,
      // numberOfRounds:1
    );
  }
}
