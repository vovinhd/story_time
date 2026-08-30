import 'dart:ui';
import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:fl_audiobook/widgets/home/last_played_card.dart';
import 'package:fl_audiobook/widgets/home/last_played_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:yaru/yaru.dart';

class LastPlayedList extends StatefulWidget {
  const new({super.key, required this.onPickFile, required this.onTransition});

  final VoidCallback onPickFile;
  final VoidCallback onTransition;

  @override
  State<LastPlayedList> createState() => _LastPlayedListState();
}

class _LastPlayedListState extends State<LastPlayedList> {
  double offset = 0.0;
  String showBookMenu = "";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          offset > 18 ? Container(color: YaruColors.jet) : SizedBox(),
          StreamBuilder(
            stream: ConfigProvider().streamController.stream,
            builder: (context, asyncSnapshot) {
              var books = ConfigProvider().playbackStates;

              if (asyncSnapshot.hasData) {
                books = asyncSnapshot.data!.playbackStates;
              }
              return NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  //How many pixels scrolled from pervious frame
                  // print(notification.scrollDelta);

                  //List scroll position
                  offset = notification.metrics.pixels;
                  setState(() {});
                  return true;
                },
                child: ListView.builder(
                  primary: true,
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 100,
                  ),
                  itemCount: books.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= books.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: YaruSplitButton(
                            items: null,
                            child: Text("Open Audiobook"),
                            onPressed: widget.onPickFile,
                          ),
                        ),
                      );
                    }
                    final state = books[index];
                    final bookFile = BookFile(
                      name: state.file,
                      path: state.path,
                    );
                    if (PlayerService().playingFile != null &&
                        bookFile.name == PlayerService().playingFile!.name) {
                      return SizedBox();
                    }
                    final coverfile = bookFile.coverImage;
                    final now = DateTime.now();
                    final agoDateTime = now.subtract(
                      now.difference(state.lastPlayed),
                    );
                    final dateTimeLabel = timeago.format(agoDateTime);

                    final timeRemaining =
                        Duration(microseconds: state.duration) -
                        Duration(microseconds: state.position);
                    final timeRemainingLabel = printDuration(timeRemaining);

                    final listeningProgress = state.position / state.duration;

                    return LastPlayedCard(
                      bookFile: bookFile,
                      state: state,
                      widget: widget,
                      coverfile: coverfile,
                      dateTimeLabel: dateTimeLabel,
                      listeningProgress: listeningProgress,
                      timeRemainingLabel: timeRemainingLabel,
                    );
                  },
                ),
              );
            },
          ),
          Container(
            // fake a shadow the hard way
            clipBehavior: .none,
            width: double.infinity,
            height: 15,
            child: offset > 18
                ? Stack(
                    children: [
                      Container(
                        constraints: .expand(),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: .topCenter,
                            end: .bottomCenter,
                            colors: [
                              const Color.fromARGB(100, 0, 0, 0),
                              Colors.transparent,
                            ],
                            stops: [0.11, 1.0],
                          ),
                        ),
                      ).animate().scaleY(
                        begin: 0,
                        alignment: .topCenter,
                        duration: Duration(milliseconds: 200),
                      ),
                      Container(height: 1, color: YaruColors.coolGrey),
                    ],
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
