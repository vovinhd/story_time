import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/l10n/app_localizations.dart';
import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/services/files.dart';
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
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    Future<bool> fileExists = File(widget.bookFile.path).exists();
    return MouseRegion(
      onHover: (event) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          hovered = false;
        });
      },
      child: GestureDetector(
        onTap: () async {
          await PlayerService().openFile(
            widget.bookFile,
            position: widget.state.position,
          );
          widget.widget.onTransition();
        },
        child: Card(
          surfaceTintColor: hovered
              ? (Theme.of(context).brightness == .dark
                    ? Colors.white
                    : Colors.black)
              : Colors.transparent,
          clipBehavior: .antiAlias,
          child: Container(
            // color: Colors.red ,

            padding: EdgeInsets.only(right: 8),
            // height: 100,
            child: Row(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              spacing: 12,
              children: [
                SizedBox(
                  width: 130,
                  child: FutureBuilder(
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
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .spaceAround,
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        Column(
                          spacing: 0,
                          mainAxisAlignment: .spaceBetween,
                          crossAxisAlignment: .start,
                          children: [
                            FutureBuilder(
                              future: fileExists,
                              builder: (context, asyncSnapshot) {
                                if (asyncSnapshot.hasData &&
                                    !asyncSnapshot.data!) {
                                  return Container(
                                    // color: Colors.red,
                                    decoration: BoxDecoration(
                                      // borderRadius: .circular(20),
                                      // border: Border.all(color: Colors.red),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: .center,
                                      spacing: 8,
                                      children: [
                                        Icon(YaruIcons.error),
                                        Text(
                                           AppLocalizations.of(context)!.fileNotAvailable,
                                          style: .new(
                                            fontWeight: .bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                            Text(widget.state.title, style: .new(fontSize: 20)),
                            if (widget.state.author != "")
                              Text(
                                AppLocalizations.of(context)!.artistLabel(widget.state.author)
                                ,
                                style: .new(
                                  fontSize: 14,
                                  color: YaruColors.warmGrey,
                                ),
                              ),
                          ],
                        ),
                        Text(AppLocalizations.of(context)!.lastPlayedCardLastPlayed(widget.dateTimeLabel)),

                        Row(
                          spacing: 8,
                          children: [
                            Flexible(
                              child: LinearProgressIndicator(
                                value: widget.listeningProgress,
                              ),
                            ),
                            Text(AppLocalizations.of(context)!.lastPlayedCardRemaining(widget.timeRemainingLabel)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                  future: fileExists,
                  builder: (context, asyncSnapshot) {
                    if (!asyncSnapshot.hasData) {
                      return SizedBox();
                    }

                    // file doesnt exist menu
                    if (!asyncSnapshot.data!) {
                      return Row(
                        children: [
                          IconButton(
                            tooltip: AppLocalizations.of(context)!.lastPlayedCardLocate(widget.state.title),

                            padding: EdgeInsets.all(
                              0,
                            ), // Adjust padding to center the icon
                            icon: Icon(
                              YaruIcons.folder,
                              size: 30,
                            ), // Larger icon to fill the space
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(AppLocalizations.of(context)!.lastPlayedCardLocate(widget.state.title)),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: Text(AppLocalizations.of(context)!.dialogCancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      pickFile(); 
                                      Navigator.pop(context, 'OK');
                                    },
                                    child: Text(AppLocalizations.of(context)!.dialogOk),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => showDeleteDialog(context),

                            icon: Icon(
                              YaruIcons.trash,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ],
                      );
                    }
                    // file exists menu
                    return Row(
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
                              delete: () => showDeleteDialog(context),
                              close: () {
                                setState(() {
                                  showBookMenu = "";
                                });
                              },
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> showDeleteDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.lastPlayedCardForget(widget.state.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(AppLocalizations.of(context)!.dialogCancel),
          ),
          TextButton(
            onPressed: () {
              ConfigProvider().removePlaybackState(widget.bookFile.name);
              Navigator.pop(context, 'OK');
            },
            child: Text(AppLocalizations.of(context)!.dialogOk),
          ),
        ],
      ),
    );
  }
}

class BookMenu extends StatelessWidget {
  final BookPlaybackState bookPlayebackState;
  final VoidCallback close;
  final VoidCallback delete;
  const new({
    super.key,
    required this.bookPlayebackState,
    required this.close,
    required this.delete,
  });

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
        decoration: popoverBoxDecoration(context),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                openBookDirectory(bookPlayebackState.path);
                close();
              },
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    YaruIcons.folder_open,
                    color: Theme.of(context).brightness == .dark
                        ? Colors.white
                        : YaruColors.textGrey,
                  ),
                  Text(
                    AppLocalizations.of(context)!.lastPlayedCardReveal,
                    style: .new(
                      color: Theme.of(context).brightness == .dark
                          ? Colors.white
                          : YaruColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),

            TextButton(
              // onLongPress: () => {
              //   ConfigProvider().removePlaybackState(bookPlayebackState.file),
              // },
              onPressed: () {
                close();
                delete();
              },
              child: Row(
                spacing: 8,

                children: [
                  Icon(YaruIcons.trash, color: Colors.red),
                  Text(AppLocalizations.of(context)!.lastPlayedCardForgetButton, style: .new(color: Colors.red)),
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
