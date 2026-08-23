import 'dart:async';

import 'package:fl_audiobook/globals.dart' as globals;
import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/time_display.dart';
import 'package:flutter/material.dart';

class TimerOptions extends StatelessWidget {
  const new({super.key});

  final List<Duration> timerOffsets = const <Duration>[
    Duration(seconds: 5), 
    Duration(minutes: 10),
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(minutes: 60),
  ];

  final List<String> timerOffsetLabels = const <String>[
    "5 sec",
    "10 minutes",
    "15 minutes",
    "30 minutes",
    "1 hour",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: popoverBoxDecoration,
      width: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: StreamBuilder(
          stream: AutoPauseTimer.remainingStream, 
          
          builder: (context, asyncSnapshot) {
            Duration? currentRemaining;
            if (asyncSnapshot.hasData) {
              currentRemaining = asyncSnapshot.data!;
            }

            return ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,

              children: [
                TextButton(
                  onPressed: () {
                    AutoPauseTimer.cancel(); 
                  },
                  child: Align(
                    alignment: .centerStart,
                    child: Text(asyncSnapshot.hasData && currentRemaining!.inSeconds > 0 ? "Off ${printDuration(currentRemaining)}" : "Off", textAlign: .start),
                  ),
                ),

                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: timerOffsetLabels.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TextButton(
                      onPressed: () {
                        AutoPauseTimer.startTimer(timerOffsets[index], false); 
                      },
                      child: Align(
                        alignment: .centerStart,
                        child: Text(
                          timerOffsetLabels[index],
                          textAlign: .start,
                        ),
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    AutoPauseTimer.startTimer(-timeLeftInChapter(globals.player.state.position), true); 
                  },
                  child: Align(
                    alignment: .centerStart,
                    child: Text("End Of Chapter", textAlign: .start),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AutoPauseTimer {
  Timer? autoPauseTimer;
  Stopwatch autoPauseStopwatch = Stopwatch();
  Duration currentDuration = Duration(microseconds: 0);
  bool chapterMode = false; 
  StreamSubscription<bool> playingState;
  Timer tick = Timer.periodic(const Duration(seconds:1), (timer) {
    if (_instance.currentDuration.inSeconds > 0) {
      _instance._remainingStreamController.sink.add(remaining); 
    } 
  }); 

  void onPlaybackStateChanged(bool playing) {
    if (!chapterMode) return; 
    if (!willAutoPause) return; 
    if (playing) {
      autoPauseStopwatch.start(); 
      autoPauseTimer = Timer(currentDuration, _timerCallback); 
    } else {
      var remainingDuration = remaining; 
      autoPauseStopwatch.stop(); 
      autoPauseTimer!.cancel(); 
      currentDuration = remainingDuration; 
    }

  }

  AutoPauseTimer._privateConstructor():
      playingState = globals.player.stream.playing.listen((data) {
        _instance.onPlaybackStateChanged(data);
      }); 
  

  final _remainingStreamController = StreamController<Duration>.broadcast(); 
  final _autoPauseEmittedController = StreamController<Duration>.broadcast(); 
  final _autoPauseCancelledController = StreamController<bool>.broadcast(); 

  static final AutoPauseTimer _instance = AutoPauseTimer._privateConstructor();

  // returns duration of 0 seconds if timer not running
  static Duration get elapsed {
    return _instance.autoPauseStopwatch.elapsed;
  }

  // returns duration of 0 seconds if timer not running
  static Duration get remaining {
    return _instance.currentDuration - elapsed;
  }

  static bool get willAutoPause {
    return _instance.currentDuration.inSeconds > 0;
  }

  static Stream<Duration> get remainingStream {
    return _instance._remainingStreamController.stream; 
  }

  static Stream<Duration> get autoPauseStream {
    return _instance._autoPauseEmittedController.stream; 
  }

  static Stream<bool> get autoPauseCancelledStream {
    return _instance._autoPauseCancelledController.stream; 
  }


  static void _timerCallback() {

    globals.player.pause(); 

    _instance._autoPauseEmittedController.sink.add(_instance.currentDuration); 
    
    _instance.autoPauseStopwatch
      ..stop()
      ..reset();

    _instance.currentDuration = Duration();
  }

  static void startTimer(Duration duration, bool chapterMode) {
    if (_instance.autoPauseTimer != null) {
      cancel();
    }

    _instance.chapterMode = chapterMode; 

    _instance.currentDuration = duration;

    _instance.autoPauseTimer = Timer(duration, _timerCallback);
    _instance.autoPauseStopwatch.start();

    // open question: 

  }

  static void cancel() {
    // we're not running, nothing to cancel
    if (_instance.autoPauseTimer == null) {
      return;
    }
    _instance.autoPauseTimer!.cancel();
    _instance.autoPauseTimer = null;

    _instance.autoPauseStopwatch
      ..stop()
      ..reset();

    _instance.currentDuration = Duration();
    _instance._autoPauseCancelledController.sink.add(true);
    _instance._remainingStreamController.sink.add(Duration());

  }
}
