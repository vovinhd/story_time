import 'dart:ui';

import 'package:fl_audiobook/l10n/app_localizations.dart';
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
        decoration: menuBoxDecoration(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextButton(
                style: menuButtonStyle(context),

                onPressed: () async {
                  try {
                    if (await pickFile()) {

                      // TODO known problem: if the menu is closed before a book is selected the widget is unmounted and navigation is blocked
                      if (mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => PlayerPage(),
                          ),
                        );
                      }
                    }
                  } on Exception catch (e) {
                    
                    var errorMsg = e.toString();
                    // print("hiiii" + errorMsg);
                    var snackBar = SnackBar(content: Text(errorMsg));

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } finally {
                    widget.close();
                  }
                },
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.menuOpen, style: menuButtonTextStyle(context)),
                    Text(
                      AppLocalizations.of(context)!.menuOpenAccelerator,
                      style: menuButtonAcceleratorTextStyle(context),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: menuButtonStyle(context),

                onPressed: () {
                  Navigator.of(context).push(
                    SettingsTransition(child: SettingsPage()),
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
                    Text(AppLocalizations.of(context)!.menuSettings, style: menuButtonTextStyle(context)),
                    Text(
                      AppLocalizations.of(context)!.menuOpenAccelerator,
                      style: menuButtonAcceleratorTextStyle(context),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: menuButtonStyle(context),
                onPressed: () {
                  widget.close();
                  showAboutDialog(
                    context: context,
                    applicationVersion: "0.1.0", //TODO localize this
                    applicationIcon: Image.asset("images/app_icon.png"),
                    applicationLegalese: "This software is very cool.",
                    useRootNavigator: true,
                  );
                },
                child: Row(
                  mainAxisAlignment: .spaceBetween,

                  children: [
                    Text(
                      AppLocalizations.of(context)!.menuAbout,
                      style: menuButtonTextStyle(context),
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

BoxDecoration menuBoxDecoration(BuildContext context) {
  return Theme.of(context).brightness == .dark
      ? menuBoxDecorationDark
      : menuBoxDecorationLight;
}

var menuBoxDecorationLight = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  color: YaruColors.porcelain,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      spreadRadius: 1,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],
);

var menuBoxDecorationDark = BoxDecoration(
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

ButtonStyle menuButtonStyle(context) {
  return Theme.of(context).brightness == .dark
      ? ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.white10))
      : ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.black12));
}

TextStyle menuButtonTextStyle(context) {
  return Theme.of(context).brightness == .dark
      ? TextStyle(color: YaruColors.porcelain, fontSize: 14)
      : TextStyle(color: YaruColors.textGrey, fontSize: 14);
}

TextStyle menuButtonAcceleratorTextStyle(context) {
  return Theme.of(context).brightness == .dark
      ? TextStyle(color: YaruColors.warmGrey, fontSize: 12)
      : TextStyle(color: YaruColors.adwaitaSlate, fontSize: 12);
}
