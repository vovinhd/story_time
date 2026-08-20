import 'package:dbus/dbus.dart';
import 'package:dbus/src/dbus_method_response.dart';
import 'package:fl_audiobook/mpris/mediaplayer2.dart';

class DbusPlayerObject extends Player_Interface {
  @override
  Future<DBusMethodResponse> getCanPlay() async {
    return DBusMethodSuccessResponse([DBusBoolean(true)]); 
  }

  @override
  Future<DBusMethodResponse> getPlaybackStatus() async {
    return DBusMethodSuccessResponse([DBusString("Stopped")]);
  }

}