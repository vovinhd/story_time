import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dbus/dbus.dart';
// import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/playback_position_slider.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:yaru/yaru.dart';

StreamSubscription? subs;

StreamController<bool> requestFilePickStream = StreamController<bool>();

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
  State<BookSelectPage> createState() => BookSelectPageState();
}

class BookSelectPageState extends State<BookSelectPage> {
  bool shouldTransition = false;

  late final foo = requestFilePickStream.stream.listen((data) {
    print("hi");
    pickFile();
  });

  void pickFile() async {
    PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ["m4b"],
    );

    if (file != null) {
      try {
        await globals.playerService.openFile(
          BookFile(name: file.name, path: file.path!),
        );
        _transition();
      } catch (e) {
        print(e);
      }
    } else {
      // User canceled the picker
      print("User canceled the picker");
    }
  }
  void _pushPlayerRoute() {
    if (mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (context) => PlayerPage()));
    }
  }

  void _transition() async {
    ConfigProvider().updatePlaybackState();
    _pushPlayerRoute();

    // emit the dbus state change

    // TODO factor into media_player2 
    globals.mediaPlayer2.emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "Metadata": DBusDict(
          DBusSignature.string,
          DBusSignature.variant,
          (await globals.mediaPlayer2.buildMetadata())!,
        ),
        "PlaybackStatus": DBusString("Playing"),
        "Position": DBusInt64(globals.playerService.position.inMicroseconds),
      },
      invalidatedProperties: ["PlaybackStatus", "MetaData", "Position"],
    );
    globals.mediaPlayer2.emitSeeked(
      globals.playerService.position.inMicroseconds,
    );
  }

  var offset = 0.0;

  var showBookMenu = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .spaceAround,
      crossAxisAlignment: .start,
      children: [
        StreamBuilder(
          stream: globals.playerService.selectedBookStream.stream,
          builder: (context, asyncSnapshot) {
            if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
              return SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Image.asset(
                        "images/cover_default.png",
                        key: UniqueKey(),
                      ),
                    ),
                    Text(
                      "Listen to audiobooks",
                      style: .new(fontSize: 32, fontWeight: .bold),
                    ),
                    Text(
                      "in .m4b format with metadata because this is programmed like crap",
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Center(
                            child: TextButton(
                              onPressed: () => pickFile(),
                              style: .new(
                                backgroundColor: WidgetStatePropertyAll(
                                  YaruColors.adwaitaYellow,
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  YaruColors.porcelain,
                                ),
                              ),
                              child: Text(
                                "Open Audiobook",
                                style: .new(fontWeight: .bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
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
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child:
                                  Image(
                                        fit: .fill,
                                        image: globals
                                            .playerService
                                            .coverImage
                                            .image,
                                        height: double.infinity,
                                        width: double.infinity,
                                        repeat: .noRepeat,
                                      )
                                      .animate(
                                        key: Key(asyncSnapshot.data!.name),
                                      )
                                      .fade(),
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
                                      child: globals.playerService.coverImage,
                                    ),

                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          mainAxisAlignment: .spaceBetween,
                                          // spacing: 16,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
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
                                                    globals
                                                        .playerService
                                                        .tags["title"],
                                                    style: TextStyle(
                                                      fontSize: 32,
                                                    ),
                                                  ),
                                                  Text(
                                                    globals
                                                        .playerService
                                                        .tags["artist"],
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
                                                      .playerService
                                                      .playOrPause,
                                                  icon: StreamBuilder(
                                                    stream: globals
                                                        .playerService
                                                        .isPlayingStream,
                                                    builder:
                                                        (
                                                          context,
                                                          asyncSnapshot,
                                                        ) {
                                                          var playing = globals
                                                              .playerService
                                                              .isPlaying;
                                                          if (asyncSnapshot
                                                              .hasData) {
                                                            playing =
                                                                asyncSnapshot
                                                                    .data!;
                                                          }
                                                          return Icon(
                                                            playing
                                                                ? YaruIcons
                                                                      .media_pause
                                                                : YaruIcons
                                                                      .media_play,
                                                          );
                                                        },
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
                                    ),
                                    // SizedBox(
                                    //   width: 60, // Custom width
                                    //   height: 60, // Custom height

                                    //   child: Icon(
                                    //     Icons.keyboard_arrow_right,
                                    //     size: 30,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: Text("Last played"),
        ),

        Expanded(
          child: Stack(
            children: [
              offset > 18 ? Container(color: YaruColors.jet) : SizedBox(),
              StreamBuilder(
                stream: ConfigProvider().streamController.stream,
                builder: (context, asyncSnapshot) {
                  var books = ConfigProvider().playbackStates;

                  if (asyncSnapshot.hasData) {
                    books = asyncSnapshot.data!.playbackStates;
                  }
                  return NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      //How many pixels scrolled from pervious frame
                      // print(notification.scrollDelta);

                      //List scroll position
                      offset = notification.metrics.pixels;
                      setState(() {});
                      return true;
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                        bottom: 100,
                      ),
                      itemCount: books.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= books.length) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: YaruSplitButton(
                                items: null,
                                child: Text("Open Audiobook"),
                                onPressed: () => pickFile(),
                              ),
                            ),
                          );
                        }
                        final state = books[index];
                        final bookFile = BookFile(
                          name: state.file,
                          path: state.path,
                        );
                        if (globals.playerService.playingFile != null &&
                            bookFile.name ==
                                globals.playerService.playingFile!.name) {
                          return SizedBox();
                        }
                        final coverfile = bookFile.coverImage;
                        final now = DateTime.now();
                        final agoDateTime = now.subtract(
                          now.difference(state.lastPlayed),
                        );
                        final dateTimeLabel = timeago.format(agoDateTime);

                        final timeRemaining =
                            Duration(microseconds: state.duration) -
                            Duration(microseconds: state.position);
                        final timeRemainingLabel = printDuration(timeRemaining);

                        final listeningProgress =
                            state.position / state.duration;

                        return GestureDetector(
                          onTap: () async {
                            await globals.playerService.openFile(
                              bookFile,
                              position: state.position,
                            );
                            _transition();
                          },
                          child: Card(
                            clipBehavior: .antiAlias,
                            child: Container(
                              padding: EdgeInsets.only(right: 8),
                              height: 100,
                              child: Row(
                                mainAxisAlignment: .start,
                                crossAxisAlignment: .center,
                                spacing: 8,
                                children: [
                                  FutureBuilder(
                                    future: coverfile,
                                    builder: (context, asyncSnapshot) {
                                      if (asyncSnapshot.data != null) {
                                        return Image.file(asyncSnapshot.data!);
                                      }
                                      return globals.defaultCoverImage;
                                    },
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        mainAxisAlignment: .spaceBetween,
                                        children: [
                                          Row(
                                            spacing: 8,

                                            children: [
                                              Text(
                                                state.title,
                                                style: .new(fontSize: 20),
                                              ),
                                              Text(
                                                "by ${state.author}",
                                                style: .new(
                                                  fontSize: 14,
                                                  color: YaruColors.warmGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text("last played $dateTimeLabel"),

                                          Expanded(
                                            child: Row(
                                              spacing: 8,
                                              children: [
                                                Flexible(
                                                  child:
                                                      LinearProgressIndicator(
                                                        value:
                                                            listeningProgress,
                                                      ),
                                                ),
                                                Text(
                                                  "$timeRemainingLabel remaining",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        tooltip: "play ${state.title}",

                                        padding: EdgeInsets.all(
                                          0,
                                        ), // Adjust padding to center the icon
                                        icon: Icon(
                                          YaruIcons.media_play,
                                          size: 30,
                                        ), // Larger icon to fill the space
                                        onPressed: () async {
                                          await globals.playerService.openFile(
                                            bookFile,
                                            position: state.position,
                                          );
                                          _transition();
                                        },
                                      ),

                                      PortalTarget(
                                        visible: showBookMenu != "",
                                        // portalFollower: Container(color: Colors.amber,),
                                        portalFollower: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            setState(() {
                                              showBookMenu = "";
                                            });
                                          },
                                        ),

                                        child: PortalTarget(
                                          visible: showBookMenu == state.file,
                                          anchor: const Aligned(
                                            follower: Alignment.centerRight,
                                            target: Alignment.centerLeft,
                                            offset: Offset(-8, 0),
                                          ),
                                          portalFollower: BookMenu(
                                            bookPlayebackState: state,
                                          ),
                                          child: IconButton(
                                            tooltip:
                                                "options for ${state.title}",

                                            padding: EdgeInsets.all(0), // Adjust padding to center the icon
                                            icon: Icon(
                                              YaruIcons.view_more_horizontal,
                                              size: 30,
                                            ), // Larger icon to fill the space
                                            onPressed: () {
                                              setState(() {
                                                showBookMenu = state.file;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Container(
                // fake a shadow the hard way
                clipBehavior: .none,
                width: double.infinity,
                height: 15,
                child: offset > 18
                    ? Stack(
                        children: [
                          Container(
                            constraints: .expand(),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: .topCenter,
                                end: .bottomCenter,
                                colors: [
                                  const Color.fromARGB(100, 0, 0, 0),
                                  Colors.transparent,
                                ],
                                stops: [0.11, 1.0],
                              ),
                            ),
                          ).animate().scaleY(
                            begin: 0,
                            alignment: .topCenter,
                            duration: Duration(milliseconds: 200),
                          ),
                          Container(height: 1, color: YaruColors.coolGrey),
                        ],
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),

        // Expanded(
        //   flex: 1,
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: .center,
        //       children: [
        //         YaruSplitButton(
        //           items: null,
        //           child: Text("Open Audiobook"),
        //           onPressed: () => _pickFile(),
        //         ),

        //       ],
        //     ),
        //   ),
        // ),
        // MiniPlayer(),
      ],
    );
  }
}

void openBookDirectory(String path) async {
  print("Show $path in file explorer");
  try {
    final isDirectory = await Directory(path).exists();
    final isFile = await File(path).exists();

    if (isDirectory) {
      Process.run("xdg-open", [path]);
      return;
    } else if (isFile) {
      // remove file name
      var dirs = path.split("/");
      dirs.removeLast();
      var dir = dirs.join("/");
      Process.run("xdg-open", [dir]);
    } else {
      print("?????");
    }
  } catch (e) {
    print(e);
  }
}

class BookMenu extends StatelessWidget {
  final BookPlaybackState bookPlayebackState;

  const new({super.key, required this.bookPlayebackState});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("hi");
      },
      child: Container(
        height: 76,
        width: 200,

        clipBehavior: .antiAlias,
        decoration: popoverBoxDecoration,
        child: Column(
          children: [
            TextButton(
              onPressed: () => {openBookDirectory(bookPlayebackState.path)},
              child: Row(
                spacing: 8,
                children: [
                  Icon(YaruIcons.folder_open, color: Colors.white),
                  Text(
                    "Show in file explorer",
                    style: .new(color: Colors.white),
                  ),
                ],
              ),
            ),

            TextButton(
              onLongPress: () => {
                ConfigProvider().removePlaybackState(bookPlayebackState.path),
              },
              onPressed: () => [],
              child: Row(
                spacing: 8,

                children: [
                  Icon(YaruIcons.trash, color: Colors.red),
                  Text("remove from history", style: .new(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
