import 'dart:io';

import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:system_tray/system_tray.dart';

final AppWindow appWindow = AppWindow();
final SystemTray systemTray = SystemTray();

void hideOrClose() {
  if (ConfigProvider().config.systemTrayUsage == SystemTrayUsage.never) {
    appWindow.close();
  } else if (ConfigProvider().config.systemTrayUsage ==
      SystemTrayUsage.always) {
    appWindow.hide();
  } else {
    if (PlayerService().playingFile != null && PlayerService().isPlaying) {
      appWindow.hide();
    } else {
      appWindow.close();
    }
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
        ? (menuItem) => PlayerService().play()
        : (menuItem) => PlayerService().pause(),
  );

  var options = [playPauseMenuOption, ...persistentMenuOptions];

  final Menu menu = Menu();
  await menu.buildFrom(options);

  await systemTray.setContextMenu(menu);
  await systemTray.setToolTip(
    playing ? "FL audiobook playing${PlayerService().title}" : "FL audiobook" 
  );
}

Future<void> initSystemTray() async {
  String path = Platform.isWindows
      ? 'assets/app_icon.ico'
      : 'images/app_icon.png';

  // We first init the systray menu
  await systemTray.initSystemTray(title: "system tray", toolTip: "FL audiobook", iconPath: path);

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
    // debugPrint("eventName: $eventName");
    if (eventName == kSystemTrayEventClick) {
      Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
    } else if (eventName == kSystemTrayEventRightClick) {
      Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
    }
  });
}
