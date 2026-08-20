

import 'package:fl_audiobook/book_select_page.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';


import 'globals.dart' as globals;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

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
