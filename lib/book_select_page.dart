import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dbus/dbus.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_audiobook/config.dart';
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/mini_player.dart';
import 'package:fl_audiobook/playback_position_slider.dart';
import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:media_kit/media_kit.dart';
import 'package:xdg_directories/xdg_directories.dart';
import 'package:yaru/yaru.dart';

StreamSubscription? subs;

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

// File? getCoverImageForFile(filename) {
//   final coverPath = "${dataHome.path}/${globals.APP_DIR}/${filename}.jpg";
//   var coverFile = File(coverPath);
//   if (coverFile.existsSync()) {
//     return coverFile;
//   }

//   return null;
// }

class BookSelectPage extends StatefulWidget {
  const new({super.key});
  @override
  State<BookSelectPage> createState() => _BookSelectPageState();
}

class _BookSelectPageState extends State<BookSelectPage> {
  bool shouldTransition = false;

  void _pickFile() async {
    PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ["m4b"],
    );

    if (file != null) {
      _openFile(BookFile(name: file.name, path: file.path!));
    } else {
      // User canceled the picker
      print("User canceled the picker");
    }
  }

  void _openFile(BookFile file, {int position = 0}) async {
    print("opening ${file.name} at ${position}");
    globals.resumedPosition = position;
    final media = Media(file.path, start: Duration(microseconds: position));
    // print(media.toString());
    final canonicalPath = "\"${file.path}\"";
    globals.playingFile = file;

    final session = FFprobeKit.getMediaInformation(canonicalPath);
    final info = session.getMediaInformation();
    globals.chapters = info?.chapters;
    globals.tags = info?.tags;

    var coverFile = file.coverImage;

    if (coverFile == null) {
      final coverPath = "${dataHome.path}/${globals.APP_DIR}/${file.name}.jpg";

      final coverSess = FFmpegKit.execute(
        "-y -i $canonicalPath -an -vcodec copy \"$coverPath\"",
      );

      coverFile = File(coverPath);
      globals.coverImage = Image.file(coverFile, key: UniqueKey());
    } else {
      globals.coverImage = Image.file(coverFile, key: UniqueKey());
    }

    await globals.player.open(media, play: true);

    globals.selectedBookStream.add(file);

    _transition();
  }

  void _pushPlayerRoute () {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => PlayerPage(
            player: globals.player,
            chapters: globals.chapters!,
            tags: globals.tags!,
            cover: globals.coverImage,
          ),
        ),
      );
    }
  }

  void _transition() async {
    globals.ready = true;
    globals.initTimer();
    ConfigProvider().updatePlaybackState();
    await Future.delayed(Duration(milliseconds: 300), ()=> {}); 
    _pushPlayerRoute(); 

    // emit the dbus state change

    globals.mediaPlayer2.emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "Metadata": DBusDict(
          DBusSignature.string,
          DBusSignature.variant,
          globals.mediaPlayer2.buildMetadata()!,
        ),
        "PlaybackStatus": DBusString("Playing"),
        "Position": DBusInt64(globals.player.state.position.inMicroseconds),
      },
      invalidatedProperties: ["PlaybackStatus", "MetaData", "Position"],
    );
    globals.mediaPlayer2.emitSeeked(
      globals.player.state.position.inMicroseconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .spaceAround,
      children: [
        StreamBuilder(
          stream: globals.selectedBookStream.stream,
          builder: (context, asyncSnapshot) {
            if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
              return SizedBox();
            }
            return GestureDetector(
              onTap: () {
                _pushPlayerRoute(); 
                            },
              child: Material(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    // vertical: 32.0,
                    // horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      // Text("Now Playing", textAlign: .start),
                      ClipRRect(
                        clipBehavior: .antiAlias,
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(32),
                        ),
                        child: Container(
                          height: 200,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image(
                                  image: globals.coverImage.image,
                                  repeat: .repeat,
                                ),
                              ),
                              Positioned.fill(
                                child: Opacity(
                                  opacity: .4,
                                  child: Container(color: Color(0xFF000000)),
                                ),
                              ),
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 100,
                                  sigmaY: 100,
                                ),

                                child: (Container(
                                  padding: EdgeInsets.all(32),

                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //   color: Colors.white,
                                    //   width: .1,
                                    //   strokeAlign: BorderSide.strokeAlignInside,
                                    // ),
                                    // borderRadius: BorderRadius.circular(32),
                                  ),

                                  child: Row(
                                    children: [
                                      Hero(
                                        tag: asyncSnapshot.data!.name.hashCode,
                                        child: globals.coverImage,
                                      ),

                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          mainAxisAlignment: .spaceBetween,
                                          // spacing: 16,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment: .start,

                                                children: [
                                                  Text(
                                                    "Now Playing",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    globals.tags!["title"],
                                                    style: TextStyle(
                                                      fontSize: 32,
                                                    ),
                                                  ),
                                                  Text(
                                                    globals.tags!["artist"],
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: globals
                                                      .player
                                                      .playOrPause,
                                                  icon:
                                                      globals
                                                          .player
                                                          .state
                                                          .playing
                                                      ? Icon(
                                                          YaruIcons.media_pause,
                                                        )
                                                      : Icon(
                                                          YaruIcons.media_play,
                                                        ),
                                                ),
                                                CurrentPositionInChapterLabel(),
                                                Expanded(
                                                  child:
                                                      PlaybackPositionSlider(),
                                                ),
                                                EndLabel(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60, // Custom width
                                        height: 60, // Custom height

                                        child: Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 30,
                                          ),
                                        
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate(key: UniqueKey()).slideY(begin: 0.1, duration: Duration(milliseconds: 200)).scaleY(alignment: .topCenter, duration: Duration(milliseconds: 200));
          },
        ),
        Text("Last played"),
        Expanded(
          child: StreamBuilder(
            stream: ConfigProvider().streamController.stream,
            builder: (context, asyncSnapshot) {
              var books = ConfigProvider().playbackStates;

              if (asyncSnapshot.hasData) {
                books = asyncSnapshot.data!.playbackStates;
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                itemCount: books.length,
                itemBuilder: (BuildContext context, int index) {
                  final state = books[index];
                  final bookFile = BookFile(name: state.file, path: state.path);
                  if (globals.playingFile != null &&
                      bookFile.name == globals.playingFile!.name) {
                    return SizedBox();
                  }
                  final coverfile = bookFile.coverImage;
                  return ListTile(
                    leading: coverfile == null
                        ? globals.defaultCoverImage
                        : Hero(
                            tag: bookFile.name.hashCode,
                            child: Image.file(coverfile),
                          ),
                    title: Text(
                      "${state.title} - ${printDuration(Duration(microseconds: state.position))} ",
                    ),
                    trailing: SizedBox(
                      width: 105,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(YaruIcons.battery),
                          ),
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(YaruIcons.battery),
                          ),
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(YaruIcons.battery),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => {
                      _openFile(bookFile, position: state.position),
                    },
                  );
                },
              );
            },
          ),
        ),

        Expanded(
          flex: 1,
          child: Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                YaruSplitButton(
                  items: null,
                  child: Text("Open Audiobook"),
                  onPressed: () => _pickFile(),
                ),
                                YaruSplitButton(
                  items: null,
                  child: Text("Stop"),
                  onPressed: () => {globals.player.stop(),},
                ),
              ],
            ),
          ),
        ),
        // MiniPlayer(),
      ],
    );
  }
}
