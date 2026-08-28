// This file was generated using the following command and may be overwritten.
// dart-dbus generate-object org.mpris.MediaPlayer2.TrackList.xml

import 'package:dbus/dbus.dart';

class Track_List_Interface extends DBusObject {
  /// Creates a new object to expose on [path].
  Track_List_Interface({DBusObjectPath path = const DBusObjectPath.unchecked('/Track_List_Interface')}) : super(path);

  /// Gets value of property org.mpris.MediaPlayer2.TrackList.Tracks
  Future<DBusMethodResponse> getTracks() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.TrackList.Tracks not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.TrackList.CanEditTracks
  Future<DBusMethodResponse> getCanEditTracks() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.TrackList.CanEditTracks not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.TrackList.GetTracksMetadata()
  Future<DBusMethodResponse> doGetTracksMetadata(List<DBusObjectPath> TrackIds) async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.TrackList.GetTracksMetadata() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.TrackList.AddTrack()
  Future<DBusMethodResponse> doAddTrack(String Uri, DBusObjectPath AfterTrack, bool SetAsCurrent) async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.TrackList.AddTrack() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.TrackList.RemoveTrack()
  Future<DBusMethodResponse> doRemoveTrack(DBusObjectPath TrackId) async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.TrackList.RemoveTrack() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.TrackList.GoTo()
  Future<DBusMethodResponse> doGoTo(DBusObjectPath TrackId) async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.TrackList.GoTo() not implemented');
  }

  /// Emits signal org.mpris.MediaPlayer2.TrackList.TrackListReplaced
  Future<void> emitTrackListReplaced(List<DBusObjectPath> Tracks, DBusObjectPath CurrentTrack) async {
     await emitSignal('org.mpris.MediaPlayer2.TrackList', 'TrackListReplaced', [DBusArray.objectPath(Tracks), CurrentTrack]);
  }

  /// Emits signal org.mpris.MediaPlayer2.TrackList.TrackAdded
  Future<void> emitTrackAdded(Map<String, DBusValue> Metadata, DBusObjectPath AfterTrack) async {
     await emitSignal('org.mpris.MediaPlayer2.TrackList', 'TrackAdded', [DBusDict.stringVariant(Metadata), AfterTrack]);
  }

  /// Emits signal org.mpris.MediaPlayer2.TrackList.TrackRemoved
  Future<void> emitTrackRemoved(DBusObjectPath TrackId) async {
     await emitSignal('org.mpris.MediaPlayer2.TrackList', 'TrackRemoved', [TrackId]);
  }

  /// Emits signal org.mpris.MediaPlayer2.TrackList.TrackMetadataChanged
  Future<void> emitTrackMetadataChanged(DBusObjectPath TrackId, Map<String, DBusValue> Metadata) async {
     await emitSignal('org.mpris.MediaPlayer2.TrackList', 'TrackMetadataChanged', [TrackId, DBusDict.stringVariant(Metadata)]);
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [DBusIntrospectInterface('org.mpris.MediaPlayer2.TrackList', methods: [DBusIntrospectMethod('GetTracksMetadata', args: [DBusIntrospectArgument(DBusSignature('ao'), DBusArgumentDirection.in_, name: 'TrackIds'), DBusIntrospectArgument(DBusSignature('aa{sv}'), DBusArgumentDirection.out, name: 'Metadata')]), DBusIntrospectMethod('AddTrack', args: [DBusIntrospectArgument(DBusSignature('s'), DBusArgumentDirection.in_, name: 'Uri'), DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_, name: 'AfterTrack'), DBusIntrospectArgument(DBusSignature('b'), DBusArgumentDirection.in_, name: 'SetAsCurrent')]), DBusIntrospectMethod('RemoveTrack', args: [DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_, name: 'TrackId')]), DBusIntrospectMethod('GoTo', args: [DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_, name: 'TrackId')])], signals: [DBusIntrospectSignal('TrackListReplaced', args: [DBusIntrospectArgument(DBusSignature('ao'), DBusArgumentDirection.out, name: 'Tracks'), DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.out, name: 'CurrentTrack')]), DBusIntrospectSignal('TrackAdded', args: [DBusIntrospectArgument(DBusSignature('a{sv}'), DBusArgumentDirection.out, name: 'Metadata'), DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.out, name: 'AfterTrack')]), DBusIntrospectSignal('TrackRemoved', args: [DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.out, name: 'TrackId')]), DBusIntrospectSignal('TrackMetadataChanged', args: [DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.out, name: 'TrackId'), DBusIntrospectArgument(DBusSignature('a{sv}'), DBusArgumentDirection.out, name: 'Metadata')])], properties: [DBusIntrospectProperty('Tracks', DBusSignature('ao'), access: DBusPropertyAccess.read), DBusIntrospectProperty('CanEditTracks', DBusSignature('b'), access: DBusPropertyAccess.read)])];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'org.mpris.MediaPlayer2.TrackList') {
      if (methodCall.name == 'GetTracksMetadata') {
        if (methodCall.signature != DBusSignature('ao')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doGetTracksMetadata(methodCall.values[0].asObjectPathArray().toList());
      } else if (methodCall.name == 'AddTrack') {
        if (methodCall.signature != DBusSignature('sob')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doAddTrack(methodCall.values[0].asString(), methodCall.values[1].asObjectPath(), methodCall.values[2].asBoolean());
      } else if (methodCall.name == 'RemoveTrack') {
        if (methodCall.signature != DBusSignature('o')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doRemoveTrack(methodCall.values[0].asObjectPath());
      } else if (methodCall.name == 'GoTo') {
        if (methodCall.signature != DBusSignature('o')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doGoTo(methodCall.values[0].asObjectPath());
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    if (interface == 'org.mpris.MediaPlayer2.TrackList') {
      if (name == 'Tracks') {
        return getTracks();
      } else if (name == 'CanEditTracks') {
        return getCanEditTracks();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> setProperty(String interface, String name, DBusValue value) async {
    if (interface == 'org.mpris.MediaPlayer2.TrackList') {
      if (name == 'Tracks') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanEditTracks') {
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
    if (interface == 'org.mpris.MediaPlayer2.TrackList') {
      properties['Tracks'] = (await getTracks()).returnValues[0];
      properties['CanEditTracks'] = (await getCanEditTracks()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}
