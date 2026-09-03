import 'dart:ui';
import 'package:fl_audiobook/l10n/app_localizations.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class HeroUsageHint extends StatelessWidget {
  const new({
    super.key,
    required this.onClick, required this.expand 
  });

  final VoidCallback onClick; 
  final bool expand;
   
  @override
  Widget build(BuildContext context) {
    if (expand){
      return Center(child: Column(
        mainAxisAlignment: .center,
        children: [
          _HintContent(onClick: onClick, height: 200, spacing: 30,),
        ],
      ));
    }  
    return SizedBox(
      height: 280,
      child: Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: _HintContent(onClick: onClick, height: 80, spacing: 10,),
      ),
    );
  }
}

class _HintContent extends StatelessWidget {
  const new({
    required this.onClick, this.height, this.spacing
  });

  final VoidCallback onClick;

  final double? height;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        spacing: spacing ?? 0,
        mainAxisAlignment: .center,
        children: [
          SizedBox(
            height: height,
            child: Image.asset(Theme.of(context).brightness == .dark ? 
              "images/cover_symbolic_dark.png" :  "images/cover_symbolic_light.png",
              key: UniqueKey(),
            ),
          ),

          
          Column(
            children: [
                        Text(
            AppLocalizations.of(context)!.heroHintTitle,
            style: .new(fontSize: 32, fontWeight: .bold),
          ),
              Text(
                AppLocalizations.of(context)!.heroHintSubtitle,
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: FilledButton(
                    onPressed: onClick,
                    style: .new(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(40)
                      )),
                      backgroundColor: WidgetStatePropertyAll(
                        YaruColors.adwaitaYellow,
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        YaruColors.porcelain,
                      ),
                      // mouseCursor: WidgetStatePropertyAll(SystemMouseCursors.click)
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.heroHintButtonLabel,
                      style: .new(fontWeight: .bold, fontSize: 16),
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
