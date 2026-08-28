import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dbus/dbus.dart';
import 'package:ffmpeg_kit_next_flutter/chapter.dart';
import 'package:ffmpeg_kit_next_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_next_flutter/ffprobe_kit.dart';
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/globals.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:xdg_directories/xdg_directories.dart';

final class BookFile {
  final String name;
  final String path;

  new({required this.name, required this.path});
  Future<File?> get coverImage async {
    final coverPath = "${dataHome.path}/${globals.APP_DIR}/${name}.jpg";
    var coverFile = File(coverPath);
    if (coverFile.existsSync()) {
      return coverFile;
    }

    // todo convert to executeWithArguments
    final coverSession = FFmpegKit.execute(
      "-y -v error -hide_banner -i \"$path\" -an -vcodec copy \"$coverPath\"",
    );

    return null;
  }
}

class AudiobookChapter {
  // ignore: non_constant_identifier_names
  static AudiobookChapter EMPTY = AudiobookChapter._(
    title: "",
    start: Duration(seconds: 0),
    end: Duration(seconds: 1),
    duration: Duration(seconds: 1),
  );

  Duration start;
  Duration end;
  String title;
  Duration duration;

  factory AudiobookChapter.fromChapterInfo(Chapter info) {
    // it's either parsing timestamps in seconds like "60.0000002" or
    // parsing a time base (like "1/44100") and dividing info.start and info.end
    // by that. This seemed easier at the moment, but maybe there's value
    // in caputring the sample rate?
    final startMicros = _chapterInfoTimeToMicros(info.getStartTime()!);
    final endMicros = _chapterInfoTimeToMicros(info.getEndTime()!);

    final durationMicros = endMicros - startMicros;

    var title = "";

    if (info.getTags() != null && info.getTags()!["title"] != null) {
      title = info.getTags()!["title"];
    } else if (info.getId() != null) {
      title = info.getId()!.toString();
    }

    return AudiobookChapter._(
      title: title,
      start: Duration(microseconds: startMicros),
      end: Duration(microseconds: endMicros),
      duration: Duration(microseconds: durationMicros),
    );
  }

  AudiobookChapter._({
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
  bool loading = false;

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

  static int chapterInfoTimeToMicros(String timestamp) {
    try {
      return (double.parse(timestamp) * 1_000_000).round();
    } catch (error) {
      return 0;
    }
  }

  Image coverImage = (Image.asset(
    "images/cover_default.png",
    key: UniqueKey(),
  ));

  Map<String, dynamic> tags = {};

  BookFile? playingFile;

  int resumedPosition = 0;

  final skipbackTime = 2;
  List<AudiobookChapter> chapters = [];

  AudiobookChapter? get currentChapter {
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

  AudiobookChapter? getChapterFor(Duration position) {
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
    print("opening ${file.name} at ${position}");

    loading = true;

    // open file with mpv
    final media = Media(file.path, start: Duration(microseconds: position));

    final mediaSessionCommandArgs = [
      "-v",
      "error",
      "-hide_banner",
      "-print_format",
      "json",
      "-show_format",
      "-show_streams",
      "-show_chapters",
      "-show_entries",
      "format",
      "-i",
      file.path,
    ];

    // get metadata
    final mediaInformationSession =
        await FFprobeKit.getMediaInformationFromCommandArguments(
          mediaSessionCommandArgs,
        );
    final mediaInformation = mediaInformationSession.getMediaInformation();
    if (mediaInformation == null) {
      throw ArgumentError(["could not get media info from ${file.path}!"]);
    }

    // chapter info
    var ffprobeChapters = mediaInformation.getChapters();
    if (ffprobeChapters.isEmpty) {
      if (mediaInformation.getDuration() == null) {
        throw ArgumentError(["could not get duration for ${file.path}"]);
      }
      var startTimeStr = mediaInformation.getStartTime() ?? "0.0";
      var durationStr = mediaInformation.getDuration()!;
      var startTime = chapterInfoTimeToMicros(startTimeStr);
      var duration = chapterInfoTimeToMicros(durationStr);
      chapters = [
        AudiobookChapter._(
          title: "",
          start: Duration(microseconds: startTime),
          end: Duration(microseconds: startTime + duration),
          duration: Duration(microseconds: duration),
        ),
      ];
    } else {
      chapters = mediaInformation
          .getChapters()
          .map(
            (ffprobeChapter) =>
                AudiobookChapter.fromChapterInfo(ffprobeChapter),
          )
          .toList();
    }

    // tags
    var ffprobeTags = mediaInformation.getTags();
    if (ffprobeTags == null || ffprobeTags.isEmpty) {
      tags = {"title": file.name};
    } else {
      tags = ffprobeTags.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    }

    // cover image
    var coverfile = await file.coverImage;
    if (coverfile == null) {
      print("didn't find a cover for ${file.path}");
      coverImage = Image.asset("images/cover_default.png", key: UniqueKey());
    }

    // start playing
    await _player.open(media, play: true);

    // tell everyone about it
    selectedBookStream.add(file);
    loading = false;
    ready = true;

    // start updating config with play state
    initTimer(); 
  }

  void seek(Duration duration) {
    seekStream.sink.add(_player.state.position);

    _player.seek(duration);
  }

  void seekBack() {
    seekOffset(-10);
  }

  void seekChapter(AudiobookChapter ch) {
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

  Timer? timer;

  void initTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      
      // todo factor out into its own thing and make it smarter
      ConfigProvider().updatePlaybackState();


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
}
