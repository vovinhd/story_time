import 'package:story_time/services/player_service.dart';
import 'package:flutter/material.dart';

// Source - https://stackoverflow.com/a/54775297
// Posted by diegoveloper, modified by community. See post 'Timeline' for change history
// Retrieved 2026-08-19, License - CC BY-SA 4.0

String printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  String twoDigitHours = twoDigits(duration.inHours);
  if (duration.inMinutes.abs() < 60) {
    return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
  }
  return "$negativeSign$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
}

// // todo marked for refactor!
// Duration timeInChapter(Duration position) {
//   var currentChapter = PlayerService().getChapterFor(position)!;
//   final int chapterStartTime = currentChapter.start.inMicroseconds;
//   return Duration(microseconds: (position.inMicroseconds - chapterStartTime));
// }

// Duration timeLeftInChapter(Duration position) {
//   var currentChapter = PlayerService().getChapterFor(position)!;
//   final int chapterEndTime = currentChapter.end.inMicroseconds;
//   return Duration(microseconds: (position.inMicroseconds - chapterEndTime));
// }

class CurrentPositionLabel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder(
          stream: PlayerService().positionStream,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              return Text(printDuration(asyncSnapshot.data!));
            }

            return Text(printDuration(PlayerService().position));
          },
        ),
        Text("/"),
        StreamBuilder(
          stream: PlayerService().durationStream,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              return Text(printDuration(asyncSnapshot.data!));
            }
            return Text(printDuration(PlayerService().duration));
          },
        ),
      ],
    );
  }
}

class PositonLabel extends StatelessWidget {
  const new({super.key, required this.position});
  final Duration position;

  @override
  Widget build(BuildContext context) {
    // print("PositonLabel: ${position.inMilliseconds} ${printDuration(position)}");

    return Row(
      children: [
        Text(printDuration(position)),
        Text("/"),
        Text(printDuration(PlayerService().duration)),
      ],
    );
  }
}

class CurrentPositionInChapterLabel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PlayerService().positionStream,
      builder: (context, asyncSnapshot) {
        return Text(printDuration(PlayerService().timeInChapter));
      },
    );
  }
}

class PositionInChapterLabel extends StatelessWidget {
  const new({super.key, required this.position});
  final Duration position;

  @override
  Widget build(BuildContext context) {
    // print("PositionInChapterLabel: ${position.inMilliseconds} ${printDuration(position)}");
    return Text(
      printDuration(PlayerService().timeInChapterForPosition(position)),
    );
  }
}

class PositionEndLabel extends StatelessWidget {
  const new({super.key, required this.position});
  final Duration position;

  @override
  Widget build(BuildContext context) {

    var ch = PlayerService().getChapterFor(position); 
    var timeleft = ch == null ? PlayerService().duration - position : (ch.end - position); 
    // print("PositionEndLabel: ${position.inMilliseconds} ${printDuration(timeleft)}");

    return Text(printDuration(-timeleft));
  }
}

class EndLabel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PlayerService().positionStream,
      builder: (context, asyncSnapshot) {
        return Text(printDuration(-PlayerService().timeLeftInChapter));
      },
    );
  }
}

class DurationLabel extends StatelessWidget { 
  const new({super.key, required this.duration, this.style});

  final Duration duration;
  final TextStyle? style; 
  @override
  Widget build(BuildContext context) {
    return Text(printDuration(duration), style: style,); 
  } 



}
