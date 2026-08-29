import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class HeroUsageHint extends StatelessWidget {
  const new({
    super.key,
    required this.onClick
  });

  final VoidCallback onClick; 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          SizedBox(
            height: 60,
            child: Image.asset(
              "images/cover_default.png",
              key: UniqueKey(),
            ),
          ),
          Text(
            "Listen to audiobooks",
            style: .new(fontSize: 32, fontWeight: .bold),
          ),
          Text(
            "in .m4b format with metadata because this is programmed like crap",
          ),
    
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: TextButton(
                    onPressed: onClick,
                    style: .new(
                      backgroundColor: WidgetStatePropertyAll(
                        YaruColors.adwaitaYellow,
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        YaruColors.porcelain,
                      ),
                    ),
                    child: Text(
                      "Open Audiobook",
                      style: .new(fontWeight: .bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
