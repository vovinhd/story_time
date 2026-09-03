
import 'package:file_picker/file_picker.dart';
import 'package:fl_audiobook/l10n/app_localizations.dart';
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
import 'package:logging/logging.dart';
import 'package:yaru/yaru.dart';

import '../tray.dart' as tray;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key

final _log = Logger('index');

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
        _log.severe(e);
      }
    } else {
      // User canceled the picker
      _log.info("User canceled the picker");
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
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.comma, control: true): () {
          _log.info("nav setting from shortcut");
          Navigator.of(context).push(SettingsTransition(child: SettingsPage()));
        },
        const SingleActivator(
          LogicalKeyboardKey.keyO,
          control: true,
        ): () async {
          if (await files.pickFile()) {
            // print("check mounted");
    
            if (mounted) {
              _log.info("navigating to player");
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => PlayerPage()),
              );
            }
          }
        },
        const SingleActivator(LogicalKeyboardKey.space): () {
          PlayerService().playOrPause();
        },
        const SingleActivator(LogicalKeyboardKey.enter): () {
          if (PlayerService().playingFile != null) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (context) => PlayerPage()));
          }
        },
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
              // AnimatedPopover(
              //   offset: Offset(0, 8),
              //   follower: Alignment.topRight,
              //   target: Alignment.bottomRight,
              //   tooltip: "app menu",
              //   icon: Icon(YaruIcons.menu),
              //   buttonStyleOverride: ButtonStyle(
              //     shape: WidgetStatePropertyAll(
              //       RoundedRectangleBorder(
              //         borderRadius: .circular(50),
              //         side: .none,
              //       ),
              //     ),
              //   ),
              //   noBorder: true,
              //   width: 34,
              //   child: PopoverMenu(
              //     close: () {
              //       setState(() {
              //       });
              //     },
              //   ),
              // ),
      
              PortalTarget(
                visible: showHamburgerMenu,
                anchor: const Aligned(
                  follower: Alignment.topCenter,
                  target: Alignment.bottomCenter,
                  offset: Offset(0, 0),
                ),
                portalFollower: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: showHamburgerMenu ? 1 : 0),
                  duration: Duration(milliseconds: 150),
      
                  builder: (context, progress, child) {
                    return Container(
                      transform: Matrix4.translationValues(
                        0 * progress,
                        8 * progress,
                        0,
                      ),
      
                      child: Opacity(
                        opacity: progress,
                        child: PopoverMenu(
                          close: () {
                            setState(() {
                              showHamburgerMenu = false;
                            });
                          },
                        ),
                      ),
                    );
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
            child: Stack(
              children: [
                StreamBuilder(
                  stream: ConfigProvider().configStreamController.stream,
                  builder: (context, asyncSnapshot) {
                    // return Text(AppLocalizations.of(context)!.helloWorld); 
                    var books = ConfigProvider().playbackStates;
                    var config = ConfigProvider().config;
                    if (asyncSnapshot.hasData) {
                      books = asyncSnapshot.data!.playbackStates;
                      config = asyncSnapshot.data!;
                    }
      
                    if (books.isEmpty) {
                      return HeroUsageHint(onClick: pickFile, expand: true);
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
                              return HeroUsageHint(onClick: pickFile, expand: false,);
                            }
      
                            if (asyncSnapshot.hasData &&
                                asyncSnapshot.data != null) {
                              file = asyncSnapshot.data!;
                            }
      
                            if (file == null) {
                              return HeroUsageHint(onClick: pickFile, expand: false,);
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
                Align(
                  alignment: .topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: AnimatedOpacity(
                      opacity: PlayerService().loading ? 1 : 0,
                      // opacity: 1,
                      duration: Duration(milliseconds: 1000),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == .dark
                              ? YaruColors.coolGrey
                              : YaruColors.porcelain,
                          borderRadius: BorderRadius.circular(1000),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(
                                0,
                                3,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
      
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 32.0),
                          child: Row(
                              mainAxisAlignment: .center,
                              mainAxisSize: .min,
                              spacing: 16,
                            children: [
                              CircularProgressIndicator(),
                          
                              Text(
                                AppLocalizations.of(context)!.loading,
                                style: TextStyle(fontWeight: .bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
