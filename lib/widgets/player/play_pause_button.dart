import 'package:story_time/l10n/app_localizations.dart';
import 'package:story_time/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class PlayPauseButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80, // Custom width
      height: 80, // Custom height
      child: StreamBuilder(
        stream: PlayerService().isPlayingStream,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            return IconButton(
              tooltip: asyncSnapshot.data! ? AppLocalizations.of(context)!.tooltipTransportPause : AppLocalizations.of(context)!.tooltipTransportPlay,

              padding: EdgeInsets.all(12), // Adjust padding to center the icon
              icon: Icon(
                asyncSnapshot.data!
                    ? YaruIcons.media_pause
                    : YaruIcons.media_play,
                size: 48,
              ), // Larger icon to fill the space
              onPressed: PlayerService().playOrPause,
            );
          }
          return IconButton(
            padding: EdgeInsets.all(12), // Adjust padding to center the icon
            icon: Icon(
              PlayerService().isPlaying
                  ? YaruIcons.media_pause
                  : YaruIcons.media_play,
              size: 48,
            ), // Larger icon to fill the space
            onPressed: PlayerService().playOrPause,
          );
        },
      ),
    );
  }
}
