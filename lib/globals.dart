
import 'package:fl_audiobook/media_player2.dart';
import 'package:flutter/material.dart';

const String APP_DIR = "fl_audiobookplayer";

MediaPlayer2 mediaPlayer2 = MediaPlayer2();

Image defaultCoverImage = Image.asset(
  "images/cover_default.png",
  key: UniqueKey(),
);

