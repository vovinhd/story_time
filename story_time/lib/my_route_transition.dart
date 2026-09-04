import 'package:flutter/material.dart';

class SettingsTransition extends PageRouteBuilder {
  final Widget child;
  SettingsTransition({required this.child,}) : super (
    transitionDuration: Duration(milliseconds: 300), 
    pageBuilder: (context, animation, secondaryAnimation) => child, 
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
   
      return FadeUpwardsPageTransitionsBuilder().buildTransitions(null, context, animation, secondaryAnimation, child); 
  }
}