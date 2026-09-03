import 'package:story_time/services/player_service.dart';
import 'package:flutter/widgets.dart';

class CoverImage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PlayerService().coverStream.stream,
      builder: (context, asyncSnapshot) {
        var image = PlayerService().coverImage; 
        if (asyncSnapshot.hasData) {
          image = asyncSnapshot.data!; 
        }
        return image;
      },
    );
  }
}

