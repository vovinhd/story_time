import 'dart:ui';
import 'package:fl_audiobook/l10n/app_localizations.dart';
import 'package:fl_audiobook/services/config.dart';
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
    if (ConfigProvider().playbackStates.isEmpty){
      return Center(child: Column(
        mainAxisAlignment: .center,
        children: [
          _HintContent(onClick: onClick),
        ],
      ));
    }  
    return SizedBox(
      height: 200,
      child: _HintContent(onClick: onClick),
    );
  }
}

class _HintContent extends StatelessWidget {
  const new({
    super.key,
    required this.onClick,
  });

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          AppLocalizations.of(context)!.heroHintTitle,
          style: .new(fontSize: 32, fontWeight: .bold),
        ),
        Text(
          AppLocalizations.of(context)!.heroHintSubtitle,
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
    );
  }
}
