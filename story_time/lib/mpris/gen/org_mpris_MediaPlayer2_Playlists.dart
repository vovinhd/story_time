// This file was generated using the following command and may be overwritten.
// dart-dbus generate-object org.mpris.MediaPlayer2.Playlists.xml

import 'package:dbus/dbus.dart';

class Playlists_Interface extends DBusObject {
  /// Creates a new object to expose on [path].
  Playlists_Interface({DBusObjectPath path = const DBusObjectPath.unchecked('/Playlists_Interface')}) : super(path);

  /// Gets value of property org.mpris.MediaPlayer2.Playlists.PlaylistCount
  Future<DBusMethodResponse> getPlaylistCount() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Playlists.PlaylistCount not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Playlists.Orderings
  Future<DBusMethodResponse> getOrderings() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Playlists.Orderings not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Playlists.ActivePlaylist
  Future<DBusMethodResponse> getActivePlaylist() async {
    return DBusMethodErrorResponse.failed('Get org.mpris.MediaPlayer2.Playlists.ActivePlaylist not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Playlists.ActivatePlaylist()
  Future<DBusMethodResponse> doActivatePlaylist(DBusObjectPath PlaylistId) async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Playlists.ActivatePlaylist() not implemented');
  }

  /// Implementation of org.mpris.MediaPlayer2.Playlists.GetPlaylists()
  Future<DBusMethodResponse> doGetPlaylists(int Index, int MaxCount, String Order, bool ReverseOrder) async {
    return DBusMethodErrorResponse.failed('org.mpris.MediaPlayer2.Playlists.GetPlaylists() not implemented');
  }

  /// Emits signal org.mpris.MediaPlayer2.Playlists.PlaylistChanged
  Future<void> emitPlaylistChanged(List<DBusValue> Playlist) async {
     await emitSignal('org.mpris.MediaPlayer2.Playlists', 'PlaylistChanged', [DBusStruct(Playlist)]);
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [DBusIntrospectInterface('org.mpris.MediaPlayer2.Playlists', methods: [DBusIntrospectMethod('ActivatePlaylist', args: [DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_, name: 'PlaylistId')]), DBusIntrospectMethod('GetPlaylists', args: [DBusIntrospectArgument(DBusSignature('u'), DBusArgumentDirection.in_, name: 'Index'), DBusIntrospectArgument(DBusSignature('u'), DBusArgumentDirection.in_, name: 'MaxCount'), DBusIntrospectArgument(DBusSignature('s'), DBusArgumentDirection.in_, name: 'Order'), DBusIntrospectArgument(DBusSignature('b'), DBusArgumentDirection.in_, name: 'ReverseOrder'), DBusIntrospectArgument(DBusSignature('a(oss)'), DBusArgumentDirection.out, name: 'Playlists')])], signals: [DBusIntrospectSignal('PlaylistChanged', args: [DBusIntrospectArgument(DBusSignature('(oss)'), DBusArgumentDirection.out, name: 'Playlist')])], properties: [DBusIntrospectProperty('PlaylistCount', DBusSignature('u'), access: DBusPropertyAccess.read), DBusIntrospectProperty('Orderings', DBusSignature('as'), access: DBusPropertyAccess.read), DBusIntrospectProperty('ActivePlaylist', DBusSignature('(b(oss))'), access: DBusPropertyAccess.read)])];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'org.mpris.MediaPlayer2.Playlists') {
      if (methodCall.name == 'ActivatePlaylist') {
        if (methodCall.signature != DBusSignature('o')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doActivatePlaylist(methodCall.values[0].asObjectPath());
      } else if (methodCall.name == 'GetPlaylists') {
        if (methodCall.signature != DBusSignature('uusb')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doGetPlaylists(methodCall.values[0].asUint32(), methodCall.values[1].asUint32(), methodCall.values[2].asString(), methodCall.values[3].asBoolean());
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    if (interface == 'org.mpris.MediaPlayer2.Playlists') {
      if (name == 'PlaylistCount') {
        return getPlaylistCount();
      } else if (name == 'Orderings') {
        return getOrderings();
      } else if (name == 'ActivePlaylist') {
        return getActivePlaylist();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> setProperty(String interface, String name, DBusValue value) async {
    if (interface == 'org.mpris.MediaPlayer2.Playlists') {
      if (name == 'PlaylistCount') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Orderings') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'ActivePlaylist') {
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
    if (interface == 'org.mpris.MediaPlayer2.Playlists') {
      properties['PlaylistCount'] = (await getPlaylistCount()).returnValues[0];
      properties['Orderings'] = (await getOrderings()).returnValues[0];
      properties['ActivePlaylist'] = (await getActivePlaylist()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}
