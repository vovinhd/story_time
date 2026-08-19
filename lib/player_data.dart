import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

class PlayerModel extends ChangeNotifier { 
  late final player = Player();
  
  bool get fileLoaded => player.state.duration.inMicroseconds > 0; 

  

}