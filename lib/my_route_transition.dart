import 'package:flutter/material.dart';

class MyRouteTransition extends PageRouteBuilder {
  final Widget child;
  MyRouteTransition({required this.child,}) : super (
    transitionDuration: Duration(milliseconds: 300), 
    pageBuilder: (context, animation, secondaryAnimation) => child, 
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
   
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

    return SlideTransition(position: Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0)
    ).animate(curved), child: child);
  }
}