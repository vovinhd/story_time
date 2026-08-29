import 'package:fl_audiobook/auto_pause_timer.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:fl_audiobook/widgets/player/playback_position_slider.dart';
import 'package:fl_audiobook/widgets/player/rate_control.dart';
import 'package:fl_audiobook/widgets/player/track_controls.dart';
import 'package:fl_audiobook/widgets/player/volume_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:yaru/yaru.dart';

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
          StreamBuilder(
            stream: PlayerService().syncedPositionStream,
            builder: (context, asyncSnapshot) {
              var position = PlayerService().position; 
              if (asyncSnapshot.hasData) { 
                position = asyncSnapshot.data!;
              }
              return Row(
                spacing: 8,
                mainAxisAlignment: .spaceBetween,
                children: [
                  PositionInChapterLabel(position: position),
                  PositonLabel(position: position,),
                  PositionEndLabel(position: position,),
                ],
              );
            }
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
                            stream: PlayerService().rateStream,
                            builder: (context, asyncSnapshot) {
                              double rate = PlayerService().rate;
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

                    child: TimerButton(
                      onPressed: () {
                        setState(() {
                          showTimerOptions = true;
                        });
                      },
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

class TimerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const new({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "timer",
      child: StreamBuilder(
        stream: AutoPauseTimer.autoPauseRunnningStream,
        builder: (context, asyncSnapshot) {
          var runnning = asyncSnapshot.hasData && asyncSnapshot.data!;
          return YaruOptionButton(
            style: runnning
                ? ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      YaruColors.adwaitaYellow,
                    ),
                    iconColor: WidgetStatePropertyAll<Color>(Colors.black),
                  )
                : ButtonStyle(),
            onPressed: onPressed,
            child: Icon(YaruIcons.stopwatch),
          );
        },
      ),
    );
  }
}
