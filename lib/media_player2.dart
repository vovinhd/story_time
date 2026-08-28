// ignore_for_file: non_constant_identifier_names

import "package:dbus/dbus.dart";
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/time_display.dart';

class MediaPlayer2 extends DBusObject {
  MediaPlayer2({
    DBusObjectPath path = const DBusObjectPath.unchecked(
      '/org/mpris/MediaPlayer2',
    ),
  }) : super(path);

  Future<DBusMethodResponse> getCanQuit() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanRaise
  Future<DBusMethodResponse> getCanRaise() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  Future<DBusMethodResponse> getIdentity() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusString("fl_audiobook"))]);
  }

  Future<DBusMethodResponse> doRaise() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  Future<DBusMethodResponse> doQuit() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPlay() async {
    await globals.playerService.play();

    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPause() async {
    await globals.playerService.pause();

    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.PlayPause()
  Future<DBusMethodResponse> doPlayPause() async {
    await globals.playerService.playOrPause();
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Stop()
  Future<DBusMethodResponse> doStop() async {
    // await globals.player.stop();

    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  Future<DBusMethodResponse> doSeek(int Offset) async {
    globals.playerService.seek(
      Duration(
        microseconds: Offset + globals.playerService.position.inMicroseconds,
      ),
    );
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.SetPosition()
  Future<DBusMethodResponse> doSetPosition(
    DBusObjectPath TrackId,
    int Position,
  ) async {
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Emits signal org.mpris.MediaPlayer2.Player.Seeked
  Future<void> emitSeeked(int Position) async {
    await emitSignal('org.mpris.MediaPlayer2.Player', 'Seeked', [
      DBusInt64(Position),
    ]);
  }

  Future<DBusMethodResponse> getPlaybackStatus() async {
    final status = !globals.playerService.ready
        ? "Stopped"
        : globals.playerService.isPlaying
        ? "Playing"
        : "Paused";
    return DBusMethodSuccessResponse([DBusVariant(DBusString(status))]);
  }

  Future<DBusMethodResponse> getPosition() async {
    final time = timeInChapter(globals.playerService.position).inMicroseconds;

    return DBusMethodSuccessResponse([DBusVariant(DBusInt64(time))]);
  }

  Future<DBusMethodResponse> getLoopStatus() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusString("Track"))]);
  }

  Future<DBusMethodResponse> setLoopStatus(String status) async {
    return DBusMethodSuccessResponse([DBusVariant(DBusString("Track"))]);
  }

  Future<DBusMethodResponse> getCanControl() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  Future<DBusMethodResponse> getCanPause() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanSeek
  Future<DBusMethodResponse> getCanSeek() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPlay
  Future<DBusMethodResponse> getCanPlay() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(true))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MinimumRate
  Future<DBusMethodResponse> getMinimumRate() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusDouble(0.5))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MaximumRate
  Future<DBusMethodResponse> getMaximumRate() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusDouble(2.0))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> getRate() async {
    final rate = globals.playerService.rate;
    return DBusMethodSuccessResponse([DBusVariant(DBusDouble(rate))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> setRate(double rate) async {
    globals.playerService.rate = rate;
    return DBusMethodSuccessResponse([DBusVariant(DBusDouble(rate))]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> getVolume() async {
    return DBusMethodSuccessResponse([DBusVariant(DBusDouble(1.0))]);
  }

  Future<Map<DBusString, DBusVariant>?> buildMetadata() async{
    if (globals.playerService.playingFile == null) {
      return null;
    }

    final tags = globals.playerService.tags;
    final currentChapterInfo = globals.playerService.currentChapter!;

    final title = currentChapterInfo.title;
    final List<String> artist = [tags["artist"]] ;
    final album = tags["album"] ?? "";

    final length = currentChapterInfo.duration.inMicroseconds; 
    final fileUrl = "file://${globals.playerService.playingFile!.path}";
    final artUrl = "file://${(await globals.playerService.playingFile!.coverImage)?.path}";

    Map<DBusString, DBusVariant> metadata = {
      // idk
      DBusString("mpris:trackid"): DBusVariant(
        DBusObjectPath(
          "/io/github/fl_audiobook/book/${globals.playerService.playingFile!.name.hashCode}",
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
    return DBusMethodSuccessResponse([DBusVariant(DBusDouble(1.0))]);
  }

  Future<DBusMethodResponse> getMetadata() async {
    final metadata = await buildMetadata();

    if (metadata == null) {
      return DBusMethodSuccessResponse([
        DBusVariant(DBusDict(DBusSignature.string, DBusSignature.variant, {})),
      ]);
    } else {
      return DBusMethodSuccessResponse([
        DBusVariant(
          DBusDict(DBusSignature.string, DBusSignature.variant, metadata),
        ),
      ]);
    }
    //
  }

  @override
  List<DBusIntrospectInterface> introspect() {
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
          DBusArray(DBusSignature.string, [DBusString("audio/m4b")]),
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
        return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(false))]);
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
        return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(false))]);
      } else if (name == 'CanGoPrevious') {
        return DBusMethodSuccessResponse([DBusVariant(DBusBoolean(false))]);
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
      return DBusMethodErrorResponse.unknownInterface();
    }

    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }

  @override
  Future<DBusMethodResponse> setProperty(
    String interface,
    String name,
    DBusValue value,
  ) async {
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
