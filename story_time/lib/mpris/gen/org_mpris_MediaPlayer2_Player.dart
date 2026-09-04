// This file was generated using the following command and may be overwritten.
// dart-dbus generate-object org.mpris.MediaPlayer2.Player.xml

import 'package:dbus/dbus.dart';

class Player_Interface extends DBusObject {
  /// Creates a new object to expose on [path].
  Player_Interface({DBusObjectPath path = const DBusObjectPath.unchecked('/Player_Interface')}) : super(path);

  /// Gets value of property org.mpris.MediaPlayer2.Player.PlaybackStatus
  Future<DBusMethodResponse> getPlaybackStatus() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.PlaybackStatus not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> getLoopStatus() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.LoopStatus not implemented');
  }

  /// Sets property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> setLoopStatus(String value) async {
    return DBusMethodErrorResponse.failed('Set org.mpris.MediaPlayer2.Player.LoopStatus not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> getRate() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.Rate not implemented');
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> setRate(double value) async {
    return DBusMethodErrorResponse.failed('Set org.mpris.MediaPlayer2.Player.Rate not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Shuffle
  Future<DBusMethodResponse> getShuffle() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.Shuffle not implemented');
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Shuffle
  Future<DBusMethodResponse> setShuffle(bool value) async {
    return DBusMethodErrorResponse.failed('Set org.mpris.MediaPlayer2.Player.Shuffle not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Metadata
  Future<DBusMethodResponse> getMetadata() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.Metadata not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> getVolume() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.Volume not implemented');
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> setVolume(double value) async {
    return DBusMethodErrorResponse.failed('Set org.mpris.MediaPlayer2.Player.Volume not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Position
  Future<DBusMethodResponse> getPosition() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.Position not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MinimumRate
  Future<DBusMethodResponse> getMinimumRate() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.MinimumRate not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MaximumRate
  Future<DBusMethodResponse> getMaximumRate() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.MaximumRate not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoNext
  Future<DBusMethodResponse> getCanGoNext() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.CanGoNext not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoPrevious
  Future<DBusMethodResponse> getCanGoPrevious() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.CanGoPrevious not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPlay
  Future<DBusMethodResponse> getCanPlay() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.CanPlay not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPause
  Future<DBusMethodResponse> getCanPause() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.CanPause not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanSeek
  Future<DBusMethodResponse> getCanSeek() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.CanSeek not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanControl
  Future<DBusMethodResponse> getCanControl() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Player.CanControl not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Next()
  Future<DBusMethodResponse> doNext() async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Player.Next() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Previous()
  Future<DBusMethodResponse> doPrevious() async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Player.Previous() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPause() async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Player.Pause() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.PlayPause()
  Future<DBusMethodResponse> doPlayPause() async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Player.PlayPause() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Stop()
  Future<DBusMethodResponse> doStop() async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Player.Stop() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Play()
  Future<DBusMethodResponse> doPlay() async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Player.Play() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Seek()
  Future<DBusMethodResponse> doSeek(int Offset) async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Player.Seek() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.SetPosition()
  Future<DBusMethodResponse> doSetPosition(DBusObjectPath TrackId, int Position) async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Player.SetPosition() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.OpenUri()
  Future<DBusMethodResponse> doOpenUri(String Uri) async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Player.OpenUri() not implemented');
  }

  /// Emits signal org.mpris.MediaPlayer2.Player.Seeked
  Future<void> emitSeeked(int Position) async {
     await emitSignal('org.mpris.MediaPlayer2.Player', 'Seeked', [DBusInt64(Position)]);
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [DBusIntrospectInterface('org.mpris.MediaPlayer2.Player', methods: [DBusIntrospectMethod('Next'), DBusIntrospectMethod('Previous'), DBusIntrospectMethod('Pause'), DBusIntrospectMethod('PlayPause'), DBusIntrospectMethod('Stop'), DBusIntrospectMethod('Play'), DBusIntrospectMethod('Seek', args: [DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_, name: 'Offset')]), DBusIntrospectMethod('SetPosition', args: [DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_, name: 'TrackId'), DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_, name: 'Position')]), DBusIntrospectMethod('OpenUri', args: [DBusIntrospectArgument(DBusSignature('s'), DBusArgumentDirection.in_, name: 'Uri')])], signals: [DBusIntrospectSignal('Seeked', args: [DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.out, name: 'Position')])], properties: [DBusIntrospectProperty('PlaybackStatus', DBusSignature('s'), access: DBusPropertyAccess.read), DBusIntrospectProperty('LoopStatus', DBusSignature('s'), access: DBusPropertyAccess.readwrite), DBusIntrospectProperty('Rate', DBusSignature('d'), access: DBusPropertyAccess.readwrite), DBusIntrospectProperty('Shuffle', DBusSignature('b'), access: DBusPropertyAccess.readwrite), DBusIntrospectProperty('Metadata', DBusSignature('a{sv}'), access: DBusPropertyAccess.read), DBusIntrospectProperty('Volume', DBusSignature('d'), access: DBusPropertyAccess.readwrite), DBusIntrospectProperty('Position', DBusSignature('x'), access: DBusPropertyAccess.read), DBusIntrospectProperty('MinimumRate', DBusSignature('d'), access: DBusPropertyAccess.read), DBusIntrospectProperty('MaximumRate', DBusSignature('d'), access: DBusPropertyAccess.read), DBusIntrospectProperty('CanGoNext', DBusSignature('b'), access: DBusPropertyAccess.read), DBusIntrospectProperty('CanGoPrevious', DBusSignature('b'), access: DBusPropertyAccess.read), DBusIntrospectProperty('CanPlay', DBusSignature('b'), access: DBusPropertyAccess.read), DBusIntrospectProperty('CanPause', DBusSignature('b'), access: DBusPropertyAccess.read), DBusIntrospectProperty('CanSeek', DBusSignature('b'), access: DBusPropertyAccess.read), DBusIntrospectProperty('CanControl', DBusSignature('b'), access: DBusPropertyAccess.read)])];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'org.mpris.MediaPlayer2.Player') {
      if (methodCall.name == 'Next') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doNext();
      } else if (methodCall.name == 'Previous') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPrevious();
      } else if (methodCall.name == 'Pause') {
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
        return doSetPosition(methodCall.values[0].asObjectPath(), methodCall.values[1].asInt64());
      } else if (methodCall.name == 'OpenUri') {
        if (methodCall.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doOpenUri(methodCall.values[0].asString());
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return getPlaybackStatus();
      } else if (name == 'LoopStatus') {
        return getLoopStatus();
      } else if (name == 'Rate') {
        return getRate();
      } else if (name == 'Shuffle') {
        return getShuffle();
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
        return getCanGoNext();
      } else if (name == 'CanGoPrevious') {
        return getCanGoPrevious();
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
  Future<DBusMethodResponse> setProperty(String interface, String name, DBusValue value) async {
    if (interface == 'org.mpris.MediaPlayer2.Player') {
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
        return setShuffle(value.asBoolean());
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
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    var properties = <String, DBusValue>{};
    if (interface == 'org.mpris.MediaPlayer2.Player') {
      properties['PlaybackStatus'] = (await getPlaybackStatus()).returnValues[0];
      properties['LoopStatus'] = (await getLoopStatus()).returnValues[0];
      properties['Rate'] = (await getRate()).returnValues[0];
      properties['Shuffle'] = (await getShuffle()).returnValues[0];
      properties['Metadata'] = (await getMetadata()).returnValues[0];
      properties['Volume'] = (await getVolume()).returnValues[0];
      properties['Position'] = (await getPosition()).returnValues[0];
      properties['MinimumRate'] = (await getMinimumRate()).returnValues[0];
      properties['MaximumRate'] = (await getMaximumRate()).returnValues[0];
      properties['CanGoNext'] = (await getCanGoNext()).returnValues[0];
      properties['CanGoPrevious'] = (await getCanGoPrevious()).returnValues[0];
      properties['CanPlay'] = (await getCanPlay()).returnValues[0];
      properties['CanPause'] = (await getCanPause()).returnValues[0];
      properties['CanSeek'] = (await getCanSeek()).returnValues[0];
      properties['CanControl'] = (await getCanControl()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}
