import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:fl_audiobook/widgets/player/chapter_list_button.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class ChapterListButton extends StatefulWidget {
  const ChapterListButton({
    super.key,
  });

    // todo factor out!
  @override
  State<ChapterListButton> createState() => _ChapterListButtonState();

  // void _seekChapter(AudiobookChapter chapterInformation) {
  //   final micros = (Duration(
  //     microseconds:chapterInformation.start.inMicroseconds,
  //   ));

  //   PlayerService().seek(micros + Duration(milliseconds: 1));
  // }
}

class _ChapterListButtonState extends State<ChapterListButton> {
  @override
  Widget build(BuildContext context) {
    if (PlayerService().chapters.length < 2) {
      return SizedBox();
    }
    return OutlinedButton(
      style: ButtonStyle(alignment: .centerLeft),
      child: Row(
        children: [
          Icon(YaruIcons.unordered_list),
          StreamBuilder(
            stream: PlayerService().positionStream,
            builder: (context, asyncSnapshot) {
              Duration pos;
              if (asyncSnapshot.hasData) {
                pos = asyncSnapshot.data!;
              } else {
                pos = PlayerService().position;
              }

              var ch = PlayerService().getChapterFor(pos); 
              if (ch == null) {
                return Text(PlayerService().title);
              }
              return Text(ch.title);
            },
          ),
        ],
      ),
      onPressed: () {
        showChapterSheet(context);
      },
    );
  }

  Future<void> showChapterSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        useSafeArea: true,

        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          maxWidth: 650,
        ),
        builder: (BuildContext context) {
          return SizedBox(
            child: Center(
              child: Column(
                mainAxisAlignment: .center,
                mainAxisSize: .min,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.9,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 4,
                      ),
                      itemCount: PlayerService().chapters.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(PlayerService().chapters[index].title),
                          trailing: Text(
                            printDuration(
                              Duration(
                                microseconds: (
                                  PlayerService().chapters[index].start.inMicroseconds
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            PlayerService().seekChapter(PlayerService().chapters[index]);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),

                  // ElevatedButton(
                  //   child: const Text('Close BottomSheet'),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              ),
            ),
          );
        },
      );
  }
}
