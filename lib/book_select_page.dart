import 'dart:async';

// import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/widgets/home/hero_player.dart';
import 'package:fl_audiobook/widgets/home/hero_usage_hint.dart';
import 'package:fl_audiobook/widgets/home/last_played_list.dart';
import 'package:flutter/material.dart';

StreamSubscription? subs;

StreamController<bool> requestFilePickStream = StreamController<bool>();

// File? getCoverImageForFile(filename) {
//   final coverPath = "${dataHome.path}/${globals.APP_DIR}/${filename}.jpg";
//   var coverFile = File(coverPath);
//   if (coverFile.existsSync()) {
//     return coverFile;
//   }

//   return null;
// }

class BookSelectPage extends StatefulWidget {
  const new({super.key});
  @override
  State<BookSelectPage> createState() => BookSelectPageState();
}

class BookSelectPageState extends State<BookSelectPage> {
  bool shouldTransition = false;

  late final foo = requestFilePickStream.stream.listen((data) {
    print("hi");
    pickFile();
  });

  void pickFile() async {
    PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ["m4b", "m4a", "mp3"],
    );

    if (file != null) {
      try {
        await PlayerService().openFile(
          BookFile(name: file.name, path: file.path!),
        );
        _transition();
      } catch (e) {
        print(e);
      }
    } else {
      // User canceled the picker
      print("User canceled the picker");
    }
  }

  void _pushPlayerRoute() {
    if (mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (context) => PlayerPage()));
    }
  }

  void _transition() async {
    ConfigProvider().updatePlaybackState();
    _pushPlayerRoute();

    // emit the dbus state change

    // TODO factor into media_player2
    // globals.mediaPlayer2.emitPropertiesChanged(
    //   "org.mpris.MediaPlayer2.Player",
    //   changedProperties: {
    //     "Metadata": DBusDict(
    //       DBusSignature.string,
    //       DBusSignature.variant,
    //       (await globals.mediaPlayer2.buildMetadata())!,
    //     ),
    //     "PlaybackStatus": DBusString("Playing"),
    //     "Position": DBusInt64(PlayerService().position.inMicroseconds),
    //   },
    //   invalidatedProperties: ["PlaybackStatus", "MetaData", "Position"],
    // );
    // globals.mediaPlayer2.emitSeeked(
    //   PlayerService().position.inMicroseconds,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .spaceAround,
      crossAxisAlignment: .start,
      children: [
        StreamBuilder(
          stream: PlayerService().selectedBookStream.stream,
          builder: (context, asyncSnapshot) {
            if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
              return HeroUsageHint(onClick: pickFile);
            }
            return HeroPlayer(file: asyncSnapshot.data!);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: Text("Last played"),
        ),

        LastPlayedList(onPickFile: pickFile, onTransition: _transition),

        // Expanded(
        //   flex: 1,
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: .center,
        //       children: [
        //         YaruSplitButton(
        //           items: null,
        //           child: Text("Open Audiobook"),
        //           onPressed: () => _pickFile(),
        //         ),

        //       ],
        //     ),
        //   ),
        // ),
        // MiniPlayer(),
      ],
    );
  }
}
