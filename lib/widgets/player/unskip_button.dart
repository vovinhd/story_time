import 'dart:async';

import 'dart:ui';

import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/widgets/player/unskip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:logging/logging.dart';
import 'package:yaru/yaru.dart';

final _log = Logger('unskip');


class UnskipButton extends StatefulWidget {
  const new({super.key});

  @override
  State<UnskipButton> createState() => _UnskipButtonState();
}

class _UnskipButtonState extends State<UnskipButton> {
  Duration lastUnskip = Duration();
  Duration lastConsumed = Duration();
  bool timedOut = false;
  Timer? timer;

  void onTimedOut() {
    setState(() => timedOut = true);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        StreamBuilder(
          stream: PlayerService().seekStream.stream,
          builder: (context, asyncSnapshot) {
            if (!asyncSnapshot.hasData) {
              return SizedBox();
            }

            // print(
            //   "${asyncSnapshot.data!.inSeconds}, ${lastUnskip.inSeconds}, ${lastConsumed.inSeconds}, $timedOut",
            // );

            if (lastUnskip.inSeconds == lastConsumed.inSeconds || timedOut) {
              lastUnskip = asyncSnapshot.data!;
              timedOut = false;
              return SizedBox();
            }

            timer?.cancel();

            timer = Timer(ConfigProvider().config.unksipTimeout, onTimedOut);

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: 0),
              duration: ConfigProvider().config.unksipTimeout,

              builder: (context, progress, child) {
                return Opacity(
                  opacity: progress,
                  child: Container(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: YaruColors.coolGrey,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: .bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: const .all(Radius.circular(1000)),
                        ),
                      ),
                      onPressed: () {
                        if (asyncSnapshot.hasData) {
                          _log.info("unskip ${asyncSnapshot.data!.inSeconds}");
                          PlayerService().seek(asyncSnapshot.data!); // don't use globals.seek to not reemit the position and make a looping go back go back go back button
                          lastConsumed = asyncSnapshot.data!;
                          lastUnskip = asyncSnapshot.data!;
                  
                          // setState(() {});
                        }
                      },
                      label: Text("go back", style: .new(fontWeight: .bold, fontSize: 18),),
                      icon: Icon(YaruIcons.undo, fontWeight: .bold, color: Theme.of(context).brightness == .dark ? YaruColors.porcelain : YaruColors.textGrey,),
                    ),
                  ).animate().slideY(begin: .2, end: 0).fade(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
