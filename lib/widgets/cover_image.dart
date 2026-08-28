import 'package:flutter/widgets.dart';
import 'package:fl_audiobook/globals.dart' as globals;

class CoverImage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: globals.playerService.coverStream.stream,
      builder: (context, asyncSnapshot) {
        var image = globals.playerService.coverImage; 
        if (asyncSnapshot.hasData) {
          image = asyncSnapshot.data!; 
        }
        return image;
      },
    );
  }
}

