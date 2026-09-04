import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:yaru/yaru.dart';

class AnimatedPopover extends StatefulWidget {
  const new({
    super.key,
    required this.offset,
    required this.follower,
    required this.target,
    required this.tooltip,
    required this.icon,
    required this.child,
    this.width = 32,
    this.buttonStyleOverride,
    this.noBorder = false, 
  });

  final Widget child;
  final Offset offset;
  final Alignment follower;
  final Alignment target;
  final String tooltip;
  final Widget icon;
  final double width;
  final ButtonStyle? buttonStyleOverride; 
  final bool noBorder; 

  @override
  State<AnimatedPopover> createState() => _AnimatedPopoverState();
}

class _AnimatedPopoverState extends State<AnimatedPopover> {
  bool showPopover = false;
  double popoverOpacity = 0.0;
  Timer? popoverOpacityReset;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: showPopover,
      // portalFollower: Container(
      //   color: Colors.pink,
      // ),
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            popoverOpacityReset?.cancel();
            popoverOpacityReset = Timer(
              Duration(milliseconds: 100),
              () => setState(() {
                showPopover = false;
              }),
            );
            popoverOpacity = 0.0;
          });
        },
      ),

      child: PortalTarget(
        visible: showPopover,
        anchor: Aligned(follower: widget.follower, target: widget.target),
        portalFollower: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: showPopover ? 1 : 0),
          duration: Duration(milliseconds: 100),
          builder: (context, progress, child) {
            return Container(
              transform: Matrix4.translationValues(
                widget.offset.dx * progress,
                widget.offset.dy * progress,
                0,
              ),
              child: Opacity(opacity: progress, child: widget.child),
            );
          },
        ),

        child: Tooltip(
          message: widget.tooltip,
          child: SizedBox(
            width: widget.width,
            child:  widget.noBorder ?
             
              IconButton(
              style: widget.buttonStyleOverride,
              onPressed: () {
                setState(() {
                  showPopover = true;
                  popoverOpacity = 1.0;
                });
              },
              icon: widget.icon,
            )
             
             : YaruOptionButton(
              style: widget.buttonStyleOverride,
              onPressed: () {
                setState(() {
                  showPopover = true;
                  popoverOpacity = 1.0;
                });
              },
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}
