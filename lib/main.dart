import 'dart:async';
import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/home.dart';
import 'package:fl_audiobook/media_player2.dart';
import 'package:fl_audiobook/model.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/tray.dart';
import 'package:flutter/foundation.dart';

import 'package:media_kit/media_kit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:watch_it/watch_it.dart';
import 'package:xdg_directories/xdg_directories.dart';

import 'package:yaru/yaru.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging/logging.dart';

final log = Logger('main');
// Provides [Player], [Media], [Playlist] etc.
Future<void> main() async {
  MediaKit.ensureInitialized();
  PlayerService().ensureInitialized();
  await YaruWindowTitleBar.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();
  await Directory("${dataHome.path}/${globals.APP_DIR}")
      .create(recursive: true);
  di
    ..registerLazySingleton<Connectivity>(Connectivity.new)
    ..registerLazySingleton<Model>(
      () => Model(di<Connectivity>()),
      dispose: (m) => m.dispose(),
    );

  await di<Model>().init();

  // if (kDebugMode) {
    Logger.root.level = Level.INFO;
  // } else {
  //   Logger.root.level = Level.SEVERE;
  // }
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name} ${record.time} ${record.loggerName}: ${record.message}');
  });

  var client = DBusClient.session(introspectable: true);

  client.nameAcquired.listen((event) {
    log.info("DBus Name aquired: $event");
  });


  // client.nameOwnerChanged.listen((event) {
  //   print("chng ${event.name} ${event.oldOwner} -> ${event.newOwner}");
  // });

  globals.mediaPlayer2.ensureInitialized(); 

  // var a =  MediaPlayer2(DBusObjectPath.unchecked("/org/mpris/MediaPlayer2"));
  // var a =  MediaPlayer2(DBusObjectPath.unchecked("/org/mpris/MediaPlayer2"));

  await client.registerObject(globals.mediaPlayer2);
  await client.requestName('org.mpris.MediaPlayer2.fl-audiobook');
  // client.emitSignal('org.freedesktop.DBus.ObjectManager', 'InterfacesAdded',
  //       [path, encodeInterfacesAndProperties(interfacesAndProperties)])

  // await client.registerObject(wrappedplayerInterface);

  // print( await client.listActivatableNames());




  var count = 0;
  // Timer.periodic(Duration(seconds: 1), (timer) {
  //   print('Ping $count!');
  //   dbusObject.emitSignal('com.canonical.DBusDart', 'Ping', [DBusUint64(count)]);
  //   count++;
  // });

  // globals.mediaPlayer2.emitPropertiesChanged(
  //   "org.mpris.MediaPlayer2",
  //   changedProperties: {},
  //   invalidatedProperties: [],
  // );

  // client.callMethod(path: DBusObjectPath("/org/freedesktop/DBus"), name: )

  PlayerService().isPlayingStream.listen((playing) {
    //print("hi");

    setSytemTrayCanPlayPause(playing);
  });

  runApp(const ExampleHome());
  await initSystemTray();
}
