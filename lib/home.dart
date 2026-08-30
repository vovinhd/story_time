import 'dart:io';

import 'package:fl_audiobook/my_route_transition.dart';
import 'package:fl_audiobook/routes/settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

//import 'example.dart';
import 'routes/index_page.dart';
import 'model.dart';

class ExampleHome extends StatelessWidget with WatchItMixin {
  const ExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = watchPropertyValue((Model m) => m.themeMode);
    final yaruVariant = watchPropertyValue((Model m) => m.yaruVariant);
    final forceHighContrast = watchPropertyValue(
      (Model m) => m.forceHighContrast,
    );

    if (!kIsWeb && Platform.isLinux) {
      return YaruTheme(
        builder: (context, yaru, child) => _ExampleHome(
          themeMode: themeMode,
          lightTheme: forceHighContrast
              ? yaruHighContrastLight
              : yaruVariant?.theme ?? yaru.theme,
          darkTheme: forceHighContrast
              ? yaruHighContrastDark
              : yaruVariant?.darkTheme ?? yaru.darkTheme,
          highContrastTheme: yaruHighContrastLight,
          highContrastDarkTheme: yaruHighContrastDark,
        ),
      );
    }

    return _ExampleHome(
      themeMode: themeMode,
      lightTheme: forceHighContrast
          ? yaruHighContrastLight
          : yaruVariant?.theme ?? yaruLight,
      darkTheme: forceHighContrast
          ? yaruHighContrastDark
          : yaruVariant?.darkTheme ?? yaruDark,
      highContrastTheme: yaruHighContrastLight,
      highContrastDarkTheme: yaruHighContrastDark,
    );
  }
}

class _ExampleHome extends StatelessWidget {
  const _ExampleHome({
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
    required this.highContrastTheme,
    required this.highContrastDarkTheme,
  });

  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        title: 'fl_audiobook',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        themeMode: themeMode,
        darkTheme: darkTheme,
        highContrastTheme: highContrastDarkTheme,
        highContrastDarkTheme: highContrastDarkTheme,
        home: IndexPage(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
            PointerDeviceKind.trackpad,
          },
        ),
      ),
    );
  }
}
