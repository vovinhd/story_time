import 'package:fl_audiobook/routes/player_page.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:fl_audiobook/widgets/player/playback_controls.dart';
import 'package:flutter/material.dart';

class RateOptions extends StatelessWidget {
  const new({super.key});

  final List<double> speeds = const <double>[
    2,
    1.75,
    1.5,
    1.25,
    1.2,
    1.1,
    1,
    .9,
    0.75,
    0.5,
  ];
  final List<String> speedLabels = const <String>[
    "2x",
    "1.75x",
    "1.5x",
    "1.25x",
    "1.2x",
    "1.1x",
    "1x",
    "0.9x",
    "0.75x",
    "0.5x",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: popoverBoxDecoration(context),
      width: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: StreamBuilder(
          stream: PlayerService().rateStream,
          builder: (context, asyncSnapshot) {
            var currentRate = 1.0;
            if (asyncSnapshot.hasData) {
              currentRate = asyncSnapshot.data!;
            } else {
              currentRate = PlayerService().rate;
            }

            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: speedLabels.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (currentRate == speeds[index]) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16,
                    ),
                    child: Text(
                      speedLabels[index],
                      textAlign: .start,
                      style: TextStyle(fontWeight: .bold),
                    ),
                  );
                } else {
                  return TextButton(
                    style: overlayTextButtonStyle(context),
                    onPressed: () {
                      print("select rate: ${speeds[index]}");
                      PlayerService().rate = speeds[index];
                    },
                    child: Align(
                      alignment: .centerStart,
                      child: Text(speedLabels[index], textAlign: .start),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
