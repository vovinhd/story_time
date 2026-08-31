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

  void setShowRateOptions() {
    setState(() {
      showRateOptions = true;
    });
  }

  void setShowVolumeOptions() {
    setState(() {
      showVolumeOptions = true;
    });
  }

  void setshowTimerOptions() {
    setState(() {
      showTimerOptions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                  PositonLabel(position: position),
                  PositionEndLabel(position: position),
                ],
              );
            },
          ),
          if (size.width < 556)
            Column(
              children: [
                Row(mainAxisAlignment: .center, children: [TrackControls()]),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    _LeftOptions(
                      showVolumeOptions: showVolumeOptions,
                      showRateOptions: showRateOptions,
                      setShowVolumeOptions: setShowVolumeOptions,
                      setShowRateOptions: setShowRateOptions,
                    ),
                    _RightOptions(
                      showTimerOptions: showTimerOptions,
                      setshowTimerOptions: setshowTimerOptions,
                    ),
                  ],
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: .spaceBetween,

              children: [
                _LeftOptions(
                  showVolumeOptions: showVolumeOptions,
                  showRateOptions: showRateOptions,
                  setShowVolumeOptions: setShowVolumeOptions,
                  setShowRateOptions: setShowRateOptions,
                ),

                TrackControls(),
                _RightOptions(
                  showTimerOptions: showTimerOptions,
                  setshowTimerOptions: setshowTimerOptions,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _RightOptions extends StatelessWidget {
  const new({
    super.key,
    required this.showTimerOptions,
    required this.setshowTimerOptions,
  });

  final bool showTimerOptions;
  final VoidCallback setshowTimerOptions;

  @override
  Widget build(BuildContext context) {
    return Row(
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

          child: TimerButton(onPressed: setshowTimerOptions),
        ),
      ],
    );
  }
}

class _LeftOptions extends StatelessWidget {
  const new({
    super.key,
    required this.showVolumeOptions,
    required this.showRateOptions,
    required this.setShowVolumeOptions,
    required this.setShowRateOptions,
  });

  final bool showVolumeOptions;
  final bool showRateOptions;

  final VoidCallback setShowVolumeOptions;
  final VoidCallback setShowRateOptions;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              onPressed: setShowVolumeOptions,
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
                onPressed: setShowRateOptions,
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

ButtonStyle overlayTextButtonStyle = .new(
  foregroundColor: WidgetStatePropertyAll(Colors.white),
  overlayColor: WidgetStatePropertyAll(const Color.fromARGB(12, 255, 255, 255)),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: .circular(0)),
  ),
);
