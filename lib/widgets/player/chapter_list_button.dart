import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:fl_audiobook/widgets/player/chapter_list_button.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class ChapterListButton extends StatefulWidget {
  const ChapterListButton({
    super.key,
    required this.chapters,
    required this.currentChapter,
  });

    // todo factor out!
  final List<AudiobookChapter> chapters;
  final AudiobookChapter currentChapter;
  @override
  State<ChapterListButton> createState() => _ChapterListButtonState();

  void _seekChapter(AudiobookChapter chapterInformation) {
    final micros = (Duration(
      microseconds:chapterInformation.start.inMicroseconds,
    ));

    PlayerService().seek(micros + Duration(milliseconds: 1));
  }
}

class _ChapterListButtonState extends State<ChapterListButton> {
  @override
  Widget build(BuildContext context) {
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
              return Text(PlayerService().getChapterFor(pos)!.title);
            },
          ),
        ],
      ),
      onPressed: () {
        showModalBottomSheet<void>(
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
                        itemCount: widget.chapters.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(widget.chapters[index].title),
                            trailing: Text(
                              printDuration(
                                Duration(
                                  microseconds: (
                                    widget.chapters[index].start.inMicroseconds
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              widget._seekChapter(widget.chapters[index]);
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
      },
    );
  }
}
