import 'package:fl_audiobook/index_page.dart';
import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const IndexPage(key: Key("index")),
      routes: [
        GoRoute(
          path: "play",
          pageBuilder: (context, state) =>
              MaterialPage<void>(child: PlayerPage(key: Key("player"))),
        ),
        GoRoute(
          path: "settings",
          pageBuilder: (context, state) => MaterialPage(child: SettingsPage(key: Key("settings"))),
        ),
      ],
    ),
  ],
);
