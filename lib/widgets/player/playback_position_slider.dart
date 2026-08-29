import 'package:fl_audiobook/services/player_service.dart';
import 'package:flutter/material.dart';

class PlaybackPositionSlider extends StatefulWidget {
  const new({super.key});

  @override
  State<PlaybackPositionSlider> createState() => _PlaybackPositionSliderState();
}

class _PlaybackPositionSliderState extends State<PlaybackPositionSlider> {
  double lastPos = 0.0;

  void _seekPlayhead(double value) {
    lastPos = value;
    var currentChapter = PlayerService().currentChapter;
    final double chapterStartTime = currentChapter!.start.inMicroseconds
        .toDouble();
    final double chapterEndTime = currentChapter.end.inMicroseconds.toDouble();

    final micros = Duration(
      microseconds:
          ((chapterEndTime - chapterStartTime) * value + chapterStartTime)
              .round(),
    );
    PlayerService().seek(micros);
  }

  double _getPlayheadPosition(Duration duration) {
    if (!PlayerService().isPlaying) {
      return lastPos;
    }
    var currentChapter = PlayerService().currentChapter!;

    final double chapterStartTime = currentChapter.start.inMicroseconds
        .toDouble();
    final double chapterEndTime = currentChapter.end.inMicroseconds.toDouble();
    final double positionMicros = duration.inMicroseconds.toDouble();

    final res =
        (positionMicros - chapterStartTime) /
        (chapterEndTime - chapterStartTime);
    if (res >= 0.0 || res <= 1.0) {
      lastPos = res;
      return res;
    } else {
      return lastPos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PlayerService().seekStream.stream,
      builder: (context, asyncSnapshot) {

        var position = PlayerService().position; 
        if (asyncSnapshot.hasData) {
          position = asyncSnapshot.data!; 
        }

        return StreamBuilder(
          stream: PlayerService().positionStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Slider(
                value: _getPlayheadPosition(snapshot.data!),
                min: 0,
                max: 1.0,
                onChanged: (value) => _seekPlayhead(value),
              );
            } else {
              return Slider(
                value: _getPlayheadPosition(position),
                min: 0,
                max: 1.0,
                onChanged: (value) => _seekPlayhead(value),
              );
            }
          },
        );
      }
    );
  }
}
