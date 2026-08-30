import 'package:file_picker/file_picker.dart';
import 'package:fl_audiobook/my_route_transition.dart';
import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/routes/settings_page.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/services/files.dart' as files;
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/widgets/home/hero_player.dart';
import 'package:fl_audiobook/widgets/home/hero_usage_hint.dart';
import 'package:fl_audiobook/widgets/home/last_played_list.dart';
import 'package:fl_audiobook/widgets/home/popover_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:yaru/yaru.dart';

import '../tray.dart' as tray;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void dispose() {
    PlayerService().dispose();
    super.dispose();
  }

  var showHamburgerMenu = false;

  bool shouldTransition = false;

  void pickFile() async {
    PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ["m4b", "m4a", "mp3"],
    );

    if (file != null) {
      try {
        await PlayerService().openFile(
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
    // globals.mediaPlayer2.emitPropertiesChanged(
    //   "org.mpris.MediaPlayer2.Player",
    //   changedProperties: {
    //     "Metadata": DBusDict(
    //       DBusSignature.string,
    //       DBusSignature.variant,
    //       (await globals.mediaPlayer2.buildMetadata())!,
    //     ),
    //     "PlaybackStatus": DBusString("Playing"),
    //     "Position": DBusInt64(PlayerService().position.inMicroseconds),
    //   },
    //   invalidatedProperties: ["PlaybackStatus", "MetaData", "Position"],
    // );
    // globals.mediaPlayer2.emitSeeked(
    //   PlayerService().position.inMicroseconds,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.comma, control: true): () {
          print("nav setting from shortcut");
          Navigator.of(context).push(SettingsTransition(child: SettingsPage()));
        },
        const SingleActivator(
          LogicalKeyboardKey.keyO,
          control: true,
        ): () async {
          if (await files.pickFile()) {
            print("check mounted");

            // TODO known problem: if the menu is closed before a book is selected the widget is unmounted and navigation is blocked
            // TODO resume playback if user picked an audiobook they already have played
            if (mounted) {
              print("navigating to player");
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => PlayerPage()),
              );
            }
          }
        },
        const SingleActivator(LogicalKeyboardKey.space): () {
          PlayerService().playOrPause();
        }
          
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: YaruWindowTitleBar(
            backgroundColor: Colors.transparent,
            onClose: (p0) {
              tray.hideOrClose();
            },
            onShowMenu: (p0) => {},
            border: BorderSide.none,
            leading: Center(
              child: Image.asset("images/app_icon.png", height: 24, width: 24),
            ),
            // leading: IconButton(
            //   onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            //   icon: Icon(YaruIcons.menu),
            // ),
            title: Text("fl_audiobook"),
            actions: [
              PortalTarget(
                visible: showHamburgerMenu,
                anchor: const Aligned(
                  follower: Alignment.topCenter,
                  target: Alignment.bottomCenter,
                  offset: Offset(0, 8),
                ),
                portalFollower: PopoverMenu(
                  close: () {
                    setState(() {
                      showHamburgerMenu = false;
                    });
                  },
                ),

                child: Tooltip(
                  message: "App Menu",
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        showHamburgerMenu = true;
                      });
                    },
                    icon: Icon(YaruIcons.menu),
                  ),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            width: 200,
            shape: RoundedRectangleBorder(
              borderRadius: .only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: DrawerContents(),
          ),
          body: PortalTarget(
            visible: showHamburgerMenu,
            portalFollower: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  showHamburgerMenu = false;
                });
              },
            ),
            child: StreamBuilder(
              stream: ConfigProvider().configStreamController.stream,
              builder: (context, asyncSnapshot) {
                var books = ConfigProvider().playbackStates;
                var config = ConfigProvider().config;
                if (asyncSnapshot.hasData) {
                  books = asyncSnapshot.data!.playbackStates;
                  config = asyncSnapshot.data!;
                }

                if (books.isEmpty) {
                  return HeroUsageHint(onClick: pickFile);
                }

                return Column(
                  mainAxisAlignment: .spaceAround,
                  crossAxisAlignment: .start,
                  children: [
                    StreamBuilder(
                      stream: PlayerService().selectedBookStream.stream,
                      builder: (context, asyncSnapshot) {
                        var file = PlayerService().playingFile;

                        if (file == null && !asyncSnapshot.hasData) {
                          return HeroUsageHint(onClick: pickFile);
                        }

                        if (asyncSnapshot.hasData &&
                            asyncSnapshot.data != null) {
                          file = asyncSnapshot.data!;
                        }

                        if (file == null) {
                          return HeroUsageHint(onClick: pickFile);
                        }
                        return HeroPlayer(file: file);
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: 8.0,
                    //     horizontal: 20,
                    //   ),
                    //   child: Text("Last played"),
                    // ),

                    if (config.playbackStates.length < 2 &&
                        PlayerService().playingFile != null)
                      Expanded(child: SizedBox())
                    else
                      LastPlayedList(
                        onPickFile: pickFile,
                        onTransition: _transition,
                        config: config,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerContents extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: .center,
        spacing: 32,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Image.asset("images/app_icon.png"),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                YaruNavigationRailItem(
                  icon: Icon(YaruIcons.settings),
                  style: YaruNavigationRailStyle.labelledExtended,
                  label: Text("Preferences"),
                  extendedSelectedIndicator: true,
                  onTap: () => {print("navigate to preferences")},
                ),
                YaruNavigationRailItem(
                  icon: Icon(YaruIcons.information),
                  style: YaruNavigationRailStyle.labelledExtended,
                  label: Text("About"),
                  extendedSelectedIndicator: true,
                  onTap: () => {
                    showAboutDialog(
                      context: context,
                      applicationVersion: "0.1.0",
                      applicationIcon: Image.asset("images/app_icon.png"),
                      applicationLegalese: "This software is very cool.",
                    ),
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              "version 0.1.0",
              style: TextStyle(color: const Color.fromARGB(255, 97, 97, 97)),
            ),
          ),
        ],
      ),
    );
  }
}
