import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/widgets/home/last_played_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:yaru/yaru.dart';

class LastPlayedCard extends StatefulWidget {
  const new({
    super.key,
    required this.bookFile,
    required this.state,
    required this.widget,
    required this.coverfile,
    required this.dateTimeLabel,
    required this.listeningProgress,
    required this.timeRemainingLabel,
  });

  final BookFile bookFile;
  final BookPlaybackState state;
  final LastPlayedList widget;
  final Future<File?> coverfile;
  final String dateTimeLabel;
  final double listeningProgress;
  final String timeRemainingLabel;

  @override
  State<LastPlayedCard> createState() => _LastPlayedCardState();
}

class _LastPlayedCardState extends State<LastPlayedCard> {
  String showBookMenu = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await PlayerService().openFile(
          widget.bookFile,
          position: widget.state.position,
        );
        widget.widget.onTransition();
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
                future: widget.coverfile,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    if (asyncSnapshot.data == null) {
                      return globals.defaultCoverImage;
                    }
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
                          Text(widget.state.title, style: .new(fontSize: 20)),
                          Text(
                            "by ${widget.state.author}",
                            style: .new(
                              fontSize: 14,
                              color: YaruColors.warmGrey,
                            ),
                          ),
                        ],
                      ),
                      Text("last played ${widget.dateTimeLabel}"),

                      Expanded(
                        child: Row(
                          spacing: 8,
                          children: [
                            Flexible(
                              child: LinearProgressIndicator(
                                value: widget.listeningProgress,
                              ),
                            ),
                            Text("${widget.timeRemainingLabel} remaining"),
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
                    tooltip: "play ${widget.state.title}",

                    padding: EdgeInsets.all(
                      0,
                    ), // Adjust padding to center the icon
                    icon: Icon(
                      YaruIcons.media_play,
                      size: 30,
                    ), // Larger icon to fill the space
                    onPressed: () async {
                      await PlayerService().openFile(
                        widget.bookFile,
                        position: widget.state.position,
                      );
                      widget.widget.onTransition();
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
                      visible: showBookMenu == widget.state.file,
                      anchor: const Aligned(
                        follower: Alignment.centerRight,
                        target: Alignment.centerLeft,
                        offset: Offset(-8, 0),
                      ),
                      portalFollower: BookMenu(
                        bookPlayebackState: widget.state,
                        close: () {
                        setState(() {
                          showBookMenu = "";
                        });                        },
                      ),
                      child: IconButton(
                        tooltip: "options for ${widget.state.title}",

                        padding: EdgeInsets.all(
                          0,
                        ), // Adjust padding to center the icon
                        icon: Icon(
                          YaruIcons.view_more_horizontal,
                          size: 30,
                        ), // Larger icon to fill the space
                        onPressed: () {
                          setState(() {
                            showBookMenu = widget.state.file;
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
  }
}

class BookMenu extends StatelessWidget {
  final BookPlaybackState bookPlayebackState;
  final VoidCallback close; 
  const new({super.key, required this.bookPlayebackState,required this.close});

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
              onPressed: ()  { 
                openBookDirectory(bookPlayebackState.path);
                close();
                },
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
