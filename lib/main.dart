import 'dart:async';
import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/home.dart';
import 'package:fl_audiobook/media_player2.dart';
import 'package:fl_audiobook/model.dart';

import 'package:media_kit/media_kit.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:watch_it/watch_it.dart';
import 'package:xdg_directories/xdg_directories.dart';

import 'package:yaru/yaru.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Provides [Player], [Media], [Playlist] etc.

Future<void> main() async {
  MediaKit.ensureInitialized();
  await FFmpegKitExtended.initialize();
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

  var client = DBusClient.session(introspectable: true);

  client.nameAcquired.listen((event) {
    print("DBus Name aquired: " + event);
  });


  // client.nameOwnerChanged.listen((event) {
  //   print("chng ${event.name} ${event.oldOwner} -> ${event.newOwner}");
  // });

  await client.requestName('org.mpris.MediaPlayer2.fl_audiobook');
  await client.registerObject(globals.mediaPlayer2);
  // client.emitSignal('org.freedesktop.DBus.ObjectManager', 'InterfacesAdded',
  //       [path, encodeInterfacesAndProperties(interfacesAndProperties)])

  // await client.registerObject(wrappedplayerInterface);

  var count = 0;
  // Timer.periodic(Duration(seconds: 1), (timer) {
  //   print('Ping $count!');
  //   dbusObject.emitSignal('com.canonical.DBusDart', 'Ping', [DBusUint64(count)]);
  //   count++;
  // });

  globals.mediaPlayer2.emitPropertiesChanged(
    "org.mpris.MediaPlayer2", 
    changedProperties: {

    }, 
    invalidatedProperties: []
  );


  // client.callMethod(path: DBusObjectPath("/org/freedesktop/DBus"), name: )

  
  globals.player.stream.playing.listen((playing) {
    //print("hi");
    globals.mediaPlayer2.emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "PlaybackStatus": DBusString(playing ? "Playing" : "Paused"),
      },
      invalidatedProperties: ["PlaybackStatus"],
    );
  });

  runApp(const ExampleHome());
}
