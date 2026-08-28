import 'package:fl_audiobook/globals.dart' as globals;
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
    var currentChapter = globals.playerService.currentChapter;
    final double chapterStartTime = 
        currentChapter!.start.inMicroseconds
        .toDouble();
    final double chapterEndTime = 
        currentChapter.end.inMicroseconds
        .toDouble();

    final micros = Duration(
      microseconds:
          ((chapterEndTime - chapterStartTime) * value + chapterStartTime)
              .round(),
    );
    globals.playerService.seek(micros);
  }

  double _getPlayheadPosition(Duration duration) {
    if (!globals.playerService.isPlaying) {
      return lastPos;
    }
    var currentChapter = globals.playerService.currentChapter!;

    final double chapterStartTime = currentChapter.start.inMicroseconds
        .toDouble();
    final double chapterEndTime = currentChapter.end.inMicroseconds
        .toDouble();
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
      stream: globals.playerService.positionStream,
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
            value: _getPlayheadPosition(globals.playerService.position),
            min: 0,
            max: 1.0,
            onChanged: (value) => _seekPlayhead(value),
          );

        }
      },
    );
  }
}
