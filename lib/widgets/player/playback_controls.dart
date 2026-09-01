import 'dart:async';

import 'package:fl_audiobook/auto_pause_timer.dart';
import 'package:fl_audiobook/l10n/app_localizations.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:fl_audiobook/widgets/animated_popover.dart';
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
  var showRateOptions = false;
  var showTimerOptions = false;

  void setShowRateOptions() {
    setState(() {
      showRateOptions = true;
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
      visible: showRateOptions || showTimerOptions,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
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
                    _LeftOptions(),
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
                _LeftOptions(),

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


        StreamBuilder(
          stream: AutoPauseTimer.autoPauseRunnningStream,
          builder: (context, asyncSnapshot) {
            var running = asyncSnapshot.hasData && asyncSnapshot.data!;

            return AnimatedPopover(
              offset: Offset(0, -8),
              follower: Alignment.bottomRight,
              target: Alignment.topRight,
              tooltip: AppLocalizations.of(context)!.tooltipTimer,
              icon: Icon(YaruIcons.stopwatch),
              buttonStyleOverride: running ? ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      YaruColors.adwaitaYellow,
                    ),
                    iconColor: WidgetStatePropertyAll<Color>(Colors.black),
                  ) : ButtonStyle(),
              child: TimerOptions(),
            );
          }
        ),
      ],
    );
  }
}

class _LeftOptions extends StatelessWidget {
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        AnimatedPopover(
          offset: Offset(0, -8),
          follower: Alignment.bottomCenter,
          target: Alignment.topCenter,
          tooltip: AppLocalizations.of(context)!.tooltipVolume,
          icon: VolumeIcon(),
          child: VolumeSlider(),
        ),

        AnimatedPopover(
          offset: Offset(0, -8),
          follower: Alignment.bottomLeft,
          target: Alignment.topLeft,
          tooltip: AppLocalizations.of(context)!.tooltipSpeed,
          icon: SizedBox(
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
          width: 64,
          child: RateOptions(),
        ),
      ],
    );
  }
}


ButtonStyle overlayTextButtonStyle(BuildContext context) {
    return Theme.of(context).brightness == .dark
      ? overlayTextButtonStyleDark
      : overlayTextButtonStyleLight;
}

ButtonStyle overlayTextButtonStyleLight = .new(
  foregroundColor: WidgetStatePropertyAll(YaruColors.textGrey),
  overlayColor: WidgetStatePropertyAll(const Color.fromARGB(12, 255, 255, 255)),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: .circular(0)),
  ),
);



ButtonStyle overlayTextButtonStyleDark = .new(
  foregroundColor: WidgetStatePropertyAll(YaruColors.porcelain),
  overlayColor: WidgetStatePropertyAll(const Color.fromARGB(12, 255, 255, 255)),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: .circular(0)),
  ),
);
