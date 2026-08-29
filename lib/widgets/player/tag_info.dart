import 'dart:math';
import 'package:fl_audiobook/player_page.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:flutter/material.dart';

class TagInfo extends StatelessWidget {
  const TagInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
              decoration: popoverBoxDecoration,
              width: max(size.width * 0.5, 200),
              height: size.height * .8,
      child: ListView.builder(
                padding: EdgeInsets.only(
                          top: 8,
                          left: 8,
                          right: 8,
                          bottom: 8,
                        ),
        itemCount: PlayerService().tags.length,
        
        itemBuilder: (BuildContext context, int index) {
          final tags = PlayerService().tags; 
          String key = tags.keys.elementAt(index);
          var value = tags[key]; 
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              crossAxisAlignment: .start,
              children: [
              Text(key, style: .new(fontSize: 12),), Text(value.toString(), softWrap: true, overflow: .fade,) 
            ],),
          );
        }),
    );
  }

}
