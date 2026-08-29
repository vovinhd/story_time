import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/widgets/player/play_pause_button.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

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
            onPressed: PlayerService().seekLastChapter,
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
            onPressed: PlayerService().seekBack,
          ),
        ),

        PlayPauseButton(),
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
            onPressed: PlayerService().seekForward,
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
            onPressed: PlayerService().seekNextChapter,
          ),
        ),
      ],
    );
  }
}
