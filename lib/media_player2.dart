// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import "package:dbus/dbus.dart";
import 'package:fl_audiobook/services/player_service.dart';
import 'package:logging/logging.dart';
import 'package:system_tray/system_tray.dart';

final _log = Logger('MPRIS');
final AppWindow appWindow = AppWindow();

class MediaPlayer2 extends DBusObject {
  MediaPlayer2({
    DBusObjectPath path = const DBusObjectPath.unchecked(
      '/org/mpris/MediaPlayer2',
    ),
  }) : super(path);

  void ensureInitialized() {
    PlayerService().selectedBookStream.stream.listen((book) async {
      final metadata = await buildMetadata();

      if (metadata != null) {
        final metadataDBusMessage = DBusVariant(
          DBusDict(DBusSignature.string, DBusSignature.variant, metadata),
        );

        emitPropertiesChanged(
          "org.mpris.MediaPlayer2.Player",
          changedProperties: {
            "PlaybackStatus": DBusString(
              PlayerService().isPlaying ? "Playing" : "Paused",
            ),
            "Metadata": metadataDBusMessage,
          },
          invalidatedProperties: ["PlaybackStatus", "Metadata"],
        );
      }
    });

    PlayerService().isPlayingStream.listen((playing) {
      print("emit playing $playing");
      emitPropertiesChanged(
        "org.mpris.MediaPlayer2.Player",
        changedProperties: {
          "PlaybackStatus": DBusString(playing ? "Playing" : "Paused"),
        },
        invalidatedProperties: ["PlaybackStatus"],
      );
    });

    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   if (PlayerService().isPlaying) {
    //     final time = PlayerService().timeInChapter.inMicroseconds;
    //     print("emit position ${time}");
    //     emitPropertiesChanged(
    //       "org.mpris.MediaPlayer2.Player",
    //       changedProperties: {"Position": DBusInt64(time)},
    //       invalidatedProperties: ["Position"],
    //     );
    //     // }
    //   }
    // });

    PlayerService().seekStream.stream.listen((seeked) {
      final time = PlayerService().timeInChapter.inMicroseconds;

      emitSeeked(time);
    });
  }

  Future<DBusMethodResponse> getCanQuit() async {
    return DBusMethodSuccessResponse([DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanRaise
  Future<DBusMethodResponse> getCanRaise() async {
    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  Future<DBusMethodResponse> getIdentity() async {
    return DBusMethodSuccessResponse([
      (DBusString("org.mpris.MediaPlayer2.fl_audiobook")),
    ]);
  }

  Future<DBusMethodResponse> doRaise() async {
    appWindow.show();
    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  Future<DBusMethodResponse> doQuit() async {
    appWindow.close();
    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPlay() async {
    await PlayerService().playOrPause();

    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPause() async {
    await PlayerService().playOrPause();

    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.PlayPause()
  Future<DBusMethodResponse> doPlayPause() async {
    await PlayerService().playOrPause();
    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Stop()
  Future<DBusMethodResponse> doStop() async {
    // await globals.player.stop();

    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  Future<DBusMethodResponse> doSeek(int Offset) async {
    PlayerService().seek(
      Duration(microseconds: Offset + PlayerService().position.inMicroseconds),
    );
    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.SetPosition()
  Future<DBusMethodResponse> doSetPosition(
    DBusObjectPath TrackId,
    int Position,
  ) async {
    PlayerService().seekInChapter(Duration(microseconds: Position));
    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  /// Emits signal org.mpris.MediaPlayer2.Player.Seeked
  Future<void> emitSeeked(int Position) async {
    final time = PlayerService().timeInChapter.inMicroseconds;

    await emitSignal('org.mpris.MediaPlayer2.Player', 'Seeked', [
      DBusInt64(time),
    ]);
  }

  Future<DBusMethodResponse> getPlaybackStatus() async {
    final status = !PlayerService().ready
        ? "Stopped"
        : PlayerService().isPlaying
        ? "Playing"
        : "Paused";
    return DBusMethodSuccessResponse([(DBusString(status))]);
  }

  Future<DBusMethodResponse> getPosition() async {
    if (!PlayerService().ready) {
      return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(false))]);
    }
    final time = PlayerService().timeInChapter.inMicroseconds;

    _log.info("get position ${Duration(microseconds: time).inSeconds}");

    return DBusMethodSuccessResponse([DBusVariant(DBusInt64(time))]);
  }

  Future<DBusMethodResponse> getLoopStatus() async {
    return DBusMethodSuccessResponse([(DBusString("None"))]);
  }

  Future<DBusMethodResponse> setLoopStatus(String status) async {
    return DBusMethodSuccessResponse([(DBusString("None"))]);
  }

  Future<DBusMethodResponse> getCanControl() async {
    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  Future<DBusMethodResponse> getCanPause() async {
    return DBusMethodSuccessResponse([(DBusBoolean(PlayerService().ready))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanSeek
  Future<DBusMethodResponse> getCanSeek() async {
    return DBusMethodSuccessResponse([(DBusBoolean(true))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPlay
  Future<DBusMethodResponse> getCanPlay() async {
    return DBusMethodSuccessResponse([(DBusBoolean(PlayerService().ready))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MinimumRate
  Future<DBusMethodResponse> getMinimumRate() async {
    return DBusMethodSuccessResponse([(DBusDouble(0.5))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MaximumRate
  Future<DBusMethodResponse> getMaximumRate() async {
    return DBusMethodSuccessResponse([(DBusDouble(2.0))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> getRate() async {
    final rate = PlayerService().rate;
    return DBusMethodSuccessResponse([(DBusDouble(rate))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> setRate(double rate) async {
    PlayerService().rate = rate;
    return DBusMethodSuccessResponse([(DBusDouble(rate))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> getVolume() async {
    double volume = PlayerService().volume;
    return DBusMethodSuccessResponse([(DBusDouble(volume))]);
  }

  Future<Map<DBusString, DBusVariant>?> buildMetadata() async {
    if (PlayerService().playingFile == null) {
      return null;
    }

    final tags = PlayerService().tags;
    final currentChapterInfo = PlayerService().currentChapter!;

    final title = currentChapterInfo.title;
    final List<String> artist = [tags["artist"]];
    final album = tags["album"] ?? "";

    final length = currentChapterInfo.duration.inMicroseconds;
    final fileUrl = "file://${PlayerService().playingFile!.path}";
    final artUrl =
        "file://${(await PlayerService().playingFile!.coverImage)?.path}";

    Map<DBusString, DBusVariant> metadata = {
      // idk
      DBusString("mpris:trackid"): DBusVariant(
        DBusObjectPath(
          "/io/github/fl_audiobook/book/${PlayerService().playingFile!.name.hashCode}",
        ),
      ),

      // book info
      DBusString("xesam:title"): DBusVariant(DBusString(title)),
      DBusString("xesam:artist"): DBusVariant(
        DBusArray(
          DBusSignature.string,
          artist.map((artist) => DBusString(artist)),
        ),
      ),
      DBusString("xesam:album"): DBusVariant(DBusString(album)),

      // chapter info
      DBusString("mpris:length"): DBusVariant(DBusInt64(length)),

      // file system info
      DBusString("xesam:url"): DBusVariant(DBusString(fileUrl)),
      DBusString("mpris:artUrl"): DBusVariant(DBusString(artUrl)),
    };
    return metadata;
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> setVolume(double value) async {
    PlayerService().volume = value;
    return DBusMethodSuccessResponse([(DBusDouble(value))]);
  }

  Future<DBusMethodResponse> getMetadata() async {
    final metadata = await buildMetadata();

    if (metadata == null) {
      return DBusMethodSuccessResponse([
        (DBusDict(DBusSignature.string, DBusSignature.variant, {})),
      ]);
    } else {
      return DBusMethodSuccessResponse([
        DBusDict(DBusSignature.string, DBusSignature.variant, metadata),
      ]);
    }
    //
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    _log.info("introspected!");

    return [
      DBusIntrospectInterface(
        'org.mpris.MediaPlayer2',
        methods: [DBusIntrospectMethod('Raise'), DBusIntrospectMethod('Quit')],
        properties: [
          DBusIntrospectProperty(
            'CanQuit',
            DBusSignature('b'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'Fullscreen',
            DBusSignature('b'),
            access: DBusPropertyAccess.readwrite,
          ),
          DBusIntrospectProperty(
            'CanSetFullscreen',
            DBusSignature('b'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'CanRaise',
            DBusSignature('b'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'HasTrackList',
            DBusSignature('b'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'Identity',
            DBusSignature('s'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'DesktopEntry',
            DBusSignature('s'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'SupportedUriSchemes',
            DBusSignature('as'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'SupportedMimeTypes',
            DBusSignature('as'),
            access: DBusPropertyAccess.read,
          ),
        ],
      ),
      DBusIntrospectInterface(
        'org.mpris.MediaPlayer2.Player',
        methods: [
          // DBusIntrospectMethod('Next'),
          // DBusIntrospectMethod('Previous'),
          DBusIntrospectMethod('Pause'),
          DBusIntrospectMethod('PlayPause'),
          DBusIntrospectMethod('Stop'),
          DBusIntrospectMethod('Play'),
          DBusIntrospectMethod(
            'Seek',
            args: [
              DBusIntrospectArgument(
                DBusSignature('x'),
                DBusArgumentDirection.in_,
                name: 'Offset',
              ),
            ],
          ),
          DBusIntrospectMethod(
            'SetPosition',
            args: [
              DBusIntrospectArgument(
                DBusSignature('o'),
                DBusArgumentDirection.in_,
                name: 'TrackId',
              ),
              DBusIntrospectArgument(
                DBusSignature('x'),
                DBusArgumentDirection.in_,
                name: 'Position',
              ),
            ],
          ),
        ],
        signals: [
          DBusIntrospectSignal(
            'Seeked',
            args: [
              DBusIntrospectArgument(
                DBusSignature('x'),
                DBusArgumentDirection.out,
                name: 'Position',
              ),
            ],
          ),
        ],
        properties: [
          DBusIntrospectProperty(
            'PlaybackStatus',
            DBusSignature('s'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'LoopStatus',
            DBusSignature('s'),
            access: DBusPropertyAccess.readwrite,
          ),
          DBusIntrospectProperty(
            'Rate',
            DBusSignature('d'),
            access: DBusPropertyAccess.readwrite,
          ),
          DBusIntrospectProperty(
            'Metadata',
            DBusSignature('a{sv}'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'Volume',
            DBusSignature('d'),
            access: DBusPropertyAccess.readwrite,
          ),
          DBusIntrospectProperty(
            'Position',
            DBusSignature('x'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'MinimumRate',
            DBusSignature('d'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'MaximumRate',
            DBusSignature('d'),
            access: DBusPropertyAccess.read,
          ),
          // DBusIntrospectProperty(
          //   'CanGoNext',
          //   DBusSignature('b'),
          //   access: DBusPropertyAccess.read,
          // ),
          // DBusIntrospectProperty(
          //   'CanGoPrevious',
          //   DBusSignature('b'),
          //   access: DBusPropertyAccess.read,
          // ),
          DBusIntrospectProperty(
            'CanPlay',
            DBusSignature('b'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'CanPause',
            DBusSignature('b'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'CanSeek',
            DBusSignature('b'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'CanControl',
            DBusSignature('b'),
            access: DBusPropertyAccess.read,
          ),
        ],
      ),
    ];
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    _log.info("getProperty: $interface : $name");
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return getCanQuit();
      } else if (name == 'Fullscreen') {
        return DBusGetPropertyResponse(DBusBoolean(false));
      } else if (name == 'CanSetFullscreen') {
        return DBusGetPropertyResponse(DBusBoolean(false));
      } else if (name == 'CanRaise') {
        return getCanRaise();
      } else if (name == 'HasTrackList') {
        return DBusGetPropertyResponse(DBusBoolean(false));
      } else if (name == 'Identity') {
        return getIdentity();
      } else if (name == 'DesktopEntry') {
        return DBusGetPropertyResponse(DBusString("fl_audiobook"));
      } else if (name == 'SupportedUriSchemes') {
        return DBusGetPropertyResponse(
          DBusArray(DBusSignature.string, [DBusString("file")]),
        );
      } else if (name == 'SupportedMimeTypes') {
        return DBusGetPropertyResponse(
          //['audio/mpeg', 'audio/x-mpeg', 'video/mpeg', 'video/x-mpeg', 'video/mpeg-system', 'video/x-mpeg-system', 'video/mp4', 'audio/mp4', 'video/x-msvideo', 'video/quicktime', 'application/ogg', 'application/x-ogg', 'video/x-ms-asf', 'video/x-ms-asf-plugin', 'application/x-mplayer2', 'video/x-ms-wmv', 'video/x-google-vlc-plugin', 'audio/wav', 'audio/x-wav', 'audio/3gpp', 'video/3gpp', 'audio/3gpp2', 'video/3gpp2', 'video/divx', 'video/flv', 'video/x-flv', 'video/x-matroska', 'audio/x-matroska', 'application/xspf+xml']

          DBusArray(DBusSignature.string, [
            DBusString("audio/mpeg"),
            DBusString("audio/m4a"),
            DBusString("audio/mp3"),
          ]),
        );
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return getPlaybackStatus();
      } else if (name == 'LoopStatus') {
        return getLoopStatus();
      } else if (name == 'Rate') {
        return getRate();
      } else if (name == 'Shuffle') {
        return DBusMethodSuccessResponse([(DBusBoolean(false))]);
      } else if (name == 'Metadata') {
        return getMetadata();
      } else if (name == 'Volume') {
        return getVolume();
      } else if (name == 'Position') {
        return getPosition();
      } else if (name == 'MinimumRate') {
        return getMinimumRate();
      } else if (name == 'MaximumRate') {
        return getMaximumRate();
      } else if (name == 'CanGoNext') {
        return DBusMethodSuccessResponse([(DBusBoolean(false))]);
      } else if (name == 'CanGoPrevious') {
        return DBusMethodSuccessResponse([(DBusBoolean(false))]);
      } else if (name == 'CanPlay') {
        return getCanPlay();
      } else if (name == 'CanPause') {
        return getCanPause();
      } else if (name == 'CanSeek') {
        return getCanSeek();
      } else if (name == 'CanControl') {
        return getCanControl();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    _log.info("getAllProperties: $interface");

    var properties = <String, DBusValue>{};
    if (interface == 'org.mpris.MediaPlayer2') {
      properties['CanQuit'] = (await getCanQuit()).returnValues[0];
      properties['CanRaise'] = (await getCanRaise()).returnValues[0];
      properties['Identity'] = (await getIdentity()).returnValues[0];
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      properties['PlaybackStatus'] =
          (await getPlaybackStatus()).returnValues[0];
      properties['LoopStatus'] = (await getLoopStatus()).returnValues[0];
      properties['Rate'] = (await getRate()).returnValues[0];
      properties['Metadata'] = (await getMetadata()).returnValues[0];
      properties['Volume'] = (await getVolume()).returnValues[0];
      properties['Position'] = (await getPosition()).returnValues[0];
      properties['MinimumRate'] = (await getMinimumRate()).returnValues[0];
      properties['MaximumRate'] = (await getMaximumRate()).returnValues[0];
      properties['CanPlay'] = (await getCanPlay()).returnValues[0];
      properties['CanPause'] = (await getCanPause()).returnValues[0];
      properties['CanSeek'] = (await getCanSeek()).returnValues[0];
      properties['CanControl'] = (await getCanControl()).returnValues[0];
    } else {
      _log.severe("interface ${interface} not found!");
      return DBusMethodErrorResponse.unknownInterface();
    }
    // _log.info("all properties response $properties");

    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }

  @override
  Future<DBusMethodResponse> setProperty(
    String interface,
    String name,
    DBusValue value,
  ) async {
    _log.info("setProperty: $interface : $name -> $value");

    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanSetFullscreen') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanRaise') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'HasTrackList') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Identity') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'DesktopEntry') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedUriSchemes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedMimeTypes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'LoopStatus') {
        if (value.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setLoopStatus(value.asString());
      } else if (name == 'Rate') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setRate(value.asDouble());
      } else if (name == 'Shuffle') {
        if (value.signature != DBusSignature('b')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return DBusMethodErrorResponse.unknownProperty();
      } else if (name == 'Metadata') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Volume') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setVolume(value.asDouble());
      } else if (name == 'Position') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MinimumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MaximumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoNext') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoPrevious') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPlay') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPause') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanSeek') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanControl') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    _log.info("handleMethodCall: ${methodCall.interface}::${methodCall.name}");

    if (methodCall.interface == 'org.mpris.MediaPlayer2') {
      if (methodCall.name == 'Raise') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doRaise();
      } else if (methodCall.name == 'Quit') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doQuit();
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else if (methodCall.interface == 'org.mpris.MediaPlayer2.Player') {
      if (methodCall.name == 'Pause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPause();
      } else if (methodCall.name == 'PlayPause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlayPause();
      } else if (methodCall.name == 'Stop') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doStop();
      } else if (methodCall.name == 'Play') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlay();
      } else if (methodCall.name == 'Seek') {
        if (methodCall.signature != DBusSignature('x')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSeek(methodCall.values[0].asInt64());
      } else if (methodCall.name == 'SetPosition') {
        if (methodCall.signature != DBusSignature('ox')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSetPosition(
          methodCall.values[0].asObjectPath(),
          methodCall.values[1].asInt64(),
        );
      }
    }
    return DBusMethodErrorResponse.unknownInterface();
  }
}
