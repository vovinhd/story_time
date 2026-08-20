import 'dart:io';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_audiobook/book_select_page.dart';
import 'package:fl_audiobook/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:yaru/yaru.dart';

import 'player_page.dart';

import 'globals.dart' as globals;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key

class IndexPage extends StatefulWidget {
  new({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  @override
  void dispose() {
    globals.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: YaruWindowTitleBar(
        onShowMenu: (p0) => {},
        border: BorderSide.none,
        leading:  null,
        title: Text("Player"),
    
      ),
      drawer: Drawer(child: Text("Player")),
      body: Container(
        child: BookSelectPage()
      ),
    );
  }
}
