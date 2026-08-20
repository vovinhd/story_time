import 'dart:math';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

final player = Player();
Image coverImage = (Image.asset("images/cover_default.png", key: UniqueKey()));
bool ready = false;
Map<String, dynamic>? tags;

List<ChapterInformation>? chapters;

int chapterInfoTimeToMicros(String timestamp) {
  try {
    return (double.parse(timestamp) * 1_000_000).round();

  } catch (error) {
    return 0; 
  }

}

ChapterInformation getCurrentChapter() {
  return getChapterFor(player.state.position); 
}

ChapterInformation getChapterFor(Duration position) {
  var nullChapterInfo = ChapterInformation(
    id: -1,
    startTime: "00:00:00",
    endTime: player.state.duration.toString(),
    tagsJson: "{\"title\": \"title\" }",
  );
  if (chapters == null) {
    return nullChapterInfo;
  }
  for (var chapter in chapters!) {
    final chapterStartTime = chapterInfoTimeToMicros(chapter.startTime!);
    final chapterEndTime = chapterInfoTimeToMicros(chapter.endTime!);
    final positionMicros = position.inMicroseconds;
    if (chapterStartTime < positionMicros && positionMicros <= chapterEndTime) {
      return chapter;
    }
  }
  return nullChapterInfo;
}



void seekBack() {
  seekOffset(-10);
}

void seekForward() {
  seekOffset(10);
}

void seekOffset(int seconds) {
  final currentPos = player.state.position;
  final newPos = currentPos.inSeconds + seconds;

  seek(Duration(seconds: max(0, newPos)));
}

void seek(Duration duration) {
  player.seek(duration);
}

void seekChapter(ChapterInformation ch) {
  final micros = (Duration(
    microseconds: chapterInfoTimeToMicros(ch.startTime!),
  ));

  player.seek(micros);
}
