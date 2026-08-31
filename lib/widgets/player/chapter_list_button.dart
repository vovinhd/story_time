import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yaru/yaru.dart';

class ChapterListButton extends StatefulWidget {
  const ChapterListButton({super.key});

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
                  child: StreamBuilder(
                    stream: PlayerService().positionStream,
                    builder: (context, asyncSnapshot) {
                      var position = PlayerService().position;
                      if (asyncSnapshot.hasData) {
                        position = asyncSnapshot.data!;
                      }
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 4,
                        ),
                        itemCount: PlayerService().chapters.length,
                        itemBuilder: (BuildContext context, int index) {
                          var chapter = PlayerService().chapters[index];
                          var isCurrent = false;
                          if (chapter.start <= position &&
                              chapter.end >= position) {
                            isCurrent = true;
                          }
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(borderRadius: .circular(20),side: .new(width: 2,color: Colors.transparent)),
                              
                              leading: isCurrent
                                  ? Icon(PlayerService().isPlaying ? YaruIcons.media_play : YaruIcons.media_pause).animate().fade()
                                  : SizedBox(
                                      width: 18,
                                      child: Icon(Icons.circle, size: 5),
                                    ),
                              title: Row(
                                children: [
                                  Text(
                                    chapter.title,
                                    style: .new(fontSize: 14, fontWeight: .bold),
                                  ),
                                  if (isCurrent)
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: LinearProgressIndicator(
                                          value:
                                              (position.inMicroseconds -
                                                  chapter.start.inMicroseconds) /
                                              (chapter.end.inMicroseconds -
                                                  chapter.start.inMicroseconds),
                                        ).animate().fade(),
                                      ),
                                    ),
                                ],
                              ),
                              trailing: DurationLabel(
                                duration: isCurrent
                                    ? position - chapter.end
                                    : chapter.end -chapter.start,
                                style: .new(fontSize: 14),
                              ),
                            
                              onTap: () {
                                if (!isCurrent) {
                                  PlayerService().seekChapter(
                                    PlayerService().chapters[index],
                                  );
                                }
                                Navigator.pop(context);
                              },
                            ),
                          );
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
