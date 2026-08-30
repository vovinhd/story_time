import 'package:fl_audiobook/tray.dart' as tray;
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class SettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        onClose: (p0) => tray.hideOrClose(),
        title: Text("Settings"),
        leading: YaruBackButton(),
        actions: [SizedBox(height: 34, width: 34,)],
      ),
      
    );
  }
}