import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:xdg_directories/xdg_directories.dart';

final class BookFile {
  final String name;
  final String path;

  new({required this.name, required this.path});
  File? get coverImage {
    final coverPath = "${dataHome.path}/${globals.APP_DIR}/${name}.jpg";
    var coverFile = File(coverPath);
    if (coverFile.existsSync()) {
      return coverFile;
    }

    return null;
  }
}

class Chapter {
  Duration start;
  Duration end;
  String title;
  Duration duration;

  factory Chapter.fromChapterInfo(ChapterInformation info) {
    // it's either parsing timestamps in seconds like "60.0000002" or
    // parsing a time base (like "1/44100") and dividing info.start and info.end
    // by that. This seemed easier at the moment, but maybe there's value
    // in caputring the sample rate?
    final startMicros = _chapterInfoTimeToMicros(info.startTime!);
    final endMicros = _chapterInfoTimeToMicros(info.endTime!);

    final durationMicros = endMicros - startMicros;

    var title = "";

    if (info.tags != null && info.tags!["title"] != null) {
      title = info.tags!["title"];
    } else if (info.id != null) {
      title = info.id!.toString();
    }

    return Chapter._(
      title: title,
      start: Duration(microseconds: startMicros),
      end: Duration(microseconds: endMicros),
      duration: Duration(microseconds: durationMicros),
    );
  }

  Chapter._({
    required this.title,
    required this.start,
    required this.end,
    required this.duration,
  });

  static int _chapterInfoTimeToMicros(String timestamp) {
    try {
      return (double.parse(timestamp) * 1_000_000).round();
    } catch (error) {
      return 0;
    }
  }
}

class PlayerService {
  bool ready = false;

  StreamController<BookFile> selectedBookStream =
      StreamController<BookFile>.broadcast();
  StreamController<Duration> seekStream =
      StreamController<Duration>.broadcast();

  final _player = Player(
    configuration: PlayerConfiguration(
      async: false,
      osc: true,
      title: "fl_audiobook",
    ),
  );

  Image coverImage = (Image.asset(
    "images/cover_default.png",
    key: UniqueKey(),
  ));

  Map<String, dynamic> tags = {};

  BookFile? playingFile;

  int resumedPosition = 0;

  final skipbackTime = 2;
  List<Chapter> chapters = [];

  Chapter? get currentChapter {
    return getChapterFor(_player.state.position);
  }

  bool get isPlaying {
    return _player.state.playing;
  }
  Stream<bool> get isPlayingStream {
    return _player.stream.playing;
  }

  Duration get position {
    return _player.state.position;
  }

  Stream<Duration> get positionStream {
    return _player.stream.position;
  }

  Chapter? getChapterFor(Duration position) {
    for (var chapter in chapters) {
      final positionMicros = position.inMicroseconds;
      if (chapter.start.inMicroseconds <= positionMicros &&
          positionMicros < chapter.end.inMicroseconds) {
        return chapter;
      }
    }
    // we went through the list of chapters and didn't find the playbacl position.
    // that means the chapter list didn't cover the whole file
    // this should never happen
    assert(
      false,
      "Either getChapterFor called without a file playing or chapters not exhaustive over playback time",
    );
    return null;
  }

  Future<void> openFile(BookFile file, {int position = 0}) async {
    // TODO finish this tmr
    print("opening ${file.name} at ${position}");

    resumedPosition = position;
    playingFile = file;

    final canonicalPath = "\"${file.path}\"";
    final session = FFprobeKit.getMediaInformation(canonicalPath);

    final media = Media(file.path, start: Duration(microseconds: position));
    final info = session.getMediaInformation();

    if (info != null) {
      chapters = info.chapters.map(Chapter.fromChapterInfo).toList();
      if (info.tags != null) {
        tags = info.tags!; 
      }
    } else {
      chapters = [
        Chapter._(
          title: "title",
          start: Duration(microseconds: 0),
          end: media.end!,
          duration: media.end!,
        ),
      ];
    }
    return;
  }

  void seek(Duration duration) {
    seekStream.sink.add(_player.state.position);

    _player.seek(duration);
  }

  void seekBack() {
    seekOffset(-10);
  }

  void seekChapter(Chapter ch) {
    seek(ch.start);
  }

  void seekForward() {
    seekOffset(10);
  }

  void seekLastChapter() async {
    var timeIn = timeInChapter(_player.state.position);

    var pos = _player.state.position;

    if (timeIn.inSeconds < skipbackTime) {
      //await player.seek(player.state.position - Duration(seconds: skipbackTime));

      timeIn = timeInChapter(
        _player.state.position - Duration(seconds: skipbackTime),
      );
      seek(pos - timeIn - Duration(seconds: skipbackTime));
    } else {
      seek(pos - timeIn + Duration(milliseconds: 1));
    }
  }

  void seekNextChapter() {
    var timeLeft = timeLeftInChapter(_player.state.position);
    seek(_player.state.position - timeLeft);

    //seekOffset(timeLeftInChapter(player.state.position).inMicroseconds);
  }

  void seekOffset(int seconds) {
    final currentPos = _player.state.position;
    final newPos = currentPos.inSeconds + seconds;

    seek(Duration(seconds: max(0, newPos)));
  }

  Duration timeInChapter(Duration position) {
    var currentChapter = getChapterFor(position);
    return position - currentChapter!.start;
  }

  Duration timeLeftInChapter(Duration position) {
    var currentChapter = getChapterFor(position);
    return currentChapter!.end - position;
  }
}
