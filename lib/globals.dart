import 'dart:async';
import 'dart:math';

import 'package:dbus/dbus.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:fl_audiobook/book_select_page.dart';
import 'package:fl_audiobook/config.dart';
import 'package:fl_audiobook/media_player2.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

// ignore: constant_identifier_names
const String APP_DIR = "fl_audiobookplayer";

MediaPlayer2 mediaPlayer2 = MediaPlayer2();

BookFile? playingFile;

int resumedPosition = 0;

final player = Player(
  configuration: PlayerConfiguration(
    async: false,
    osc: true,
    title: "fl_audiobook",
  ),
);
Image defaultCoverImage = Image.asset(
  "images/cover_default.png",
  key: UniqueKey(),
);
Image coverImage = (Image.asset("images/cover_default.png", key: UniqueKey()));
bool ready = false;
Map<String, dynamic>? tags;

// final subPositiong = player.stream.position.listen((position) {

// });

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

void seekResume() async {
  await player.seek(Duration(microseconds: resumedPosition));
}

void seekLastChapter() {
  seekOffset(-timeInChapter(player.state.position).inMicroseconds);
}

void seekBack() {
  seekOffset(-10);
}

void seekForward() {
  seekOffset(10);
}
void seekNextChapter() {
  seekOffset(timeLeftInChapter(player.state.position).inMicroseconds);
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

Timer? timer;

void initTimer() {
  if (timer != null && timer!.isActive) return;

  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //job
    ConfigProvider().updatePlaybackState();

    // todo factor out into its own thing

    if (player.state.playing) {
      mediaPlayer2.emitPropertiesChanged(
        "org.mpris.MediaPlayer2.Player",
        changedProperties: {
          "Position": DBusInt64(player.state.position.inMicroseconds),
        },
        invalidatedProperties: ["Position"],
      );
    }
  });
}
