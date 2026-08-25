import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:system_tray/system_tray.dart';

import "globals.dart" as globals;

final AppWindow appWindow = AppWindow();
final SystemTray systemTray = SystemTray();

void hideOrClose() {
  if (globals.playingFile != null) {
    appWindow.hide();
  } else {
    appWindow.close();
  }
}

final persistentMenuOptions = [
  MenuItemLabel(label: 'Show', onClicked: (menuItem) => appWindow.show()),
  MenuItemLabel(label: 'Hide', onClicked: (menuItem) => appWindow.hide()),
  MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
];

Future<void> setSytemTrayCanPlayPause(bool playing) async {
  var playPauseMenuOption = MenuItemLabel(
    image: !playing ? "images/play.png" : "images/pause.png",
    label: !playing ? 'Play' : 'Pause',
    onClicked: !playing
        ? (menuItem) => globals.player.play()
        : (menuItem) => globals.player.pause(),
  );

  var options = [playPauseMenuOption, ...persistentMenuOptions];

  final Menu menu = Menu();
  await menu.buildFrom(options);

  await systemTray.setContextMenu(menu);
}

Future<void> initSystemTray() async {
  String path = Platform.isWindows
      ? 'assets/app_icon.ico'
      : 'images/app_icon.png';

  // We first init the systray menu
  await systemTray.initSystemTray(title: "system tray", iconPath: path);

  // create context menu
  final Menu menu = Menu();
  await menu.buildFrom([
    MenuItemLabel(label: 'Show', onClicked: (menuItem) => appWindow.show()),
    MenuItemLabel(label: 'Hide', onClicked: (menuItem) => appWindow.hide()),
    MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
  ]);

  // set context menu
  await systemTray.setContextMenu(menu);

  // handle system tray event
  systemTray.registerSystemTrayEventHandler((eventName) {
    debugPrint("eventName: $eventName");
    if (eventName == kSystemTrayEventClick) {
      Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
    } else if (eventName == kSystemTrayEventRightClick) {
      Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
    }
  });
}
