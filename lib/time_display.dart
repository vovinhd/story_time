import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/player_page.dart';
import 'package:flutter/material.dart';

// Source - https://stackoverflow.com/a/54775297
// Posted by diegoveloper, modified by community. See post 'Timeline' for change history
// Retrieved 2026-08-19, License - CC BY-SA 4.0

String printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

Duration timeInChapter(Duration position) {
  var currentChapter = globals.getChapterFor(position);
  final int chapterStartTime = globals.chapterInfoTimeToMicros(
    currentChapter.startTime!,
  );
  return Duration(microseconds: (position.inMicroseconds - chapterStartTime));
}

class CurrentPositionLabel extends StatelessWidget {
  const new({super.key, required this.postion});
  final Duration postion;

  @override
  Widget build(BuildContext context) {
    return Text(printDuration(postion));
  }
}

class CurrentPositionInChapterLabel extends StatelessWidget {
  const new({super.key, required this.postion});
  final Duration postion;
  @override
  Widget build(BuildContext context) {
    return Text(printDuration(timeInChapter(postion)));
  }
}

class CurrentPositionLabelStack extends StatefulWidget {
  const new({super.key});

  @override
  State<CurrentPositionLabelStack> createState() =>
      CurrentPositionLabelStackState();
}

class CurrentPositionLabelStackState extends State<CurrentPositionLabelStack> {
  bool positionInChapter = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globals.player.stream.position,
      builder: (context, asyncSnapshot) {
        Duration pos;
        if (asyncSnapshot.hasData) {
          pos = asyncSnapshot.data!;
        } else {
          pos = globals.player.state.position;
        }
        return TextButton(
          onPressed: () {
            positionInChapter = !positionInChapter;
            setState(() {});
          },
          child: positionInChapter
              ? CurrentPositionInChapterLabel(postion: pos)
              : CurrentPositionLabel(postion: pos),
        );
      },
    );
  }
}

class ChapterStartLabel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globals.player.stream.position,
      builder: (context, asyncSnapshot) {
        Duration pos;
        if (asyncSnapshot.hasData) {
          pos = asyncSnapshot.data!;
        } else {
          pos = globals.player.state.position;
        }

        ChapterInformation chapter = globals.getChapterFor(pos);

        return Text(printDuration(Duration(microseconds: chapterInfoTimeToMicros(chapter.startTime!))));
      },
    );
  }
}





class EndLabelStack extends StatefulWidget {
  const new({super.key});

  @override
  State<EndLabelStack> createState() =>
      EndLabelStackState();
}

class EndLabelStackState extends State<EndLabelStack> {
  int mode = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globals.player.stream.position,
      builder: (context, asyncSnapshot) {
        Duration pos;
        ChapterInformation ch; 
        if (asyncSnapshot.hasData) {
          pos = asyncSnapshot.data!;
        } else {
          pos = globals.player.state.position;
        }
        ch = globals.getChapterFor(pos); 

        return TextButton(
          onPressed: () {
            mode = mode % 2;
            setState(() {});
          },
          child: EndLabel(mode: mode, chapter: ch),
        );
      },
    );
  }
}

class EndLabel extends StatelessWidget {
  const new({super.key, required this.mode, required this.chapter});
  final int mode; 
  final ChapterInformation chapter; 
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}