import 'package:story_time/routes/index_page.dart';
import 'package:story_time/routes/player_page.dart';
import 'package:story_time/routes/settings_page.dart';
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
