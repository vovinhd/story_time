import 'package:fl_audiobook/globals.dart' as globals;
import 'package:flutter/material.dart';

// Source - https://stackoverflow.com/a/54775297
// Posted by diegoveloper, modified by community. See post 'Timeline' for change history
// Retrieved 2026-08-19, License - CC BY-SA 4.0

String printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  if (duration.inMinutes < 60) {
      return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";

  } 
  return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

// todo marked for refactor!
Duration timeInChapter(Duration position) {
  var currentChapter = globals.playerService.getChapterFor(position)!;
  final int chapterStartTime = currentChapter.start.inMicroseconds;
  return Duration(microseconds: (position.inMicroseconds - chapterStartTime));
}


Duration timeLeftInChapter(Duration position) {
  var currentChapter = globals.playerService.getChapterFor(position)!;
  final int chapterEndTime = currentChapter.end.inMicroseconds; 
  return Duration(microseconds: (position.inMicroseconds - chapterEndTime));
}


class CurrentPositionLabel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row (children: [StreamBuilder(
      stream: globals.playerService.positionStream,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return Text(printDuration(asyncSnapshot.data!)); 
        }
        
        return Text(printDuration(globals.playerService.position));
      }
    ),Text("/"), StreamBuilder(
      stream: globals.playerService.durationStream,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return Text(printDuration(asyncSnapshot.data!)); 
        }
        return Text(printDuration(globals.playerService.duration));
      }
    )]);
  }
}

class CurrentPositionInChapterLabel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globals.playerService.positionStream,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return Text(printDuration(timeInChapter(asyncSnapshot.data!))); 
        }
        return Text(printDuration(timeInChapter(globals.playerService.position)));
      }
    );
  }
}



class EndLabel extends StatelessWidget {
  const new({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globals.playerService.positionStream,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return Text(printDuration(timeLeftInChapter(asyncSnapshot.data!))); 
        }
        return Text(printDuration(timeLeftInChapter(globals.playerService.position)));
      }
    );
  }}