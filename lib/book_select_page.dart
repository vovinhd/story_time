import 'dart:io';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_audiobook/config.dart';
import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/mini_player.dart';
import 'package:fl_audiobook/player_page.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:xdg_directories/xdg_directories.dart';
import 'package:yaru/yaru.dart';

final class BookFile {
  final String name;
  final String path;

  new({required this.name, required this.path});
}

File? getCoverImageForFile(filename) {
  final coverPath = "${dataHome.path}/${globals.APP_DIR}/${filename}.jpg";
  var coverFile = File(coverPath);
  if (coverFile.existsSync()) {
    return coverFile;
  }

  return null;
}

class BookSelectPage extends StatefulWidget {
  const new({super.key});

  @override
  State<BookSelectPage> createState() => _BookSelectPageState();
}

class _BookSelectPageState extends State<BookSelectPage> {
  void _pickFile() async {
    PlatformFile? file = await FilePicker.pickFile();

    if (file != null) {
    } else {
      // User canceled the picker
      print("User canceled the picker");
    }
  }

  void _openFile(BookFile file, {position = 0} ) async {
    print(position);
    final media = Media(file.path);
    // print(media.toString());
    final canonicalPath = "\"${file.path}\"";
    globals.playingFile = file;

    final session = FFprobeKit.getMediaInformation(canonicalPath);
    final info = session.getMediaInformation();
    globals.chapters = info?.chapters;
    globals.tags = info?.tags;

    var coverFile = getCoverImageForFile(file.name);

    if (coverFile == null) {
      final coverPath = "${dataHome.path}/${globals.APP_DIR}/${file.name}.jpg";

      final coverSess = FFmpegKit.execute(
        "-y -i $canonicalPath -an -vcodec copy \"$coverPath\"",
      );

      if (coverSess.getReturnCode() != 0) {
      } else {
        coverFile = File(coverPath);
        globals.coverImage = Image.file(coverFile, key: UniqueKey());
      }
    } else {
      globals.coverImage = Image.file(coverFile, key: UniqueKey());
    }
    await globals.player.open(media, play: true); 
    await globals.player.seek(Duration(microseconds: position)); 

    // print(coverSess.getReturnCode());
    globals.ready = true;
    globals.initTimer();
    ConfigProvider().updatePlaybackState();
    // if (mounted) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute<void>(
    //       builder: (context) => PlayerPage(
    //         player: globals.player,
    //         chapters: globals.chapters!,
    //         tags: globals.tags!,
    //         cover: globals.coverImage,
    //       ),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .spaceAround,
      children: [
        Expanded(
          child: StreamBuilder(
            stream: ConfigProvider().streamController.stream,
            builder: (context, asyncSnapshot) {
              var books = ConfigProvider().playbackStates;

              if (asyncSnapshot.hasData) {
                books = asyncSnapshot.data!.playbackStates;
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                itemCount: books.length,
                itemBuilder: (BuildContext context, int index) {
                  final state = books[index]; 
                  final bookFile = BookFile(name: state.file, path: state.path); 
                  final coverfile = getCoverImageForFile(state.file);
                  return ListTile(
                    leading: coverfile == null
                        ? globals.defaultCoverImage
                        : Image.file(coverfile, key: UniqueKey()),
                    title: Text("${state.title} - ${printDuration(Duration(microseconds:state.position))} "),
                    trailing: SizedBox(
                      width: 105,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(YaruIcons.battery),
                          ),
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(YaruIcons.battery),
                          ),
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(YaruIcons.battery),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => {_openFile(bookFile,position: state.position )},
                  );
                },
              );
            },
          ),
        ),

        Expanded(
          flex: 1,
          child: Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                YaruSplitButton(
                  items: null,
                  child: Text("Open Audiobook"),
                  onPressed: () => _pickFile(),
                ),
              ],
            ),
          ),
        ),
        //MiniPlayer(),
      ],
    );
  }
}
