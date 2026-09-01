import 'package:fl_audiobook/l10n/app_localizations.dart';
import 'package:fl_audiobook/services/config.dart';
import 'package:fl_audiobook/tray.dart' as tray;
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class SettingsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// TODO hook up to things
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        onClose: (p0) => tray.hideOrClose(),
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        leading: YaruBackButton(),
        actions: [SizedBox(height: 34, width: 34)],
      ),

      body: Center(
        child: SizedBox(
          width: 800,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                var multiline = constraints.maxWidth < 500;
                // print(constraints);
                return ListView(
                  children: [
                    SettingsSection(
                      title: AppLocalizations.of(context)!.settingsPlayerSetting,
                      children: [
                        LabeledSettinsRow(
                          label: AppLocalizations.of(context)!.settingsSkipButtons,
                          sublabel: AppLocalizations.of(context)!.settingsSkipButtonsSubLabel,
                          multiline: false,
                          actionWidget: DropdownButton<Duration>(
                            items: [
                              DropdownMenuItem(
                                value: Duration(seconds: 10),
                                child: Text(AppLocalizations.of(context)!.settingsSecLabel(10)),
                              ),

                              DropdownMenuItem(
                                value: Duration(seconds: 30),
                                child: Text(AppLocalizations.of(context)!.settingsSecLabel(30)),
                              ),

                              DropdownMenuItem(
                                value: Duration(seconds: 60),
                                child: Text(AppLocalizations.of(context)!.settingsMinLabel(1)),
                              ),
                            ],
                            value: ConfigProvider().config.skipDuration,
                            onChanged: (newSelection) {
                              setState(() {
                                ConfigProvider().config.skipDuration =
                                    newSelection!;
                                ConfigProvider().SaveConfig();
                                ConfigProvider().notify();
                              });
                            },
                          ),
                        ),
                        LabeledSettinsRow(
                          label: AppLocalizations.of(context)!.settingsUnskip,
                          sublabel: AppLocalizations.of(context)!.settingsUnskipSubLabel,
                          actionWidget: DropdownButton<Duration>(
                            items: [
                              DropdownMenuItem(
                                value: Duration(seconds: 3),
                                child: Text(AppLocalizations.of(context)!.settingsSecLabel(3)),
                              ),

                              DropdownMenuItem(
                                value: Duration(seconds: 5),
                                child: Text(AppLocalizations.of(context)!.settingsSecLabel(5)),
                              ),

                              DropdownMenuItem(
                                value: Duration(seconds: 10),
                                child: Text(AppLocalizations.of(context)!.settingsSecLabel(10)),
                              ),
                            ],
                            value: ConfigProvider().config.unksipTimeout,
                            onChanged: (newSelection) {
                              setState(() {
                                ConfigProvider().config.unksipTimeout =
                                    newSelection!;
                                ConfigProvider().SaveConfig();
                                ConfigProvider().notify();
                              });
                            },
                          ),
                        ),
                        // LabeledSettinsRow(
                        //   label: "Reduce animations",
                        //   sublabel: "remove page transitions to prevent nausea",
                        //   actionWidget: Switch(
                        //     value: reduceAnimations,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         reduceAnimations = value;
                        //       });
                        //     },
                        //   ),
                        // ),

                        LabeledSettinsRow(
                          label: AppLocalizations.of(context)!.settingsPerformanceMode,
                          sublabel: AppLocalizations.of(context)!.settingsPerformanceModeSubLabel,
                          actionWidget: Switch(
                            value: ConfigProvider().config.performanceMode,
                            onChanged: (value) {
                              setState(() {
                                ConfigProvider().config.performanceMode = value;
                                ConfigProvider().SaveConfig();
                                ConfigProvider().notify();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: AppLocalizations.of(context)!.settingsSystem,
                      subttile: AppLocalizations.of(context)!.settingsSystemSubLabel,
                      children: [
                        LabeledSettinsRow(
                          label: AppLocalizations.of(context)!.settingsTray,
                          sublabel: AppLocalizations.of(context)!.settingsTraySubLabel,
                          actionWidget: DropdownButton<SystemTrayUsage>(
                            items: [
                              DropdownMenuItem(
                                value: SystemTrayUsage.always,
                                child: Text(AppLocalizations.of(context)!.settingsTrayAlways),
                              ),

                              DropdownMenuItem(
                                value: SystemTrayUsage.whenPlaying,
                                child: Text(AppLocalizations.of(context)!.settingsTrayWhenPlaying),
                              ),

                              DropdownMenuItem(
                                value: SystemTrayUsage.never,
                                child: Text(AppLocalizations.of(context)!.settingsTrayNever),
                              ),
                            ],
                            value: ConfigProvider().config.systemTrayUsage,
                            onChanged: (newSelection) {
                              setState(() {
                                ConfigProvider().config.systemTrayUsage =
                                    newSelection!;
                                ConfigProvider().SaveConfig();
                                ConfigProvider().notify();
                              });
                            },
                          ),
                        ),
                        // LabeledSettinsRow(
                        //   label: "Enable DBus integration",
                        //   sublabel: "Show player status on lock screen etc.",
                        //   actionWidget: Switch(
                        //     value: ConfigProvider().config.enableDBus,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         ConfigProvider().config.enableDBus = value;
                        //         ConfigProvider().SaveConfig();
                        //         ConfigProvider().notify();
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    ),

                    SettingsSection(
                      title: AppLocalizations.of(context)!.settingsDangerZone,
                      subttile: AppLocalizations.of(context)!.settingsDangerZoneSubLabel,
                      children: [
                        LabeledSettinsRow(
                          label: AppLocalizations.of(context)!.settingsClearCache,
                          sublabel: AppLocalizations.of(context)!.settingsClearCacheSubLabel,
                          actionWidget: FilledButton(
                            style: Theme.of(context).filledButtonTheme.style,
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(AppLocalizations.of(context)!.settingsClearCacheAlertTitle),
                                content: Text(
                                  AppLocalizations.of(context)!.settingsClearCacheAlertBody,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: Text(AppLocalizations.of(context)!.dialogCancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ConfigProvider().deleteCache();

                                      Navigator.pop(context, 'OK');
                                    },
                                    child: Text(AppLocalizations.of(context)!.dialogOk),
                                  ),
                                ],
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.settingsClearCache),
                          ),
                        ),

                        LabeledSettinsRow(
                          label: AppLocalizations.of(context)!.settingsDeleteHistory,
                          sublabel: AppLocalizations.of(context)!.settingsDeleteHistorySubLabel,
                          actionWidget: FilledButton(
                            style: Theme.of(context).filledButtonTheme.style,
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(AppLocalizations.of(context)!.settingsDeleteHistoryAlertTitle),
                                content: Text(
                                  AppLocalizations.of(context)!.settingsDeleteHistoryAlertBody,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: Text(AppLocalizations.of(context)!.dialogCancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ConfigProvider().deleteHistory();
                                      Navigator.pop(context, 'OK');
                                    },
                                    child: Text(AppLocalizations.of(context)!.dialogOk),
                                  ),
                                ],
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.settingsDeleteHistory),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    this.subttile,
    required this.children,
  });

  final String title;
  final String? subttile;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SectionLabel(label: title, sublabel: subttile),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [...children],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const new({super.key, required this.label, this.sublabel});

  final String label;
  final String? sublabel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(label, style: .new(fontWeight: .bold)),
          sublabel != null
              ? Text(
                  sublabel!,
                  style: .new(fontSize: 14, color: YaruColors.warmGrey),
                  softWrap: true,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class LabeledSettinsRow extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    this.sublabel,
    required this.actionWidget,
    this.multiline = false,
  });

  final String label;
  final String? sublabel;
  final multiline;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    if (multiline) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(label, style: .new(fontWeight: .bold)),
                    sublabel != null
                        ? Text(
                            sublabel!,
                            style: .new(
                              fontSize: 14,
                              color: YaruColors.warmGrey,
                            ),
                            softWrap: true,
                          )
                        : SizedBox(),
                  ],
                ),
                actionWidget,
              ],
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        spacing: 8,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(label, style: .new(fontWeight: .bold)),
                if (sublabel != null)
                  Text(
                    sublabel!,
                    style: .new(fontSize: 14, color: YaruColors.warmGrey),
                    softWrap: true,
                  )
                else
                  SizedBox(),
              ],
            ),
          ),
          actionWidget,
        ],
      ),
    );
  }
}
