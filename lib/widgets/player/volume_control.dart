import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class VolumeIcon extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PlayerService().volumeStream,
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

class VolumeSlider extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 34,
      child: Container(
        decoration: popoverBoxDecoration(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(YaruIcons.speaker),
              Flexible(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: StreamBuilder(
                    stream: PlayerService().volumeStream,
                    builder: (context, asyncSnapshot) {
                      var volume = 1.0;
                      if (asyncSnapshot.hasData) {
                        volume = asyncSnapshot.data!;
                      } else {
                        volume = PlayerService().volume;
                      }
                      return Slider(
                        value: volume,
                        min: 0,
                        max: 100.0,
                        onChanged: (value) {
                          PlayerService().volume = value;
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
