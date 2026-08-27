import 'dart:async';
import 'dart:math';

import 'package:dbus/dbus.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/media_player2.dart';
import 'package:fl_audiobook/services/player_service.dart';
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

List<AudiobookChapter>? chapters;

StreamController<BookFile> selectedBookStream = StreamController<BookFile>.broadcast(); 
StreamController<Duration> seekStream  = StreamController<Duration>.broadcast(); 


int chapterInfoTimeToMicros(String timestamp) {
  try {
    return (double.parse(timestamp) * 1_000_000).round();
  } catch (error) {
    return 0;
  }
}

AudiobookChapter getCurrentChapter() {
  return getChapterFor(player.state.position);
}

AudiobookChapter getChapterFor(Duration position) {

  for (var chapter in chapters!) {
    final chapterStartTime = chapter.start.inMicroseconds;
    final chapterEndTime = chapter.end.inMicroseconds;
    final positionMicros = position.inMicroseconds;
    if (chapterStartTime < positionMicros && positionMicros <= chapterEndTime) {
      return chapter;
    }
  }

  return AudiobookChapter.EMPTY; 
}




final skipbackTime = 2;
// bad name. skips back to chapter start if already playing and _then_ back to the previous one
void seekLastChapter() async {
  var timeIn = timeInChapter(player.state.position);

  var pos = player.state.position;

  if (timeIn.inSeconds < skipbackTime) {
    //await player.seek(player.state.position - Duration(seconds: skipbackTime));
    
    timeIn = timeInChapter(
      player.state.position - Duration(seconds: skipbackTime),
    );
    seek(pos - timeIn - Duration(seconds: skipbackTime));
  } else {
    seek(pos - timeIn + Duration(milliseconds: 1));
  }
}

void seekBack() {
  seekOffset(-10);
}

void seekForward() {
  seekOffset(10);
}

void seekNextChapter() {
  var timeLeft = timeLeftInChapter(player.state.position);
  seek(player.state.position - timeLeft);

  //seekOffset(timeLeftInChapter(player.state.position).inMicroseconds);
}

void seekOffset(int seconds) {
  final currentPos = player.state.position;
  final newPos = currentPos.inSeconds + seconds;

  seek(Duration(seconds: max(0, newPos)));
}

void seek(Duration duration) {

  seekStream.sink.add(player.state.position); 

  player.seek(duration);
}

void seekChapter(AudiobookChapter ch) {
  final micros = ch.start;

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
