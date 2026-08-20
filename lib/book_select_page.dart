import 'dart:io';
import 'dart:math';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:file_md5/file_md5.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/mini_player.dart';
import 'package:fl_audiobook/player_page.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:xdg_directories/xdg_directories.dart';
import 'package:yaru/yaru.dart';




class BookSelectPage extends StatefulWidget {
  const new({super.key});

  @override
  State<BookSelectPage> createState() => _BookSelectPageState();
}

class _BookSelectPageState extends State<BookSelectPage> {
  void _openFile() async {
    PlatformFile? file = await FilePicker.pickFile();

    if (file != null) {
      // print(file.name);
      // print(await file.length());

      final media = Media(file.path!);
      // print(media.toString());
      globals.player.open(media, play: true);

      final canonicalPath = "\"${file.path!}\"";

      final session = FFprobeKit.getMediaInformation(canonicalPath);
      final info = session.getMediaInformation();
      globals.chapters = info?.chapters;
      globals.tags = info?.tags;

      
      final coverPath = "${dataHome.path}/${globals.APP_DIR}/${file.name}.jpg";
      final coverSess = FFmpegKit.execute(
        "-y -i $canonicalPath -an -vcodec copy \"$coverPath\"",
      );
      // print(coverSess.getReturnCode());
      globals.coverImage = Image.file(File(coverPath), key: UniqueKey());
      globals.ready = true;
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => PlayerPage(
              player: globals.player,
              chapters: globals.chapters!,
              tags: globals.tags!,
              cover: globals.coverImage,
            ),
          ),
        );
      }
      setState(() {});
    } else {
      // User canceled the picker
      print("User canceled the picker");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                YaruSplitButton(
                  items: null,
                  child: Text("Open Audiobook"),
                  onPressed: () => _openFile(),
                ),
              ],
            ),
          ),
        ),
        MiniPlayer(),
      ],
    );
  }
}
