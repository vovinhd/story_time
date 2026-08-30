import 'dart:ui';

import 'package:fl_audiobook/my_route_transition.dart';
import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/services/files.dart';
import 'package:fl_audiobook/routes/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class PopoverMenu extends StatefulWidget {
  const new({super.key, required this.close});

  final VoidCallback close;

  @override
  State<PopoverMenu> createState() => _PopoverMenuState();
}

class _PopoverMenuState extends State<PopoverMenu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Container(
        decoration: menuBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextButton(
                onPressed: () async {
                  if (await pickFile()) {
                    print("check mounted");

                    // TODO known problem: if the menu is closed before a book is selected the widget is unmounted and navigation is blocked
                    // TODO resume playback if user picked an audiobook they already have played
                    if (mounted) {
                      print("navigating to player");
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => PlayerPage(),
                        ),
                      );
                    }
                  }
                  widget.close();
                },
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      "Open",
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                    Text(
                      "Ctrl+O",
                      style: Theme.of(context).primaryTextTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    SettingsTransition(child: SettingsPage())
                    // MaterialPageRoute<void>(
                    //   builder: (context) => SettingsPage(),
                    //   fullscreenDialog: true,

                    // ),
                  );

                  widget.close();
                },
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      "Settings",
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                    Text(
                      "Ctrl+,",
                      style: Theme.of(context).primaryTextTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.close();
                  showAboutDialog(
                    context: context,
                    applicationVersion: "0.1.0",
                    applicationIcon: Image.asset("images/app_icon.png"),
                    applicationLegalese: "This software is very cool.",
                    useRootNavigator: true
                  );
                },
                child: Row(
                  mainAxisAlignment: .spaceBetween,

                  children: [
                    Text(
                      "About fl_audiobook",
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var menuBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  color: YaruColors.inkstone,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      spreadRadius: 1,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],
);
