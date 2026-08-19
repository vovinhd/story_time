import 'dart:io';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:yaru/yaru.dart';

import 'player_page.dart';

class IndexPage extends StatefulWidget {
  new({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late final player = Player();

  Image coverImage = (Image.asset(
    "images/cover_default.png",
    key: UniqueKey(),
  ));
  PlatformFile? file;
  String title = "";
  String author = "";

  List<ChapterInformation>? chapters;
  Map<String, dynamic>? tags;

  String chapterTitle = "";
  ChapterInformation? currentChapter;

  bool ready = false;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _openFile() async {
    PlatformFile? file = await FilePicker.pickFile();

    if (file != null) {
      // print(file.name);
      // print(await file.length());
      final media = Media(file.path!);
      // print(media.toString());
      player.open(media, play: true);

      final canonicalPath = "\"${file.path!}\"";

      final session = FFprobeKit.getMediaInformation(canonicalPath);
      final info = session.getMediaInformation();
      print(info?.chapters);
      chapters = info?.chapters;

      for (var chapter in chapters!) {
        print(
          "CHAPTER ${chapter.id}: ${chapterInfoTimeToMicros(chapter.startTime!)}, ${chapterInfoTimeToMicros(chapter.endTime!)}",
        );
      }

      tags = info?.tags;
      print(info?.tags);

      title = info?.tags?["album"];
      author = info?.tags?["artist"];
      chapterTitle = info?.chapters[0].tags?["title"];

      final coverPath = "/tmp/${file.name}.jpg";
      final coverSess = FFmpegKit.execute(
        "-y -i $canonicalPath -an -vcodec copy \"$coverPath\"",
      );
      // print(coverSess.getReturnCode());
      coverImage = Image.file(File(coverPath), key: UniqueKey());
      ready = true;
      setState(() {});
    } else {
      // User canceled the picker
      print("User canceled the picker");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        onShowMenu: (p0) => {},
        border: BorderSide.none,
        leading: Navigator.of(context).canPop() ? const YaruBackButton() : null,
        title: Text("Player"),
        actions: [YaruIconButton(onPressed: () => {print("TODO open settings")}, icon: const Icon(YaruIcons.settings))],
      ),

      body: Center(
        child: ready
            ? PlayerPage(
                player: player,
                chapters: chapters!,
                tags: tags!,
                cover: coverImage,
              )
            : Column(
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
    );
  }
}
