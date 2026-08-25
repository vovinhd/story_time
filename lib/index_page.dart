import 'package:fl_audiobook/book_select_page.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'globals.dart' as globals;
import 'tray.dart' as tray;

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
        heroTag: "appbar", 
        backgroundColor: Colors.transparent,
        onClose: (p0) {
          tray.hideOrClose(); 
        },
        onShowMenu: (p0) => {},
        border: BorderSide.none,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          icon: Icon(YaruIcons.menu),
        ),
        title: Text("Player"),
      ),
      drawer: Drawer(width: 200,child: DrawerContents(),shape: RoundedRectangleBorder(borderRadius: .only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))),),
      body: BookSelectPage(),
  //       floatingActionButton: FloatingActionButton(
  //       child: Icon(Icons.book), onPressed: () {  
  //         requestFilePickStream.sink.add(true); 
  //       },
  // ),
    );
  }
}

class DrawerContents extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: .center,
        spacing: 32,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Image.asset("images/app_icon.png"),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                YaruNavigationRailItem(
                  icon: Icon(YaruIcons.settings),
                  style: YaruNavigationRailStyle.labelledExtended,
                  label: Text("Preferences"),
                  extendedSelectedIndicator: true,
                  onTap: () => {print("navigate to preferences")},
                ),
                YaruNavigationRailItem(
                  icon: Icon(YaruIcons.information),
                  style: YaruNavigationRailStyle.labelledExtended,
                  label: Text("About"),
                  extendedSelectedIndicator: true,
                  onTap: () => {showAboutDialog(context: context, applicationVersion: "0.1.0", applicationIcon: Image.asset("images/app_icon.png"), applicationLegalese: "This software is very cool.")},
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Text("version 0.1.0", style: TextStyle(
    color: const Color.fromARGB(255, 97, 97, 97),
       ),),)
        ],
      ),
    );
  }
}
